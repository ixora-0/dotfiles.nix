{ 
  programs.git = {
    enable = true;

    userName = "ixora-0";
    userEmail = "39961970+ixora-0@users.noreply.github.com";

    signing.signByDefault = true;
    # signing.key = "0959B5BC39B44064";
    signing.key = "~/.ssh/id_ed25519.pub";

    # use delta pager
    delta.enable = true;
    delta.options = {
      line-numbers = true;
      side-by-side = true;
    };
    
    extraConfig = {
      core.autocrlf = "input";
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };

    ignores = [
      "*.backup"
      "TEST*"
    ];
  };
}
