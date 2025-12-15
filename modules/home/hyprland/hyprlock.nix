{ pkgs, ...}: let
  check-capslock = pkgs.writeShellScriptBin "hyprlock-check-capslock" ''
    MAIN_KB_CAPS=$(hyprctl devices | grep -B 6 "main: yes" | grep "capsLock" | head -1 | awk '{print $2}')

    if [ "$MAIN_KB_CAPS" = "yes" ]; then
        echo "Caps Lock active"
    else
        echo ""
    fi
  '';
  status = pkgs.writeShellScriptBin "hyprlock-status" ''
    ############ Variables ############
    enable_battery=false
    battery_charging=false

    ####### Check availability ########
    for battery in /sys/class/power_supply/*BAT*; do
      if [[ -f "$battery/uevent" ]]; then
        enable_battery=true
        if [[ $(cat /sys/class/power_supply/*/status | head -1) == "Charging" ]]; then
          battery_charging=true
        fi
        break
      fi
    done

    ############# Output #############
    if [[ $enable_battery == true ]]; then
      if [[ $battery_charging == true ]]; then
        echo -n "(+) "
      fi
      echo -n "$(cat /sys/class/power_supply/*/capacity | head -1)"%
      if [[ $battery_charging == false ]]; then
        echo -n " remaining"
      fi
    fi

    echo '''
  '';


in {
  programs.hyprlock.enable = true;
  programs.hyprlock.settings = {
    source="~/.config/hypr/hyprlock/colors.conf";
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
        size = "250, 50";
        outline_thickness = 2;
        dots_size = 0.1;
        dots_spacing = 0.3;
        outer_color = "$entry_border_color";
        inner_color = "$entry_background_color";
        font_color = "$entry_color";
        fade_on_empty = true;

        position = "0, 20";
        halign = "center";
        valign = "center";
      }
    ];

    label = [
      {
        text = "$LAYOUT";
        color = "$text_color";
        font_size = 14;
        font_family = "$font_family";
        position = "-30, 30";
        halign = "right";
        valign = "bottom";
      }
      {
        # Caps Lock Warning
        text = "cmd[update:250] ${check-capslock}/bin/hyprlock-check-capslock";
        color = "$text_color";
        font_size = 13;
        font_family = "$font_family";
        position = "0, -25";
        halign = "center";
        valign = "center";
      }
      {
        # Clock
        text = "$TIME";
        color = "$text_color";
        font_size = 65;
        font_family = "$font_family_clock";

        position = "0, 300";
        halign = "center";
        valign = "center";
      }
      {
        # Date
        text = "cmd[update:5000] date +\"%A, %B %d\"";
        color = "$text_color";
        font_size = 17;
        font_family = "$font_family_clock";

        position = "0, 240";
        halign = "center";
        valign = "center";
      }
      {
        # Status
        text = "cmd[update:5000] ${status}/bin/hyprlock-status";
        color = "$text_color";
        font_size = 14;
        font_family = "$font_family";

        position = "30, -30";
        halign = "left";
        valign = "top";
      }
    ];
  };
}
