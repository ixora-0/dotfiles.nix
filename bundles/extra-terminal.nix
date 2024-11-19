{ pkgs, helpers, ...}: {
  imports = map helpers.importHomeModule [
    "neofetch"
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
