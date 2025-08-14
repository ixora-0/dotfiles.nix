{ pkgs, lib, helpers, ... }: {
  # imports = (map helpers.importBundle [
  #   "core-terminal"
  # ]);
  imports = map helpers.importHomeModule [
    "zsh"
    "helix"
    "eza"
    "zoxide"
    "yazi"
    "git"
    "neofetch"
  ];
  modules.zsh.plugins.fastSyntaxHighlighting.enable = lib.mkDefault true;
  modules.zsh.plugins.powerlevel10k.enable = lib.mkDefault true;
  # programs.zellij.enableZshIntegration = true;

  # home.packages = (with pkgs; [
  #   git
  # ]);
}
