{ pkgs, ... }: {
  # HACK: excluded xterm in configuration.nix
  # then symlinking kitty as xterm
  # only way to set "default terminal"
  home.packages = [
    (pkgs.writeShellScriptBin "xterm" ''
      ${pkgs.kitty}/bin/kitty "$@"
    '')
  ];
  # this does nothing
  # home.sessionVariables = {
  #   TERM = "kitty";
  #   TERMINAL = "kitty";
  # };

  # this also doesn't work
  # xdg = {
  #   enable = true;
  #   mimeApps = {
  #     enable = true;
  #     defaultApplications = {
  #       "Terminal" = "kitty-open.desktop";
  #     };
  #   };
  # };

  programs.kitty = {
    enable = true;
    font.size = 16;
    font.name = "monospace";

    theme = "Catppuccin-Mocha";

    keybindings = {
      "ctrl+equal" = "change_font_size all +2.0";
      "ctrl+plus" = "change_font_size all +2.0";
      "ctrl+kp_add" = "change_font_size all +2.0";

      "ctrl+minus" = "change_font_size all -2.0";
      "ctrl+kp_subtract" = "change_font_size all -2.0";

      "ctrl+0" = "change_font_size all 0";

      "ctrl+shift+n" = "launch --cwd=current --type=os-window";
      "ctrl+shift+t" = "launch --cwd=current --type=tab";
      "ctrl+shift+w" = "close_tab";
      # "ctrl+d" = "detach_tab";
      # "ctrl+shift+w" = "close_window";
      "ctrl+shift+d" = "detach_window";
      "ctrl+alt+d" = "detach_window new-tab";
    };

    settings = {
      background_opacity = "0.85";
      single_window_padding_width = "4 2";

      enable_audio_bell = "no";
      visual_bell_duration = "0.15";
      visual_bell_color = "#202020";
    };
  };
}
