{ pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-still
    gimp
    zathura
    motrix
  ];
}
