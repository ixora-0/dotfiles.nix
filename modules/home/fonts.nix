{ inputs, pkgs, ... }: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # core
    font-manager
    noto-fonts noto-fonts-cjk-sans noto-fonts-emoji
    inputs.iosevka-iris.packages.${pkgs.system}.default

    nerd-fonts.symbols-only
    corefonts vistafonts

    # sets
    ibm-plex

    # serifs
    roboto-slab
    merriweather
    crimson-pro
    (iosevka-bin.override { variant = "Etoile"; })
    source-serif-pro
    libre-baskerville

    # sans
    merriweather-sans
    (iosevka-bin.override { variant = "Aile"; })
    source-sans

    # monos
    victor-mono
  ];
}
