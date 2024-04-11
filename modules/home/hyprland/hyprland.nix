{ pkgs, lib, ... }: {
  wayland.windowManager.hyprland.enable = true;  # enable home manager to config hyprland
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "ags -b hypr"
      "unset GTK_IM_MODULE"  # HACK: disable the fcitx5 warning
      "fcitx5 -d"
      # "${pkgs.swww}/bin/swww init"
      # "${pkgs.swww}/bin/swww-daemon"
    ];

    monitor = [
      "eDP-1, 1920x1080@144, 0x0, 1"
      "HDMI-A-1, 1920x1080@119, 1920x0, 1"
    ];

    general = {
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
    };

    misc = {
      disable_hyprland_logo = true;  # disables displaying default wallpapers on startup
    };

    decoration = {
      rounding = 10;

      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
      blur.size = 12;
    };

    input = {
      follow_mouse = 1;
      touchpad.natural_scroll = true;
      sensitivity = -0.1;
      accel_profile = "flat";
    };

    gestures = {
      workspace_swipe = true;
    };

    bind = [
      "SUPER SHIFT, R, exec, ags -b hypr quit; ags -b hypr"
      "SUPER, Z, exec, ags -b hypr -t launcher"
      # "SUPER, Z, exec, pkill rofi || rofi -show drun"
      "SUPER, X, exec, firefox"
      "SUPER, P, exec, spotify"
      "SUPER, E, exec, nemo"
      # "SUPER, E, exec, ${pkgs.gnome.nautilus}/bin/nautilus"
      "SUPER, RETURN, exec, ${pkgs.kitty}/bin/kitty"

      "SUPER, W, killactive"

      "SUPER, M, fullscreen, 1"
      "SUPER, F, togglefloating"

      "SUPER, J, cyclenext"
      "SUPER, K, cyclenext, prev"
      "ALT, TAB, focuscurrentorlast"
      "SUPER, TAB, exec, ags -b hypr -t overview"
    ] ++ (
      # Switch workspaces with SUPER + [1-9]
      let bind_workspace_num = i:
        "SUPER, ${i}, workspace, ${i}"; 
      in (map
          bind_workspace_num 
          (map builtins.toString (lib.range 1 9))
      )
    ) ++ (
      # Move active window to a workspace with SUPER + SHIFT + [1-9]
      let bind_workspace_num = i:
        "SUPER SHIFT, ${i}, movetoworkspace, ${i}"; 
      in (map
          bind_workspace_num 
          (map builtins.toString (lib.range 1 9))
      )
    );
    bindle = let 
      wpctl = "${pkgs.wireplumber}/bin/wpctl"; 
      brillo = "${pkgs.brillo}/bin/brillo -q";
    in [
      ",XF86MonBrightnessUp,   exec, ${brillo} -A 5"
      ",XF86MonBrightnessDown, exec, ${brillo} -U 5"
      ",XF86KbdBrightnessUp,   exec, ${brillo} -k -s asus::kbd_backlight -A 5"
      ",XF86KbdBrightnessDown, exec, ${brillo} -k -s asus::kbd_backlight -U 5"
      # -l 1.5 means limit at 150%
      ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
      ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%-"
      ", XF86AudioMute,        exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute,     exec, ${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    ];
    bindl = let playerctl = "${pkgs.playerctl}/bin/playerctl"; in [
      ", XF86AudioPlay,  exec, ${playerctl} play-pause"
      ", XF86AudioStop,  exec, ${playerctl} pause"
      ", XF86AudioPause, exec, ${playerctl} pause"
      ", XF86AudioPrev,  exec, ${playerctl} previous"
      ", XF86AudioNext,  exec, ${playerctl} next"
    ];
    bindm = [
      # Move/resize windows with maiSUPER + LMB/RMB and dragging
      "SUPER, mouse:272, movewindow"
      "SUPER, mouse:273, resizewindow"
    ];

    windowrulev2 = [
      # maximize firefox; 
      "maximize, class:firefox.*"

      # float firefox extension popups
      # BUG: doesn't work tho: https://github.com/hyprwm/Hyprland/issues/602
      "float, class:^firefox.*$, title:^Extension:.*$"
      # "suppressevent maximize fullscreen, class:.*"

      # float nemo and nautilus
      "float, class:nemo.*"
      "float, class:kitty.*"
      "float, class:org.gnome.Nautilus.*"

      # opacity nemo and kitty
      "opacity 1 0.85, class:kitty.*"
      "opacity 0.8 0.7, class:nemo.*"
    ];
  };
}
