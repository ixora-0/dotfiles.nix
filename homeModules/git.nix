{ 
  programs.git = {
    enable = true;

    userName = "ixora-0";
    userEmail = "39961970+ixora-0@users.noreply.github.com";

    signing.signByDefault = true;
    signing.key = "EB180FA4072AE3A9";

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
  };
}
