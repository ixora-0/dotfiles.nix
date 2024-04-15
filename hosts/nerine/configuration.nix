# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }: let
  nixosModuleImport = import ../../helpers/nixosModuleImport.nix;
in
{
  # TODO: organize configuration.nix into modules

  imports =[
    ./hardware-configuration.nix
  ] ++ (map nixosModuleImport [
    "boot"
    "locale"
    "input"
    "fonts"
  ]);

  networking.hostName = "nerine"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Kentucky/Louisville";

  # enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;  # required

    # can cause sleep/suspend to fail
    # enable if graphical corruption issues or application after waking
    powerManagement.enable = false;

    # (experimental) turn off gpu when not in use
    powerManagement.finegrained = false;

    # only from driver 515.43.04+
    # currently alpha-quality/buggy, false is currently the recommened setting
    open = false;

    # enable the nvidia settings menu,
    # accessible via `nvidia-settings`
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;  # 550
  };

  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];
  services.xserver.videoDrivers = ["nvidia"];  # load nvidia driver for xorg and wayland
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${import ../../modules/nixos/sddm-theme.nix { inherit pkgs; }}";
  };

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
  };

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
    power-profiles-daemon.enable = true;
    accounts-daemon.enable = true;  # info about users
  };


  # enable sound with pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;  # rtkit is optional but recommended
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
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
    ];
    # packages = with pkgs; [ungoogled-chromium alsa-utils];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;  # also set in zsh.nix module
                               # but nixos-rebuild complains if we don't have this

  programs.gnupg.agent.enable = true;  # can't set this in home-manager

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # # add nur overlay
  # nixpkgs.config.packageOverrides = pkgs: {
  #   nur = import (builtins.fetchTarball {
  #     url = "https://github.com/nix-community/NUR/archive/14f7736a89ffa94603db2d0479c0622a80091718.tar.gz";
  #     sha256 = "1c8vn38zniyf0i5ssqwp9pw3dfww1yrz0s4r4jyhb7b5f6l82xl7";
  #   }) {
  #     inherit pkgs;
  #   };
  # };

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
