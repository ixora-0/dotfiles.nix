{ pkgs, ... }: {
  xdg.configFile."neofetch/config.conf".source = ./config.conf;
  home.packages = [pkgs.neofetch];
}
