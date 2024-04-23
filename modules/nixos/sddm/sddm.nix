{ pkgs, ... }: let
  theme = pkgs.stdenv.mkDerivation {
    name = "sddm-theme";
    src = pkgs.fetchFromGitHub {
      owner = "stepanzubkov";
      repo = "where-is-my-sddm-theme";
      rev = "350555f40aa4e451b47a672d07085fc6ce7f4e0d";
      sha256 = "0clk3b743qh7m52my0jdzrdk3d97b2qxjdqci2dy3rq40zhy4ggw";
    };
    installPhase = ''
      mkdir -p $out
      cp -R ./where_is_my_sddm_theme_qt5/* $out/
    '';

  };
in
{
  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "${theme}";
  };
}
