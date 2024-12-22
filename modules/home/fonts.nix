{ pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    (iosevka.override {
      set = "Iris";
      privateBuildPlan = builtins.readFile ../nixos/default-fonts/private-build-plans.toml;
    })
    (iosevka-bin.override { variant = "Aile"; })
    (nerdfonts.override { fonts = ["NerdFontsSymbolsOnly"]; })
    corefonts vistafonts
  ];
}
