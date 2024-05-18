{
  programs.yazi = {
    enable = true;
    # enableZshIntegration = true;  # doesn't work with zoxide
                                    # https://github.com/sxyazi/yazi/issues/978
  };
  # HACK: set custom zsh integration
  programs.zsh.initExtra = ''
    function ya() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';
}
