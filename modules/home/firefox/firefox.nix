{ pkgs, ... }: let
  userChromeCSS = builtins.readFile (if pkgs.stdenv.hostPlatform.isDarwin then 
    ./userChrome-MacOS.css
  else
    ./userChrome-Linux.css
  );
  userJS = builtins.readFile ./user.js;  # betterfox
in {
  programs.firefox.enable = true;
  programs.firefox.profiles."nixOS-profile" = {
    userChrome = userChromeCSS;
    extraConfig = userJS;
    settings = {
      "browser.ctrlTab.sortByRecentlyUsed" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.tabs.inTitlebar" = 0;  # disables title bar
      "browser.startup.page" = 3;     # reopen last closed tabs
    };

    # NOTE: have to enable extensions manually at first launch
    # NOTE: have to configure toolbar manually
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin             # ad blocker
      bitwarden                 # password manager
      sidebery                  # tree style tab
                                # NOTE: have to import ./sidebery/sideberySettings manually
      simple-translate          # quick translate
      undoclosetabbutton        # actually undo close tab

      # TODO: make nur work
      # betterttv               # twitch/yt emotes
      return-youtube-dislikes   # third party yt dislikes
      videospeed                # yt speed controller
    ];

    # search engines
    search.force = true;
    search.default = "Startpage";
    search.privateDefault = "Startpage";
    search.order = ["Startpage" "Google"];
    search.engines."Startpage" = {
      urls = [{ template = "https://www.startpage.com/search?query={searchTerms}"; }];
      iconsUpdateURL = "https://www.startpage.com/favicon.ico";
    };
    search.engines."Nix Packages" = {
      urls = [{
        template = "https://search.nixos.org/packages";
        params = [
          { name = "type"; value = "packages"; }
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@np" ];
    };
    search.engines."NixOS Wiki" = {
      urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
      iconUpdateURL = "https://nixos.wiki/favicon.png";
      definedAliases = [ "@nw" ];
    };
    search.engines."Home Manager - Option Search" = {
      urls = [{
        template = "https://home-manager-options.extranix.com/?query={searchTerms}";
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@hmo" ];
    };
    search.engines = {
        "Bing".metaData.hidden = true;
        "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias 
        "Wikipedia (en)".metaData.alias = "@w";
    };
  };
}
