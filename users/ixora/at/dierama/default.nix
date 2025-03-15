{ pkgs, helpers, ... }: {
  imports = (map helpers.importBundle [
    "core-terminal"
    "extra-terminal"
  ]);
  modules.helix.languages.lsp.nil.enable = true;
  programs.zellij.enableZshIntegration = true;

  home.packages = (with pkgs; [
    git
  ]);
}
