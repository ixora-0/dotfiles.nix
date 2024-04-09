{ lib, config, pkgs, ... }: let
  cfg = config.modules.zsh;
in
{
  options.modules.zsh.plugins = {
    fastSyntaxHighlighting.enable = lib.mkEnableOption ''
      Whether to enable fast-syntax-highlighting.
    '';

  # BUG: sometimes have % sign at top of terminal on launch
  # solution: https://github.com/lxqt/qterminal/issues/778#issuecomment-857735806
    powerlevel10k.enable = lib.mkEnableOption "Whether to enable powerlevel10k.";
  };

  options.modules.zsh.ohMyZsh = {
    enable = lib.mkEnableOption "Whether to enable oh-my-zsh";
    plugins =  lib.mkOption {
      default = [];
      example = [ "git" "sudo" ];
      type = lib.types.listOf lib.types.str;
      description = ''
        List of oh-my-zsh plugins
      '';
    };
  };

  config.programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = lib.mkIf (!cfg.plugins.fastSyntaxHighlighting.enable) true;

    shellAliases = {
      kysnow = "shutdown -h now";
      zzz = "systemctl suspend";
    };

    plugins = [
      (lib.mkIf cfg.plugins.fastSyntaxHighlighting.enable {
        name = "fast-syntax-highlighting";
        src = pkgs.zsh-fast-syntax-highlighting;
      })
      (lib.mkIf cfg.plugins.powerlevel10k.enable {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";  # has to be a string not path
      })
    ];

    initExtra = lib.mkIf cfg.plugins.powerlevel10k.enable ''
      source ${./p10k.zsh}
    '';

    oh-my-zsh = {
      enable = lib.mkIf cfg.ohMyZsh.enable true;
      plugins = cfg.ohMyZsh.plugins;
    };
  };
}
