{ pkgs, config, ... }: let
  # nerdfonts = (pkgs.nerdfonts.override { fonts = [
  #   "Ubuntu"
  #   "UbuntuMono"
  #   "CascadiaCode"
  #   "FantasqueSansMono"
  #   "FiraCode"
  #   "Mononoki"
  # ]; });

  theme = {
    # name = "adw-gtk3-dark";
    # package = pkgs.adw-gtk3;

    # name = "Sweet-Dark";
    # package = pkgs.sweet-nova;

    name = "Catppuccin-Mocha-Standard-Pink-Dark";
    package = pkgs.catppuccin-gtk.override {
      accents = [ "pink" ];
      # size = "compact";
      # tweaks = [ "rimless" "black" ];
      variant = "mocha";
    };
  };
  # font = {
  #   name = "Ubuntu Nerd Font";
  #   package = nerdfonts;
  # };
  cursorTheme = {
    name = "phinger-cursors";
    size = 24;
    package = pkgs.phinger-cursors;
  };
  iconTheme = {
  # name = "MoreWaita";  # ags monochrome icons are taken from here
  # package = pkgs.morewaita-icon-theme;
    name = "candy-icons";
    package = pkgs.candy-icons;
  };
in
{
  home.packages = with pkgs; [
    # cantarell-fonts
    # font-awesome
    theme.package
    # font.package
    cursorTheme.package
    # iconTheme.package

    # some ags icons are taken from here
    # BUG: sadly this overrides some of candy's icons as well
    gnome.adwaita-icon-theme
    # papirus-icon-theme
    morewaita-icon-theme
  ];
  home.sessionVariables = {
    XCURSOR_THEME = cursorTheme.name;
    XCURSOR_SIZE = "${toString cursorTheme.size}";
  };
  home.pointerCursor = cursorTheme // {
    gtk.enable = true;
    x11.enable = true;
  };

  gtk = {
    enable = true;
    # inherit font;
    inherit cursorTheme;
    inherit iconTheme;
    # theme.name = theme.name;
    inherit theme;
    gtk3.extraCss = ''
      headerbar, .titlebar,
      .csd:not(.popup):not(tooltip):not(messagedialog) decoration{
        border-radius: 0;
      }
    '';
  };

  home.file = {
    # ".local/share/themes/${theme.name}".source = "${theme.package}/share/themes/${theme.name}";
    
    # ".config/gtk-4.0/gtk.css".text = ''
    #   window.messagedialog .response-area > button,
    #   window.dialog.message .dialog-action-area > button,
    #   .background.csd{
    #     border-radius: 0;
    #   }
    # # '';
  };
  # xdg.configFile = {
  #   "gtk-4.0/assets".source = "${theme.package}/share/themes/${theme.name}/assets";
  #   "gtk-4.0/gtk.css".source = "${theme.package}/share/themes/${theme.name}/gtk-4.0/gtk.css";
  #   "gtk-4.0/gtk-dark.css".source = "${theme.package}/share/themes/${theme.name}/gtk-4.0/gtk-dark.css";
  # };  

  xdg.configFile = {
    "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  # fonts.fontconfig.enable = true;

  qt = {
    enable = true;
    platformTheme = "kde";
  };
}
