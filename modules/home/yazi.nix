{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    keymap.mgr.prepend_keymap = [{
      on = ["<C-n>"];
      run = ''shell -- ${pkgs.dragon-drop}/bin/dragon-drop -x -i -T "$1"'';
    }];
  };
}
