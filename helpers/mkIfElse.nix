{ lib }: p: yes: no: lib.mkMerge [
  (lib.mkIf p yes)
  (lib.mkIf (!p) no)
]
