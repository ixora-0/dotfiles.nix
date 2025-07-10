{ inputs, pkgs, pkgs-unstable, ... }: let
  quickshell = inputs.quickshell.packages.${pkgs.system}.default;
  selfPkgs = import ../../pkgs {
    inherit pkgs quickshell;
  };
in {
  # NOTE: config for illogical impulse is not declared here, modify in runtime
  # BUG: weather GPS not working, set city + disable gps in settings
  # BUG: some app icons not working
  # TODO: multimonitor, ddcutil
  home.packages = [
    selfPkgs.illogical-impulse-qs-launcher
    selfPkgs.illogical-impulse-oneui4-icons  # TODO: move to theme.nix
    quickshell

    pkgs.swww

    # for custom apps
    pkgs.bluetuith
    pkgs.networkmanager

    # have to install these for user, not in derivation, for some reason
    pkgs.hyprshot
    pkgs.hyprpicker

    # fonts
    pkgs.rubik
    # NOTE: need to use from unstable for now, need bookmark_heart symbol
    # can also add in fonts.nix instead
    pkgs-unstable.material-symbols

  ];

  # symlink files to .config
  home.file.".config/quickshell" = {
    source = "${selfPkgs.illogical-impulse-qs}";
    recursive = true;
  };
  home.file.".config/matugen" = {
    source = "${selfPkgs.illogical-impulse-matugen}";
    recursive = true;
  };
  home.file.".config/Kvantum" = {
    source = "${selfPkgs.illogical-impulse-kvantum}";
    recursive = true;
  };

  # portal-gtk to make gsettings work
  xdg.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    configPackages = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = ["*"];
  };

  # daemon for handling secrets (api keys)
  services.gnome-keyring.enable = true;
}
