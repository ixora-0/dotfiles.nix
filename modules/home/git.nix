{ 
  programs.git = {
    enable = true;

    userName = "ixora-0";
    userEmail = "39961970+ixora-0@users.noreply.github.com";

    signing.signByDefault = true;
    signing.key = "0959B5BC39B44064";

    # use delta pager
    delta.enable = true;
    delta.options = {
      line-numbers = true;
      side-by-side = true;
    };
    
    extraConfig = {
      core.autocrlf = "input";
      init.defaultBranch = "main";
    };

    ignores = [
      "*.backup"
      "TEST*"
    ];
  };
}
