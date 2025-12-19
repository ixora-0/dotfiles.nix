{ pkgs, ... }: let
  userChromeCSS = builtins.readFile (if pkgs.stdenv.hostPlatform.isDarwin then 
    ./userChrome-MacOS.css
  else
    ./userChrome-Linux.css
  );
  betterfox = pkgs.fetchFromGitHub {
    owner = "yokoffing";
    repo = "Betterfox";
    rev = "eee6e58b2b0ee10a59efb6586a5db07ae181d8c7";
    sha256 = "sha256-zGpfQk2gY6ifxIk1fvCk5g5SIFo+o8RItmw3Yt3AeCg=";
  };
  userJS = (builtins.readFile "${betterfox}/user.js") + (builtins.readFile ./betterfox_extra.js);
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
    # NOTE: extensions that are not available for installation from here:
    # https://addons.mozilla.org/en-US/firefox/addon/catppuccin-gh-file-explorer/
    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin             # ad blocker
      bitwarden                 # password manager
      sidebery                  # tree style tab
                                # NOTE: have to import ./sidebery/sideberySettings manually
      simple-translate          # quick translate
      undoclosetabbutton        # actually undo close tab

      betterttv                 # twitch/yt emotes
      return-youtube-dislikes   # third party yt dislikes
      videospeed                # yt speed controller
      stylus                    # custom site styles
                                # NOTE: have to import https://github.com/catppuccin/userstyles/releases/download/all-userstyles-export/import.json manually
      darkreader
      # refined-github
    ];

    # search engines
    search.force = true;
    search.default = "Startpage";
    search.privateDefault = "Startpage";
    search.order = ["Startpage" "google"];
    search.engines."Startpage" = {
      urls = [{ template = "https://www.startpage.com/search?query={searchTerms}"; }];
      icon = "https://www.startpage.com/favicon.ico";
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
      icon = "https://nixos.wiki/favicon.png";
      definedAliases = [ "@nw" ];
    };
    search.engines."Home Manager - Option Search" = {
      urls = [{
        template = "https://home-manager-options.extranix.com/?query={searchTerms}";
      }];
      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ "@hmo" ];
    };
    search.engines."WordReference English definition" = {
      urls = [{ template = "https://www.wordreference.com/definition/{searchTerms}"; }];
      definedAliases = [ "@mean" ];
    };
    search.engines."WordReference English synonyms" = {
      urls = [{ template = "https://www.wordreference.com/synonyms/{searchTerms}"; }];
      definedAliases = [ "@same" ];
    };
    search.engines."Youtube" = {
      urls = [{ template = "https://www.youtube.com/results?search_query={searchTerms}"; }];
      definedAliases = [ "@yt" ];
      icon = "https://www.svgrepo.com/show/13671/youtube.svg";
    };
    search.engines."Wiktionary" = {
      urls = [{ template = "https://en.wiktionary.org/wiki/{searchTerms}"; }];
      definedAliases = [ "@wt" ];
      icon = "https://upload.wikimedia.org/wikipedia/commons/8/83/En.wiktionary_favicon.svg";
    };
    search.engines = {
        bing.metaData.hidden = true;
        google.metaData.alias = "@g"; # builtin engines only support specifying one additional alias 
        wikipedia.metaData.alias = "@w";
    };
  };
  programs.firefox.profiles."torproxy" = {
    id = 1;
    extraConfig = userJS;
    settings = {
      "browser.ctrlTab.sortByRecentlyUsed" = true;
      "browser.toolbars.bookmarks.visibility" = "never";
      "browser.tabs.inTitlebar" = 0;  # disables title bar
      "browser.startup.page" = 3;     # reopen last closed tabs

      "network.proxy.socks" = "127.0.0.1";
      "network.proxy.socks_port" = 8118;
      "network.proxy.type" = 1;
      "network.proxy.socks5_remote_dns" = true;
    };

    extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin             # ad blocker
    ];
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/ftp" = "firefox.desktop";
  };
}
