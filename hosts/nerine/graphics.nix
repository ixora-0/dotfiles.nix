{ pkgs, inputs, helpers, ... }: {
  imports = [
    ./nvidia.nix
  ] ++ (map helpers.importNixosModule [
    "sddm"
  ]);
  services.xserver.enable = true;
  services.xserver.excludePackages = [pkgs.xterm];

  # Graphical session to pre-select in the session chooser
  services.displayManager.defaultSession = "hyprland";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  # commented bc matching mesa versions make games lag rn
  # hardware.graphics = let
  #   hypr-pkgs = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  # in {
  #   package = hypr-pkgs.mesa;
  #   package32 = hypr-pkgs.pkgsi686Linux.mesa;
  # };

  programs.hyprland.enable = true;
  programs.hyprland = {
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # brightness control
  hardware.brillo.enable = true;
}
