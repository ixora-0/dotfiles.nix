{ pkgs, lib, config, ... }: let
  cfg = config.modules.discord;
  mkIfElse = import ../../helpers/mkIfElse.nix { inherit lib; };

  catppuccinThemesSrc = pkgs.fetchgit {
    url = "https://github.com/catppuccin/discord";
    sparseCheckout = ["themes"];
    hash = "sha256-juS6ZG+yonkUPgJOhcQtkdT+ftMHYhejAQNX9vQ0Qvg=";
  } + /themes;
in
{
  # TODO: declarative ~/.config/Vencord/setting/settings.json
  # maybe see https://github.com/FlafyDev/nixos-config/commit/5cd0781bae16fed8007513c24434890909c1a680
  options.modules.discord.vesktop.enable = lib.mkEnableOption ''
    Whether to install vesktop instead of dicord with vencord.
    Good if want to share screen properly in wayland.
  '';

  config.xdg.configFile = (mkIfElse cfg.vesktop.enable 
    # NOTE: might have to delete the themes folder if one already exist in order to symlink it
    # alternatively, specify a specific theme instead of the whole folder like
    # { "vesktop/themes/mocha.theme.css".source = catppuccinThemesSrc + "/mocha.theme.css"; }

    { "vesktop/themes".source = catppuccinThemesSrc; }
    { "Vencord/themes".source = catppuccinThemesSrc; }
  );
  config.home.packages = with pkgs; [
    (mkIfElse cfg.vesktop.enable
      (vesktop.override {
        withSystemVencord = false;  # letting vesktop manage it's own version
                                    # which fixes the no vencord section in settings issue
      })
      (discord.override {
        withOpenASAR = true;
        withVencord = true;
      })
    )
  ];
}
