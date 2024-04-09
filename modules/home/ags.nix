{ inputs, pkgs, ... }: let
  aylurAgs = pkgs.fetchgit {
    url = "https://github.com/Aylur/dotfiles";
    sparseCheckout = ["ags"];
    rev = "99b6e3156d03d7bbdbc487ca0b3b260da5c20079";
    hash = "sha256-VVoD11+mzNBTVA2FKNP6nnvuSfrtcPduZRz64PzpcNw=";
  } + /ags;
in
{
  # TODO: declarative settings
  # BUG: media preview for firefox youtube doesn't work
  imports = [
    inputs.ags.homeManagerModules.default
    inputs.astal.homeManagerModules.default
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

  programs.astal = {
    enable = true;
    extraPackages = with pkgs; [
      libadwaita
    ];
  };

  programs.ags = {
    enable = true;
    configDir = aylurAgs;
  };
}
