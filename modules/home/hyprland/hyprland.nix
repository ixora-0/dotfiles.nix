{ pkgs, lib, config, ... }: let
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  hyprlock = "${pkgs.hyprlock}/bin/hyprlock";
  brillo = "${pkgs.brillo}/bin/brillo -q";

  # emoji picker
  # commands from https://github.com/Zeioth/wofi-emoji
  # NOTE: wtype doesn't work on discord: https://github.com/atx/wtype/issues/31
  raw-emojis = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/muan/emojilib/v4.0.1/dist/emoji-en-US.json";
    hash = "sha256-HDeA/0WOaiNMTalC54U5uhTFZErEe3SOaDEstU8I32E=";
  };
  emojis = pkgs.runCommand "emojilib-emojis" {} ''
    ${pkgs.jq}/bin/jq --raw-output '. | to_entries | .[] | .key + " " + (.value | join(" ") | sub("_"; " "; "g"))' ${raw-emojis} > $out
  '';
  tofi-emoji = pkgs.writeShellScriptBin "tofi-emoji" ''
    EMOJI=$(${pkgs.coreutils-full}/bin/cat ${emojis} |\
            ${pkgs.tofi}/bin/tofi |\
            ${pkgs.coreutils-full}/bin/cut -d ' ' -f 1 |\
            ${pkgs.coreutils-full}/bin/tr -d '\n')
    ${pkgs.wtype}/bin/wtype "$EMOJI"
    ${pkgs.wl-clipboard}/bin/wl-copy "$EMOJI"
  '';
  pick-cliphist = pkgs.writeShellScriptBin "pick-cliphist" ''
    ${pkgs.cliphist}/bin/cliphist list |\
    ${pkgs.tofi}/bin/tofi |\
    ${pkgs.cliphist}/bin/cliphist decode |\
    ${pkgs.wl-clipboard}/bin/wl-copy
  '';


in {
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || ${hyprlock}";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "${hyprctl} dispatch dpms on";
    };
    listener = [
      {
        timeout = 150;
        on-timeout = "${brillo} -O; ${brillo} -S 10";
        on-resume = "${brillo} -I";
      }
      {
        timeout = 300;
        on-timeout = "loginctl lock-session";
      }
      {
        timeout = 330;
        on-timeout = "${hyprctl} dispatch dpms off";
        on-resume = "${hyprctl} dispatch dpms on";
      }
      {
        timeout = 86400;
        on-timeout = "systemctl suspend";
      }
    ];
  };
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    general = {
      disable_loading_bar = true;
      no_fade_in = false;
      no_fade_out = false;
      grace = 4;
      # hide_cursor = true;
    };

    background = [
      {
        path = "screenshot";
        blur_passes = 2;
        contrast = 1;
        brightness = 0.5;
        vibrancy = 0.2;
        vibrancy_darkness = 0.2;
      }
    ];

    input-field = [
      {
        size = "600, 50";
        dots_size = 0.75;
        dots_spacing = 0.1;
        font_color = "rgb(255, 255, 255)";
        # position = "0, 0";
        dots_center = true;
        # font_color = "rgb(202, 211, 245)";
        inner_color = "rgba(0, 0, 0, 0.2)";
        outer_color = "rgba(0, 0, 0, 0)";
        # outline_thickness = 2;
        placeholder_text = "";
        shadow_passes = 2;
        rounding = 0;
        fade_on_empty = false;
      }
    ];

    label = [
      {
        text = "cmd[update:1000] echo \"$(date +\"%-I:%M\")\"";
        color = "rgba(242, 243, 244, 0.75)";
        font_size = "95";
        font_family = "monospace bold";
        position = "0, 200";
        halign = "center";
        valign = "center";
      }
    ];
  };

  wayland.windowManager.hyprland.enable = true;  # enable home manager to config hyprland
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swww-daemon --format xrgb"
      "illogical-impulse-qs-launcher"
      "fcitx5 -d"
      "${pkgs.wl-clipboard}/bin/wl-paste --watch ${pkgs.cliphist}/bin/cliphist store"
      # "${pkgs.swww}/bin/swww init"
      # "${pkgs.swww}/bin/swww-daemon"
    ];

    monitor = [
      # "eDP-1, 1920x1080@144, 1920x0, 1, bitdepth, 10"
      # "DP-1, 1920x1080@165, 0x0, 1, bitdepth, 10"
      # "HDMI-A-1, 1920x1080@144, 0x0, 1, bitdepth, 10"
      "eDP-1, 1920x1080@144, 1920x0, 1"
      "DP-1, 1920x1080@165, 0x0, 1"
      "HDMI-A-1, 1920x1080@144, 0x0, 1"
    ];

    general = {
      # "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      # "col.inactive_border" = "rgba(595959aa)";
      gaps_out = 16;
      gaps_in = 4;
    };

    decoration = {
      rounding = 12;
      blur.size = 12;

      shadow.enabled = true;
      shadow.range = 8;
      shadow.offset = "4 4";
      shadow.render_power = 3;
      shadow.color = "0x771a1a1a";
      shadow.color_inactive = "0x391a1a1a";
    };

    input = {
      follow_mouse = 1;
      sensitivity = -0.1;
      accel_profile = "flat";

      touchpad.disable_while_typing = false;
      touchpad.natural_scroll = true;
      touchpad.scroll_factor = 0.5;
      touchpad.drag_lock = true;
    };

    gestures = {
      workspace_swipe = true;
    };

    misc = {
      vfr = 1;
      vrr = 1;

      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
      new_window_takes_over_fullscreen = 2;
      allow_session_lock_restore = true;
    };

    bind = [
      "SUPER_SHIFT, R, exec, ags -b hypr quit; ags -b hypr"
      "SUPER_SHIFT, L, exec, ${pkgs.hyprlock}/bin/hyprlock"
      "SUPER_SHIFT, S, exec, systemctl suspend"
      "SUPER, Z, exec, ags -b hypr -t launcher"
      # "SUPER, Z, exec, pkill rofi || rofi -show drun"
      "SUPER, X, exec, ${pkgs.firefox}/bin/firefox"
      "SUPER, P, exec, ${lib.getExe config.programs.spicetify.spicedSpotify}"
      # "SUPER, P, exec, spotify"
      "SUPER, D, exec, /nix/store/46c7bms1405z3i29hljwsfqasjzm9yy7-vesktop-1.5.3/bin/vesktop"
      "SUPER, E, exec, nemo"
      # "SUPER, E, exec, ${pkgs.gnome.nautilus}/bin/nautilus"
      "SUPER, RETURN, exec, ghostty"

      "SUPER, PERIOD, exec, ${tofi-emoji}/bin/tofi-emoji"
      "SUPER, V, exec, ${pick-cliphist}/bin/pick-cliphist"

      "SUPER, W, killactive"

      "SUPER, M, fullscreen, 1"
      "SUPER, F, togglefloating"

      "SUPER, J, cyclenext"
      "SUPER, K, cyclenext, prev"
      "ALT, TAB, focuscurrentorlast"
      "SUPER, TAB, exec, ags -b hypr -t overview"
      "SUPER, PRINT, exec, ${pkgs.grimblast}/bin/grimblast copy area"
      "SUPER, G, hyprexpo:expo, toggle"
    ] ++ (
      # Switch workspaces with SUPER + [1-9]
      let
        bind_workspace_num = i: "SUPER, ${i}, workspace, ${i}";
      in (map
          bind_workspace_num
          (map builtins.toString (lib.range 1 9))
      )
    ) ++ (
      # Move active window to a workspace with SUPER + SHIFT + [1-9]
      let
        bind_workspace_num = i: "SUPER SHIFT, ${i}, movetoworkspace, ${i}";
      in (map
          bind_workspace_num
          (map builtins.toString (lib.range 1 9))
      )
    );

    bindle = let
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
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
      "float, class:com.mitchellh.ghostty"
      "float, class:kitty.*"
      "float, class:org.gnome.Nautilus.*"

      # opacity nemo and kitty
      "opacity 1 0.85, class:kitty.*"
      "opacity 0.8 0.7, class:nemo.*"
    ];
    animations = {
      enabled = true;
      bezier = [
        "linear, 0, 0, 1, 1"
        "md3_standard, 0.2, 0, 0, 1"
        "md3_decel, 0.05, 0.7, 0.1, 1"
        "md3_accel, 0.3, 0, 0.8, 0.15"
        "overshot, 0.05, 0.9, 0.1, 1.1"
        "crazyshot, 0.1, 1.5, 0.76, 0.92 "
        "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.38, 0.04, 1, 0.07"
        "easeInOutCirc, 0.85, 0, 0.15, 1"
        "easeOutCirc, 0, 0.55, 0.45, 1"
        "easeOutExpo, 0.16, 1, 0.3, 1"
        "softAcDecel, 0.26, 0.26, 0.15, 1"
        "md2, 0.4, 0, 0.2, 1" # use with .2s duration
      ];
      animation = [
        "windows, 1, 3, md3_decel, popin 60%"
        "windowsIn, 1, 3, md3_decel, popin 60%"
        "windowsOut, 1, 3, md3_accel, popin 60%"
        "border, 1, 10, default"
        "fade, 1, 3, md3_decel"
        # "layers, 1, 2, md3_decel, slide"
        "layersIn, 1, 3, menu_decel, slide"
        "layersOut, 1, 1.6, menu_accel"
        "fadeLayersIn, 1, 2, menu_decel"
        "fadeLayersOut, 1, 0.5, menu_accel"
        "workspaces, 1, 7, menu_decel, slide"
        # "workspaces, 1, 2.5, softAcDecel, slide"
        # "workspaces, 1, 7, menu_decel, slidefade 15%"
        # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
        "specialWorkspace, 1, 3, md3_decel, slidevert"
      ];
    };
  };
  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.hyprexpo
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    plugin {
      hyprexpo {
        columns = 3
        gap_size = 5
        bg_col = rgb(000000)
        workspace_method = first 1 # [center/first] [workspace] e.g. first 1 or center m+1

        enable_gesture = true # laptop touchpad, 4 fingers
        gesture_distance = 300 # how far is the "max"
        gesture_positive = false
      }
    }
  '';
}
