{ inputs, ... }: {
  imports = [inputs.nixcord.homeModules.nixcord];
  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
    discord.enable = false;
  };
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
      callTimer.enable = true;
    };
  };
}

