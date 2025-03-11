# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, helpers, ... }: {
  # TODO: organize configuration.nix into modules

  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ./battery.nix
    ./amd-pstate.nix
  ] ++ (map helpers.importNixosModule [
    "boot"
    "locale"
    "input"
    "sound"
    "default-fonts"
    "sddm"
    "sops"
    "open-webui"
    "auto-cpufreq"
    "lanzaboote"
  ]);

  services.fstrim.enable = true;
  hardware.asus.battery.chargeUpTo = 60;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Tor
  services.tor.enable = true;
  services.tor.client.enable = true;
  services.privoxy.enable = true;
  services.privoxy.enableTor = true;
  services.privoxy.settings.listen-address = "127.0.0.1:8118";

  services.automatic-timezoned.enable = true;
  # NOTE: This might be set by default in the future.
  # See https://github.com/NixOS/nixpkgs/issues/321121
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  hardware.graphics.enable = true;  # do not need to set manually
  hardware.graphics.enable32Bit = true;

  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];

  programs.hyprland.enable = true;
  # Graphical session to pre-select in the session chooser
  services.displayManager.defaultSession = "hyprland";

  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #   config.common.default = [ "*" ];
  # };

  # services for ags stuffs
  services = {
    asusd.enable = true;
    asusd.enableUserService = true;

    gvfs.enable = true;
    udisks2.enable = true;  # info about storage devices
    upower.enable = true;  # power management
  };

  # enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings.General.Experimental = true;  # for gnome-bluetooth percentage
  # services.blueman.enable = true;

  # brightness control
  hardware.brillo.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ixora = {
    isNormalUser = true;
    description = "ixora";
    extraGroups = [
      "networkmanager" 
      "wheel" 
      "video"  # for brightness control
      "uinput"  # needed for something in ags
      "docker"
    ];
    # packages = with pkgs; [ungoogled-chromium alsa-utils];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;  # also set in zsh.nix module
                               # but nixos-rebuild complains if we don't have this

  programs.gnupg.agent.enable = true;  # can't set this in home-manager

  # # add nur overlay
  # nixpkgs.config.packageOverrides = pkgs: {
  #   nur = import (builtins.fetchTarball {
  #     url = "https://github.com/nix-community/NUR/archive/14f7736a89ffa94603db2d0479c0622a80091718.tar.gz";
  #     sha256 = "1c8vn38zniyf0i5ssqwp9pw3dfww1yrz0s4r4jyhb7b5f6l82xl7";
  #   }) {
  #     inherit pkgs;
  #   };
  # };

  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    libsForQt5.qt5.qtgraphicaleffects  # for sddm theme
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
