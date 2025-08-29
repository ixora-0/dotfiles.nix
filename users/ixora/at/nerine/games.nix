{ pkgs, pkgs-unstable, ... }: {
  home.packages = (with pkgs; [
    protonup-qt

    badlion-client
  ]) ++ (with pkgs-unstable; [
    # osu-lazer-bin
    gdlauncher-carbon
  ]);

  programs.mangohud.enable = true;
  # programs.lutris.enable = true;
}
