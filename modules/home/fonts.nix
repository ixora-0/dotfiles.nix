{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    (iosevka.override {
      set = "Iris";
      privateBuildPlan = builtins.readFile ../nixos/default-fonts/private-build-plans.toml;
    })
    (nerdfonts.override {
      fonts = ["NerdFontsSymbolsOnly"];
    })
    corefonts
    vistafonts
  ];
}
