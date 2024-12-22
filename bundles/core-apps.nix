{ pkgs, lib, helpers, ...}: {
  imports = map helpers.importHomeModule [
    "kitty"
    "spotify"
    "firefox"
    "discord"
  ];
  home.packages = with pkgs; [
    # firefox-devedition
    # gnome.nautilus nautilus-open-any-terminal
    nemo  # BUG: open in terminal doesn't work
  ];
}
