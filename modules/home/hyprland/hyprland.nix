{ pkgs, inputs, lib, ... }: let
  brillo = "${pkgs.brillo}/bin/brillo -q";

  # NOTE: wtype doesn't work on discord: https://github.com/atx/wtype/issues/31
  emojis = pkgs.callPackage ../../../pkgs/emojis.nix {};
  tofi-emoji = pkgs.writeShellScriptBin "tofi-emoji" ''
    EMOJI=$(${pkgs.coreutils-full}/bin/tail -n +2 ${emojis} |\
            ${pkgs.tofi}/bin/tofi |\
            ${pkgs.coreutils-full}/bin/cut -d ' ' -f 1 |\
            ${pkgs.coreutils-full}/bin/tr -d '\n')
    ${pkgs.wtype}/bin/wtype "$EMOJI"
    ${pkgs.wl-clipboard}/bin/wl-copy "$EMOJI"
  '';
  hyprzoom = pkgs.writeShellScriptBin "hyprzoom" ''
    # Controls Hyprland's cursor zoom_factor, clamped between 1.0 and 3.0

    # Get current zoom level
    get_zoom() {
        ${pkgs.hyprland}/bin/hyprctl getoption -j cursor:zoom_factor | ${pkgs.jq}/bin/jq '.float'
    }

    # Clamp a value between 1.0 and 3.0
    clamp() {
        local val="$1"
        awk "BEGIN {
            v = $val;
            if (v < 1.0) v = 1.0;
            if (v > 3.0) v = 3.0;
            print v;
        }"
    }

    # Set zoom level
    set_zoom() {
        local value="$1"
        clamped=$(clamp "$value")
        ${pkgs.hyprland}/bin/hyprctl keyword cursor:zoom_factor "$clamped"
    }

    case "$1" in
        reset)
            set_zoom 1.0
            ;;
        increase)
            if [[ -z "$2" ]]; then
                echo "Usage: $0 increase STEP"
                exit 1
            fi
            current=$(get_zoom)
            new=$(awk "BEGIN { print $current + $2 }")
            set_zoom "$new"
            ;;
        decrease)
            if [[ -z "$2" ]]; then
                echo "Usage: $0 decrease STEP"
                exit 1
            fi
            current=$(get_zoom)
            new=$(awk "BEGIN { print $current - $2 }")
            set_zoom "$new"
            ;;
        *)
            echo "Usage: $0 {reset|increase STEP|decrease STEP}"
            exit 1
            ;;
    esac
  '';


in {
  imports = [./hyprlock.nix];
  services.hypridle.enable = true;
  services.hypridle.settings = {
    general = {
      lock_cmd = "pidof hyprlock || hyprlock";
      before_sleep_cmd = "loginctl lock-session";
      after_sleep_cmd = "hyprctl dispatch dpms on";
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
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
      {
        timeout = 86400;
        on-timeout = "systemctl suspend";
      }
    ];
  };

  wayland.windowManager.hyprland.enable = true;  # enable home manager to config hyprland
  wayland.windowManager.hyprland = {
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;
  };
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "qs -c ii"
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

    dwindle = {
      preserve_split = true;
      smart_split = true;
    };

    decoration = {
      rounding = 12;
      blur.size = 4;
      blur.passes = 2;
      blur.contrast = 1.8;

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

    gesture = [
       "3, horizontal, workspace"
    ];

    misc = {
      vfr = 1;
      vrr = 1;

      disable_hyprland_logo = true;
      force_default_wallpaper = 0;
      new_window_takes_over_fullscreen = 2;
      allow_session_lock_restore = true;
    };

    cursor = {
      no_hardware_cursors = 1;
    };

    binds = {
      scroll_event_delay = 0;
    };

    bind = [
      "SUPER_SHIFT, L, exec, hyprlock"
      "SUPER_SHIFT, S, exec, systemctl suspend"
      "SUPER, X, exec, firefox"
      "SUPER, P, exec, spotify"
      "SUPER, D, exec, vesktop"
      "SUPER, E, exec, nemo"
      "SUPER, RETURN, exec, ghostty"

      "SUPER, W, killactive"

      "SUPER, M, fullscreen, 1"
      "SUPER, F, togglefloating"
      "SUPER, Y, togglesplit"

      "SUPER, J, cyclenext"
      "SUPER, K, cyclenext, prev"
      "ALT, TAB, focuscurrentorlast"
      "SUPER, PRINT, exec, ${pkgs.grimblast}/bin/grimblast copy area"
      "SUPER, TAB, hyprexpo:expo, toggle"
      # Workspaces
      # Special workspace
      "SUPER, GRAVE, togglespecialworkspace"
      "SUPER SHIFT, GRAVE, movetoworkspace, special"
    ] ++ (
      # Switch workspaces with SUPER + [1-9]
      let
        bind_workspace_num = i: "SUPER, ${i}, workspace, ${i}";
      in
        map bind_workspace_num (map builtins.toString (lib.range 1 9))
    ) ++ (
      # Move active window to a workspace with SUPER + SHIFT + [1-9]
      let
        bind_workspace_num = i: "SUPER SHIFT, ${i}, movetoworkspace, ${i}";
      in
        map bind_workspace_num (map builtins.toString (lib.range 1 9))
    );
    bindd = [
      "SUPER, R, Toggle overview, global, quickshell:overviewWorkspacesToggle"
      "SUPER, SLASH, Toggle cheatsheet, global, quickshell:cheatsheetToggle"  # x

      "SUPER, V, Clipboard history >> clipboard, global, quickshell:overviewClipboardToggle"
      "SUPER, PERIOD, Emoji picker, exec, ${tofi-emoji}/bin/tofi-emoji"
      "SUPER+SHIFT, PERIOD, Emoji >> clipboard, global, quickshell:overviewEmojiToggle"

      "SUPER, H, Toggle left sidebar, global, quickshell:sidebarLeftToggle"
      "SUPER+ALT, H, Toggle detached for left sidebar , global, quickshell:sidebarLeftToggleDetach"
      "SUPER, L, Toggle right sidebar, global, quickshell:sidebarRightToggle"

      "SUPER, A, Toggle media controls, global, quickshell:mediaControlsToggle"
      "CTRL+ALT, DELETE, Toggle session menu, global, quickshell:sessionToggle"
      "SUPER+CTRL, mouse_up, Zoom out, exec, ${hyprzoom}/bin/hyprzoom decrease 0.1"
      "SUPER+CTRL, mouse_down, Zoom in, exec, ${hyprzoom}/bin/hyprzoom increase 0.1"
    ];

    bindle = let
      wpctl = "${pkgs.wireplumber}/bin/wpctl";
    in [
      ",XF86MonBrightnessUp,   exec, ${brillo} -A 5"
      ",XF86MonBrightnessDown, exec, ${brillo} -U 5"
      ",XF86KbdBrightnessUp,   exec, ${brillo} -k -s asus::kbd_backlight -A 5"
      ",XF86KbdBrightnessDown, exec, ${brillo} -k -s asus::kbd_backlight -U 5"
      # -l 2.0 means limit at 200%
      ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%+"
      ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 2.0 @DEFAULT_AUDIO_SINK@ 2%-"
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
      "opacity 0.7 0.6, class:nemo.*"
    ];
    animations = {
      enabled = true;
      bezier = [
        "expressiveFastSpatial, 0.42, 1.67, 0.21, 0.90"
        "expressiveSlowSpatial, 0.39, 1.29, 0.35, 0.98"
        "expressiveDefaultSpatial, 0.38, 1.21, 0.22, 1.00"
        "emphasizedDecel, 0.05, 0.7, 0.1, 1"
        "emphasizedAccel, 0.3, 0, 0.8, 0.15"
        "standardDecel, 0, 0, 0, 1"
        "menu_decel, 0.1, 1, 0, 1"
        "menu_accel, 0.52, 0.03, 0.72, 0.08"
      ];
      animation = [
        "windowsIn, 1, 3, emphasizedDecel, popin 80%"
        "windowsOut, 1, 2, emphasizedDecel, popin 90%"
        "windowsMove, 1, 3, emphasizedDecel, slide"
        "border, 1, 10, emphasizedDecel"

        "layersIn, 1, 2.7, emphasizedDecel, popin 93%"
        "layersOut, 1, 2.4, menu_accel, popin 94%"

        "fadeLayersIn, 1, 0.5, menu_decel"
        "fadeLayersOut, 1, 2.7, menu_accel"

        "workspaces, 1, 7, menu_decel, slide"
        "specialWorkspaceIn, 1, 2.8, emphasizedDecel, slidevert"
        "specialWorkspaceOut, 1, 1.2, emphasizedAccel, slidevert"
      ];
    };
  };
  wayland.windowManager.hyprland.plugins = [
    inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
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
