{
  programs.zellij.enable = true;

  # NOTE: Watch https://github.com/nix-community/home-manager/issues/4659
  programs.zellij.settings = {
    theme = "catppuccin-mocha";
    keybinds = {
      normal = {
        "unbind" = "Ctrl s";
        "bind \" Ctrl /\"" = {
          SwitchToMode = "search";
        };
      };
      move = {
        "bind \" H\"" = {
          MoveTab = "Left";
        };
        "bind \" L\"" = {
          MoveTab = "Right";
        };
      };
    };
    plugins = {
      "welcome-screen location=\"zellij:session-manager\"" = {
        welcome_screen = false;
      };
    };
  };
}
