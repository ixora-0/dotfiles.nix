{ config, pkgs, ... }: let
  port = 8443;
  ns = "vpn";
in {
  networking.firewall.allowedUDPPorts = [port];
  networking.networkmanager.unmanaged = ["type:wireguard"];

  systemd.services.wg-netns = {
    description = "Wireguard Network Namespace";

    wantedBy = [ "multi-user.target" ];
    after = [ "network-pre.target" ];
    wants = [ "network-pre.target"  ];

    before = [ "wireguard-usbos001.service" ];
    requiredBy = [ "wireguard-usbos001.service" ];


    serviceConfig = let
      resolvconf = pkgs.writeText "resolv.conf" ''
        nameserver 10.64.0.1
      '';

      nsswitchconf = pkgs.writeText "nsswitch.conf" ''
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
      '';

      startScript = pkgs.writeShellScriptBin "wg-netns-start" ''
        set -euo pipefail

        ${pkgs.coreutils}/bin/mkdir -p /etc/netns/${ns}
        ${pkgs.coreutils}/bin/ln -sfn ${resolvconf} /etc/netns/${ns}/resolv.conf
        ${pkgs.coreutils}/bin/ln -sfn ${nsswitchconf} /etc/netns/${ns}/nsswitch.conf
        ${pkgs.iproute2}/bin/ip netns add ${ns} 2>/dev/null || true

        # if using nsenter
        # ${pkgs.iproute2}/bin/ip netns exec vpn ${pkgs.bash}/bin/bash -c '
        #   ${pkgs.mount}/bin/mount --bind /var/empty /var/run/nscd && exec sleep infinity
        # '
      '';

      stopScript = pkgs.writeShellScriptBin "wg-netns-stop" ''
        ${pkgs.iproute2}/binip netns pids ${ns} | xargs -r kill
        ${pkgs.iproute2}/binip netns del ${ns}
      '';
    in {
      Type = "simple";
      RemainAfterExit = true;

      ExecStart = "${startScript}/bin/wg-netns-start";

      ExecStop = "${stopScript}/bin/wg-netns-stop";

      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_SYS_ADMIN"
      ];
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_SYS_ADMIN"
      ];

      KillMode = "mixed";
    };
  };

  sops.secrets.mullvad_private_key = {
    sopsFile = ../../../secrets/nerine.json;
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
  environment.systemPackages = [(pkgs.writeShellScriptBin "execnetns" ''
    NAMESPACE=$1
    shift

    # can't run gui apps in hyprland with nsenter
    # VPN_PID=$(sudo ip netns pids "$NAMESPACE" | head -1)
    # sudo nsenter -t "$VPN_PID" -n -m sudo -u "$USER" "$@"

    # diaable nscd to avoid dns leak
    sudo ip netns exec "$NAMESPACE" bash -c "
        mount --bind /var/empty /var/run/nscd 2>/dev/null || true
        exec sudo -u $USER \"\$@\"
    " __ "$@"
  '')];
}
