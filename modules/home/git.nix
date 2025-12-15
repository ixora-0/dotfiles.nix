{ 
  programs.git = {
    enable = true;

    settings = {
      user.name = "ixora-0";
      user.email = "39961970+ixora-0@users.noreply.github.com";

      core.autocrlf = "input";
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };

    signing.signByDefault = true;
    # signing.key = "0959B5BC39B44064";
    signing.key = "~/.ssh/id_ed25519.pub";

    ignores = [
      "*.backup"
      "TEST*"
    ];
  };

  # use delta pager
  programs.delta.enable = true;
  programs.delta.options = {
    line-numbers = true;
    side-by-side = true;
  };
}
