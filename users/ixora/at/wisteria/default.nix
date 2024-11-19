{ pkgs, helpers, ...}: {
  programs.git.extraConfig.core.filemode = false;

  imports = (map helpers.importBundle [
    "core-terminal"
    "extra-terminal"
  ]) ++ (map helpers.importHomeModule [
  ]);
  home.packages = with pkgs; [
  ];
}
