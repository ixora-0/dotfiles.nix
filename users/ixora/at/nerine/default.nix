{ pkgs, ... }: let
  homeModuleImport = import ../../../../helpers/homeModuleImport.nix;
in
{
  # TODO: organize to bundles

  # packages that has configurations
  imports = map homeModuleImport [
    "zsh"
    "neofetch"
    "helix"
    "kitty"
    "eza"
    "hyprland"
    "discord"
    "spotify"
    "ags"
    "git"
    "theme"
    "firefox"
    "wlsunset"
    "zoxide"
    "direnv"
  ];
  modules.zsh.plugins.fastSyntaxHighlighting.enable = true;
  modules.zsh.plugins.powerlevel10k.enable = true;

  modules.helix.languages.lsp.nil.enable = true;
  modules.helix.languages.lsp.typescript.enable = true;
  modules.helix.languages.lsp.vscodeLangservers.enable = true;

  modules.discord.vesktop.enable = true;

  home.packages = with pkgs; [
    tlrc
    kitty
    bat
    # firefox-devedition

    cinnamon.nemo  # BUG: open in terminal doesn't work
    # gnome.nautilus nautilus-open-any-terminal
    anki
    fzf
    ripgrep
    repgrep
    unzip
    networkmanagerapplet
    bottom
    ungoogled-chromium  # backup browser
    ani-cli
    eclipses.eclipse-java scenebuilder
    libreoffice-still
    obsidian
    gimp
    wayshot
    zathura
    go
    unrar
    osu-lazer-bin
    glow
    lazygit
    act
    # reaper
    # vital
    # (ollama.override {
    #   acceleration = "cuda";
    # })

    # nwg-look
  ] ++ [
    (import (homeModuleImport "rgf") pkgs)
  ];



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
  };
}
