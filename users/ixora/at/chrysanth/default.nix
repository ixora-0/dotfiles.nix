{ helpers, pkgs, ... }: {
  targets.genericLinux.enable = true;
  imports = (map helpers.importBundle [
    "core-terminal"
    "extra-terminal"
    "core-apps"
    "extra-apps"
  ]) ++ (map helpers.importHomeModule [
    # packages that has configurations
    "gnome-keyring"
    "quickshell"
    "hyprland"
    "theme"
    "direnv"
    "fonts"
    "sioyek"
  ]) ++ [
    # ./games.nix
  ];
  modules.helix.languages.lsp.nil.enable = true;
  modules.helix.languages.prettier.enable = true;

  # NOTE: installing hyprland with pacman instead of nix
  # experiencing issues with monitors when using hyprland from nix
  # wayland.windowManager.hyprland = {
  #   package = lib.mkForce inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #   portalPackage = lib.mkForce inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  # };

  # NOTE: disabling hyprexpo, doesn't work for new version of hyprland
  # https://github.com/hyprwm/hyprland-plugins/issues/534
  modules.hyprland.plugins.enable = false;

  # NOTE: On non-NixOS distros, programs using PAM (typically screen locker)
  # will not work if installed via Nix
  # https://github.com/nix-community/home-manager/issues/7027
  # -> install hyprlock via paru, disable qs locking in ii settings
  programs.hyprlock.enable = true;  # to symlink settings
  programs.hyprlock.package = null;  # install via paru

  # NOTE: install and setup silentSDDM
  # paru -S sddm-silent-theme, then download images, config manually

  home.packages = with pkgs; [
    ghostty
    paru
  ];
}
