{ pkgs, lib, helpers, ...}: {
  imports = map helpers.importHomeModule [
    "kitty"
    "spotify"
    "firefox"
    "discord"
  ];
  modules.discord.vesktop.enable = lib.mkDefault true;
  home.packages = with pkgs; [
    # firefox-devedition
    # gnome.nautilus nautilus-open-any-terminal
    nemo  # BUG: open in terminal doesn't work
  ];
}
