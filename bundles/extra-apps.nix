{ pkgs, helpers, ...}: {
  imports = (map helpers.importHomeModule [
    "sioyek"
  ]);
  home.packages = with pkgs; [
    libreoffice-still
    gimp
    motrix
  ];
}
