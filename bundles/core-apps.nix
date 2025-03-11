{ helpers, ...}: {
  imports = map helpers.importHomeModule [
    "kitty"
    "spotify"
    "firefox"
    "discord"
    "nemo"
  ];
  # home.packages = with pkgs; [
    # firefox-devedition
    # gnome.nautilus nautilus-open-any-terminal
  # ];
}
