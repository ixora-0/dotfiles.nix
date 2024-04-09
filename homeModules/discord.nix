{ pkgs, ... }: let
  catppuccinThemesSrc = pkgs.fetchgit {
    url = "https://github.com/catppuccin/discord";
    sparseCheckout = ["themes"];
    hash = "sha256-juS6ZG+yonkUPgJOhcQtkdT+ftMHYhejAQNX9vQ0Qvg=";
  } + /themes;
in
{
  # TODO: declarative ~/.config/Vencord/setting/settinngs.json
  # maybe see https://github.com/FlafyDev/nixos-config/commit/5cd0781bae16fed8007513c24434890909c1a680
  xdg.configFile."Vencord/themes".source = catppuccinThemesSrc;
  home.packages = [
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
  ];
}
