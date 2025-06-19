{ inputs, ... }: {
  # NOTE: pretty broken on linux rn, maybe later
  imports = [inputs.nixcord.homeModules.nixcord];
  programs.nixcord = {
    enable = true;
    dorion.enable = true;
    discord.enable = false;
  };
  programs.nixcord.dorion = {
  };
}
