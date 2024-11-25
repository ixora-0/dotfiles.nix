{ pkgs, helpers, ...}: {
  imports = map helpers.importHomeModule [
    "neofetch"
    "zellij"
  ];
  home.packages = with pkgs; [
    tlrc
    lazydocker
    unrar
    glow
    gh
    scc
    ncdu
  ];
}
