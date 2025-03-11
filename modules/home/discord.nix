{ inputs, pkgs-unstable, ... }: {
  # NOTE: some features broken rn
  imports = [inputs.nixcord.homeManagerModules.nixcord];
  programs.nixcord.enable = true;
  programs.nixcord.vesktop.enable = true;
  programs.nixcord.vesktop.package = pkgs-unstable.vesktop;
  programs.nixcord.discord.enable = false;
  programs.nixcord.vesktopConfig = {
    themeLinks = ["https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"];
    plugins = {
      biggerStreamPreview.enable = true;
      gameActivityToggle.enable = true;
      volumeBooster.enable = true;
      fixYoutubeEmbeds.enable = true;
      youtubeAdblock.enable = true;
      spotifyControls.enable = true;
      spotifyCrack.enable = true;

      silentTyping.enable = true;
      silentTyping.showIcon = true;

      # crashes for some reason
      # callTimer.enable = true;
    };
  };
}
