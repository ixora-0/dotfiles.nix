{ pkgs, helpers, ...}: {
  imports = map helpers.importHomeModule [
    "neofetch"
    "zellij"
  ];
  home.packages = with pkgs; [
    tealdeer
    lazydocker
    unrar
    glow
    gh
    scc
    ncdu
  ];
}
