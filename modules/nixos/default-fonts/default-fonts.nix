{
  # HACK: have to set default fonts system-wide via configuration.nix
  # waiting for https://github.com/nix-community/home-manager/pull/2732
  # TODO: add module option
  fonts = {
    fontconfig.enable = true;
    fontconfig.defaultFonts = {
      serif =     ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      emoji =     ["Noto Color Emoji"];
      monospace = ["Iosevka Iris" "NerdFontsSymbolsOnly"];
    };
  };
}
