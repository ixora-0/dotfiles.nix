# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, inputs, helpers, ... }: {
  # TODO: organize configuration.nix into modules

  imports = [
    ./hardware-configuration.nix
    ./battery.nix
    ./graphics.nix
    ./amd-pstate.nix
  ] ++ (map helpers.importNixosModule [
    "boot"
    "locale"
    "input"
    "sound"
    "sops"
    "auto-cpufreq"
    "lanzaboote"
    "gaming"
    "networking"
  ]);

  services.fstrim.enable = true;

  services.automatic-timezoned.enable = true;
  # NOTE: This might be set by default in the future.
  # See https://github.com/NixOS/nixpkgs/issues/321121
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  # gnome keyring (for llm api keys in quickshell)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # ssh
  programs.ssh.startAgent = false;  # using gnome keyring as ssh agent
  services.openssh.enable = true;
  fileSystems."/home/ixora/.ssh" = {
    depends = ["/home/ixora/intaa"];
    device = "/home/ixora/intaa/.ssh";
    options = ["bind"];
  };

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ixora = {
    isNormalUser = true;
    description = "ixora";
    extraGroups = [
      "networkmanager" 
      "wheel" 
      "video"  # for brightness control
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
  sops.secrets.netrc.sopsFile = ../../secrets/common.json;
  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://attic.ixora-0.dev/fonts"
    ];
    trusted-substituters = [
      "https://hyprland.cachix.org"
      "https://attic.ixora-0.dev/fonts"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "fonts:NSQhVo8Wc9qzPdKiXrufZ9qW+MKv6j1JMfSNES0VY0o="
    ];
    netrc-file = config.sops.secrets.netrc.path;
  };
}
