{ pkgs, ... }:  let
  homeModuleImport = import ../../../../helpers/homeModuleImport.nix;
in
{
  # TODO: make zsh and awesome work
  # name          description                          main language
  # packages that has configurations
  imports = map homeModuleImport [
    # basic clis
    "git"       # git + delta (better diff)            c + rust
    "neofetch"  # system information tool              shell
    # "zsh"       # zsh + ohmyzsh + plugins              c + shell
    # NOTE: 
    # on non-nixOS, have to add ~/.nix-profile/bin/zsh to /etc/shells
    # then use chsh -s ~/.nix-profile/bin/zsh

    # coreutils enhancements
    "eza"       # pretty ls                            rust

    # window manager
    # "awesome"

    # terminals
    "kitty"     # main terminal emulator               py, c, go
    "wezterm"   # alternative term emulator            rust

    # other
    "lf"        # terminal file explorer               c
    "broot"     # file tree with fzf                   rust
    "spotify"   # spotify + spicetify                  cef + js, go
    "discord"   # discord + OpenAsar + Vencord         js + tsx (electron)
    "helix"     # modal text editor                    rust
    "redshift"  # screen color temperature             c
  ];
  # per custom module configs
  modules = {
    helix.languages.lsp.enableAll = true;
    helix.languages.prettier.enable = true;
  };
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   # enableNvidiaPatches = true;  # has been removed
  #   xwayland.enable = true;  # should already be true by default
  # };
  # programs.hyprland.enable = true;

  # packages that don't have configurations
  home.packages = with pkgs; [
    # basic clis
    inetutils   # for `hostname`                       c

    # coreutils enhancements
    # zoxide      # smart cd                             rust
    bat         # pretty cat (with syntax hilighting)  rust
    bottom      # pretty htop                          rust
    ripgrep     # faster grep (usage: rg)              rust
    repgrep     # tui for ripgrep (usage: rgr)         rust
    fd          # faster find                          rust
    tldr        # man page cheatsheet                  markdown
    moar        # pager (like less)                    go

    # other utils
    fzf         # tui fuzzy finder                     go
    chafa       # image in terminals                   c
                # (needed for lf to preview images)
    glow        # markdown renderer                    go
    rofi

    # devs
    # web
    bun         # faster node.js                       zig
    # java
    scenebuilder  # for a cs course                    java
    
    # apps
    flameshot   # screenshots                          c++
    ani-cli     # cli tool to browse and play anime    shell
    anki        # spaced repition flashcards           rust, py, ts, svelte
    obsidian    # second brain                         js (electron)
    gitkraken   # git client                           c#
    # zathura     # 
    # noisetorch  # mic noise supression                 go
    # etcher

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
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
    # EDITOR = "emacs";
  };
}
