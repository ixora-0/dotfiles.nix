{ inputs, pkgs, ... }: let
  aylurAgs = pkgs.fetchgit {
    url = "https://github.com/Aylur/dotfiles";
    sparseCheckout = ["ags"];
    rev = "99b6e3156d03d7bbdbc487ca0b3b260da5c20079";
    hash = "sha256-VVoD11+mzNBTVA2FKNP6nnvuSfrtcPduZRz64PzpcNw=";
  } + /ags;
in
{
  # BUG: media preview for firefox youtube doesn't work
  # TODO: move to ags v2
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    # asztal
    bun
    dart-sass
    fd
    brightnessctl
    swww
    inputs.matugen.packages.${system}.default
    slurp
    wf-recorder
    wl-clipboard
    wayshot
    swappy
    hyprpicker
    pavucontrol
    networkmanager
    gtk3
  ];

  programs.ags.enable = true;
  programs.ags.configDir = aylurAgs;

  home.file.".cache/ags/options.json" = {
    source = ./options.json;
    force = true;  # interacting with bar changes option.json, have to overwrite
  };
}
