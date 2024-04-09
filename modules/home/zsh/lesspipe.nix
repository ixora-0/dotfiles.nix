{ pkgs, ... }: {
  home.packages = [
    # https://github.com/NikitaIvanovV/ctpv/blob/4efa0f976eaf8cb814e0aba4f4f1a1d12ee9262e/previews.h#L67
    # TODO: confirm jupyter, jq, eza, exiftool bin path
    # TODO: adjust dimension (for glow, chafa)

    (pkgs.writeShellScriptBin "lessfilter" ''
      mime=''$(file -Lbs --mime-type "$1")
      category=''${mime%%/*}
      kind=''${mime##*/}
      ext=''${1##*.}
      archive_exts=(
        "tar.gz" "tgz"
        "tar.bz2" "tbz2"
        "tar.xz" "txz"
        "tar.Z" "tZ"
        "7z"
        "zip"
        "rar"
        "gz"
        "tar"
      )
      if [[ " ''${archive_exts[@]} " =~ " $ext " ]]; then
        ${pkgs.atool}/bin/atool -l -- "$1"
      elif [ "$kind" = json ]; then
        if [ "$ext" = ipynb ]; then
          ${pkgs.jupyter}/bin/jupyter nbconvert --to python --stdout "$1" | ${pkgs.bat}/bin/bat --color=always -plpython
        else
          ${pkgs.jq}/bin/jq -Cr . "$1"
        fi
      elif [ -d "$1" ]; then
        ${pkgs.eza}/bin/eza -hl --git --color=always --icons "$1"
      elif [ "$kind" = pdf ]; then
        ${pkgs.glow}/bin/glow "$1"
      elif [ "$kind" = rfc822 ]; then
        ${pkgs.bat}/bin/bat --color=always -lEmail "$1"
      elif [ "$kind" = javascript ]; then
        ${pkgs.bat}/bin/bat --color=always -ljs "$1"
      # https://github.com/wofr06/lesspipe/pull/106
      elif [ "$category" = image ]; then
        ${pkgs.chafa}/bin/chafa -f symbols "$1"
        ${pkgs.exiftool}/bin/chafa "$1" | ${pkgs.bat}/bin/bat --color=always -plyaml
      elif [ "$category" = text ]; then
        ${pkgs.bat}/bin/bat --color=always "$1"
      else
        exit 1
      fi
    '')
  ];
}
