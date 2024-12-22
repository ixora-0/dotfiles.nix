{pkgs, ...}: {
  i18n.inputMethod = {
    # apparently ibus is not that good on wayland https://github.com/ibus/ibus/issues/2182    
    # enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [
    #   anthy
    #   bamboo
    # ];
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [ 
      fcitx5-anthy
      fcitx5-unikey
    ];
  };
  # supposedly needed to autostart i18n.inputMethod
  # https://nixos.wiki/wiki/Fcitx5
  # doesn't work tho, starting fcitx5 in hyprland instead
  # services.xserver.desktopManager.runXdgAutostartIfNone = true;

  hardware.opentabletdriver.enable = true;  # needed for using tablet
                                            # and also for playing osu

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
