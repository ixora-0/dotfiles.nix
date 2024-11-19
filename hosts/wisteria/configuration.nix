{ pkgs, inputs, ... }: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  system.stateVersion = "24.05";
  wsl.enable = true;
  wsl.defaultUser = "ixora";
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
