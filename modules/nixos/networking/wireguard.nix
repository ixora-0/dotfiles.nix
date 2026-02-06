{ config, pkgs, ... }: let
  port = 8443;
  ns = "vpn";
in {
  # NOTE: please check ip is correct and no dns leak when rebuild if using this module
  # probably very dependent on each system

  networking.firewall.allowedUDPPorts = [port];
  networking.networkmanager.unmanaged = ["type:wireguard"];

  systemd.services.wg-netns = {
    description = "Wireguard Network Namespace";

    wantedBy = [ "multi-user.target" "wireguard-usbos001.service" ];
    after = [ "network-pre.target" ];
    wants = [ "network-pre.target" ];
    requiredBy = [ "wireguard-usbos001.service" ];
    before = [ "wireguard-usbos001.service" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStartPre = [
        "-${pkgs.iproute2}/bin/ip netns delete ${ns}"
      ];
      ExecStart = [
        "${pkgs.iproute2}/bin/ip netns add ${ns}"
      ];
      ExecStop = [
        "${pkgs.iproute2}/bin/ip netns del ${ns}"
        "-${pkgs.util-linux}/bin/umount /run/mntns/${ns}"
        "-${pkgs.coreutils}/bin/rm /run/mntns/${ns}"
      ];

      CapabilityBoundingSet = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];
      AmbientCapabilities = [ "CAP_NET_ADMIN" "CAP_SYS_ADMIN" ];

      KillMode = "mixed";
    };
  };

  sops.secrets.mullvad_private_key = {
    sopsFile = ../../../secrets/nerine.json;
    restartUnits = [ "wireguard-usbos001.service" ];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = let
    us-bos-wg-001 = "43.225.189.131";
  in {
    "usbos001" = {
      interfaceNamespace = ns;

      # ip route add <endpoint_ip> via <gateway> dev <network_interface>
      # https://wiki.archlinux.org/title/WireGuard#Loop_routing
      postSetup = ''
        ${pkgs.iproute2}/bin/ip route add ${us-bos-wg-001} via $(${pkgs.iproute2}/bin/ip route show default | ${pkgs.gawk}/bin/awk '/default/ {print $3}') dev $(${pkgs.iproute2}/bin/ip route show default | ${pkgs.gawk}/bin/awk '/default/ {print $5}') || true
      '';
      postShutdown = ''
        ${pkgs.iproute2}/bin/ip route del ${us-bos-wg-001} || true
      '';

      ips = [
        "10.68.238.111/32"
        "fc00:bbbb:bbbb:bb01::5:ee6e/128"
      ];
      listenPort = port;

      # dns = ["10.64.0.1"];

      privateKeyFile = config.sops.secrets.mullvad_private_key.path;
      peers = [
        {
          publicKey = "CsysTnZ0HvyYRjsKMPx60JIgy777JhD0h9WpbHbV83o=";
          allowedIPs = [ "0.0.0.0/0" "::0/0" ];
          endpoint = "${us-bos-wg-001}:${builtins.toString port}";
        }
      ];
    };
  };

  environment.systemPackages = [(pkgs.writeShellScriptBin "nsexec" ''
    set -euo pipefail

    NAMESPACE=$1
    shift

    RESOLVCONF=${pkgs.writeText "resolv.conf" ''
      nameserver 10.64.0.1
    ''}

    NSSWITCHCONF=${pkgs.writeText "nsswitch.conf" ''
      passwd:    files systemd
      group:     files [success=merge] systemd
      shadow:    files systemd
      sudoers:   files

      hosts:     mymachines files myhostname dns
      networks:  files

      ethers:    files
      services:  files
      protocols: files
      rpc:       files
    ''}

    # create persistent mount namespace if doesn't exist
    if [ ! -f "/run/mntns/$NAMESPACE" ]; then
      sudo ${pkgs.coreutils}/bin/mkdir -p /run/mntns/
      sudo ${pkgs.mount}/bin/mount --bind --make-private /run/mntns /run/mntns
      sudo ${pkgs.coreutils}/bin/touch /run/mntns/$NAMESPACE

      sudo ${pkgs.util-linux}/bin/nsenter --net=/run/netns/$NAMESPACE \
        ${pkgs.util-linux}/bin/unshare --mount=/run/mntns/$NAMESPACE ${pkgs.bash}/bin/bash -c "
          # disable nscd to avoid dns leak
          ${pkgs.mount}/bin/mount --bind /var/empty /var/run/nscd
          ${pkgs.mount}/bin/mount --bind $RESOLVCONF /etc/resolv.conf
          ${pkgs.mount}/bin/mount --bind $NSSWITCHCONF /etc/nsswitch.conf
        "
    fi

    sudo ${pkgs.util-linux}/bin/nsenter --net=/run/netns/$NAMESPACE --mount=/run/mntns/$NAMESPACE sudo -u "$USER" \
      env XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
          WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
          DISPLAY="$DISPLAY" \
     "$@"
  '')];}
