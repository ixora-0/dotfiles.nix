{ quickshell, pkgs }: pkgs.lib.fix(self: {
  illogical-impulse-qs = pkgs.qt6Packages.callPackage ./illogical-impulse-qs {};
  illogical-impulse-qs-launcher = pkgs.callPackage ./illogical-impulse-qs-launcher { inherit quickshell; };
  illogical-impulse-matugen = pkgs.callPackage ./illogical-impulse-matugen {};
  # illogical-impulse-hyprland-shaders = pkgs.callPackage ./illogical-impulse-hyprland-shaders {};
  illogical-impulse-kvantum = pkgs.callPackage ./illogical-impulse-kvantum {};
  illogical-impulse-oneui4-icons = pkgs.callPackage ./illogical-impulse-oneui4-icons {};
})
