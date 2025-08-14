{ lib, pkgs,... }: {
  # Some packages (ahci fail... this bypasses that) https://discourse.nixos.org/t/does-pkgs-linuxpackages-rpi3-build-all-required-kernel-modules/42509
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  nixpkgs.hostPlatform = "aarch64-linux";
  # ! Need a trusted user for deploy-rs.
  nix.settings.trusted-users = ["@wheel"];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  sdImage = {
    imageName = "ren.img";
    compressImage = false;

    extraFirmwareConfig = {
      # Give up VRAM for more Free System Memory
      # - Disable camera which automatically reserves 128MB VRAM
      start_x = 0;
      # - Reduce allocation of VRAM to 16MB minimum for non-rotated (32MB for rotated)
      gpu_mem = 16;

      # Configure display to 800x600 so it fits on most screens
      # * See: https://elinux.org/RPi_Configuration
      hdmi_group = 2;
      hdmi_mode = 8;
    };
  };

  hardware = {
    enableRedistributableFirmware = lib.mkForce false;
    firmware = [ pkgs.raspberrypiWirelessFirmware ]; # Keep this to make sure wifi works
    i2c.enable = true;

    deviceTree = {
      enable = true;
      kernelPackage = pkgs.linuxKernel.packages.linux_rpi3.kernel;
      filter = "*2837*";

      overlays = [
        {
          name = "enable-i2c";
          dtsFile = ./dts/i2c.dts;
        }
        {
          name = "pwm-2chan";
          dtsFile = ./dts/pwm.dts;
        }
      ];
    };
  };

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_rpi02w;
    # kernelPackages = lib.mkForce pkgs.linuxPackages_latest;

    initrd.availableKernelModules = [
      "xhci_pci"
      "usbhid"
      "usb_storage"
    ];
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };

    # Avoids warning: mdadm: Neither MAILADDR nor PROGRAM has been set. This will cause the `mdmon` service to crash.
    # See: https://github.com/NixOS/nixpkgs/issues/254807
    swraid.enable = lib.mkForce false;

    # needed for deploy-rs
    binfmt.emulatedSystems = ["x86_64-linux"];
  };

  # fileSystems = {
  #   "/" = {
  #     device = "/dev/disk/by-label/NIXOS_SD"; # name of sd card when written
  #     fsType = "ext4";
  #     options = [ "noatime" ];
  #   };
  # };


  # networking.networkmanager.enable = true;  # doesn't work
  networking = {
    wireless = {
      enable = false;
      iwd.enable = true;
      interfaces = [ "wlan0" ];
    };
    interfaces."wlan0".useDHCP = true;
  };
  services.tailscale.enable = true;

  users.users.ixora = {
    isNormalUser = true;
    description = "ixora";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICEXyeHgxvkazcu8oufOYe97ZL94secVndK4RC5XSLqj 39961970+ixora-0@users.noreply.github.com"];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  services.getty.autologinUser = lib.mkForce "ixora";

  environment.systemPackages = with pkgs; [
    deploy-rs
    vim
  ];
  environment.enableAllTerminfo = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.stateVersion = "25.05";  # careful when change
}
