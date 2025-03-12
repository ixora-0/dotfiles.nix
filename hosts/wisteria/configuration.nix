{ config, pkgs, inputs, lib, helpers, ... }: {
  # TODO: make docker + gpu possible
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ] ++ (map helpers.importHomeModule [
    "direnv"
  ]);
  system.stateVersion = "24.05";
  hardware.opengl.enable = true;

  wsl.useWindowsDriver = true;
  wsl.nativeSystemd = true;
  environment.variables = {
    "NIX_LD_LIBRARY_PATH" = lib.mkForce "/usr/lib/wsl/lib";
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.package = pkgs.nix-ld-rs;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      features.cdi = true;
    };
  };
  hardware = {
    nvidia = {
      nvidiaSettings = false;
      open = true;
    };
  };
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia-container-toolkit.enable = true;
  hardware.nvidia-container-toolkit.mount-nvidia-executables= false;

  wsl.enable = true;
  wsl.defaultUser = "ixora";
  wsl.docker-desktop.enable = true;

  environment.systemPackages = with pkgs; [
      vim
  ];
  programs.zsh.enable = true;
  users.users.ixora = {
    shell = pkgs.zsh;
  };

  time.timeZone = "America/Kentucky/Louisville";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  fileSystems."/home/ixora/intaa" = {
    depends = ["/mnt/d"];
    device = "/mnt/d";
    options = ["bind"];
  };
  # fileSystems."/home/ixora/.ssh" = {
  #   depends = ["/home/ixora/intaa"];
  #   device = "/home/ixora/intaa/.ssh";
  #   fsType = "ext4";
  #   options = ["bind" "rw" "user"];
  # };

  # NOTE: doesn't work
  fileSystems."/mnt/nerine" = {
    device = "/dev/disk/by-uuid/7c4a8442-93d4-40a4-b30c-d13e4a852c6c";
    fsType = "ext4";
  };
}
