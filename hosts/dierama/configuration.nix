{ pkgs, pkgs-unstable, helpers, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./services/compose.nix ./services/compose-patches.nix
  ] ++ (map helpers.importNixosModule [
    "locale"
    "sops"
  ]);

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  services.automatic-timezoned.enable = true;
  services.geoclue2.geoProviderUrl = "https://api.beacondb.net/v1/geolocate";

  users.users.ixora = {
    isNormalUser = true;
    description = "ixora";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  services.getty.autologinUser = "ixora";

  environment.systemPackages = with pkgs; [
    pkgs-unstable.ghostty.terminfo
    vim
  ];

  services.openssh.enable = true;
  programs.ssh.startAgent = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # auto-update nixos config from compose.yaml
  # HACK: this is not reproducible (dependent on location of flake)
  # https://github.com/aksiksi/compose2nix/discussions/83
  systemd.services.watch-compose = let 
    here = "/home/ixora/dotfiles.nix/hosts/dierama";
    compose_yaml_path = "${here}/services/compose.yaml";
    compose_nix_path = "${here}/services/compose.nix";
    compose2nix_cmd = "${pkgs.compose2nix}/bin/compose2nix --runtime docker --inputs=${compose_yaml_path} --output=${compose_nix_path}";
  in {
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User="ixora";
      ExecStart="${pkgs.watchexec}/bin/watchexec -w ${compose_yaml_path} -- ${compose2nix_cmd}";
    };
  };

  system.stateVersion = "24.11";  # careful when change
}
