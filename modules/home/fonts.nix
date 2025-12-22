{ inputs, pkgs, ... }: {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      serif =     ["Noto Serif" "Symbols Nerd Font"];
      sansSerif = ["Noto Sans" "Symbols Nerd Font"];
      emoji =     ["Noto Color Emoji"];
      monospace = ["Iosevka Iris" "Symbols Nerd Font Mono"];
    };
  };

  home.packages = with pkgs; [
    # core
    font-manager
    noto-fonts noto-fonts-cjk-sans noto-fonts-color-emoji
    inputs.iosevka-iris.packages.${pkgs.stdenv.hostPlatform.system}.default

    nerd-fonts.symbols-only
    corefonts vista-fonts

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
