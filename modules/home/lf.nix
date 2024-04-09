{ pkgs, ... }: {
  xdg.configFile."lf/icons".source =  pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/gokcehan/lf/master/etc/icons.example";
    sha256 = "0141nzyjr3mybkbn9p0wwv5l0d0scdc2r7pl8s1lgh11wi2l771x";
  };

  programs.lf = {
    enable = true;

    settings = {
      preview = true;
      drawbox = true;
      hidden = true;
      icons = true;
    };
  };
}
