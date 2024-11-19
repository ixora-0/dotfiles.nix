{ pkgs, lib, helpers, ...}: {
  imports = map helpers.importHomeModule [
    "zsh"
    "helix"
    "eza"
    "zoxide"
    "yazi"
    "git"
  ];
  modules.zsh.plugins.fastSyntaxHighlighting.enable = lib.mkDefault true;
  modules.zsh.plugins.powerlevel10k.enable = lib.mkDefault true;
  modules.helix.languages.lsp.nil.enable = lib.mkDefault true;

  home.packages = with pkgs; [
    bat
    fzf
    ripgrep
    repgrep
    unzip
    bottom
    lazygit
  ] ++ [
    (import (helpers.importHomeModule "rgf") pkgs)
  ];
}
