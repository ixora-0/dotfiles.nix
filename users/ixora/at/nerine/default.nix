{ pkgs, pkgs-unstable, helpers, ... }: {
  imports = (map helpers.importBundle [
    "core-terminal"
    "extra-terminal"
    "core-apps"
    "extra-apps"
  ]) ++ (map helpers.importHomeModule [
    # packages that has configurations
    "quickshell"
    "hyprland"
    "theme"
    # "wlsunset"
    "direnv"
    "fonts"
  ]) ++ [
    ./games.nix
  ];
  modules.helix.languages.lsp.enableAll = true;
  modules.helix.languages.prettier.enable = true;

  home.packages = (with pkgs; [
    wl-clipboard cliphist
    networkmanagerapplet
    (btop.override { cudaSupport = true; })
    ungoogled-chromium  # backup browser
    ani-cli
    obsidian
    wayshot
    go
    act
    # reaper
    # vital
    vscode
    # nwg-look
    mpv
  ]) ++ (with pkgs-unstable; [
    anki-bin
    ghostty
  ]);

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/ixora/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "hx";

    # GTK_THEME = "Sweet-dark";
    WLR_NO_HARDWARE_CURSORS=1;
  };
}
