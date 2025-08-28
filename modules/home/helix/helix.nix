{ pkgs, ... }: {
  imports = [./languages.nix];

  # TODO: if wayland then wl-clipboard
  home.packages = [pkgs.wl-clipboard];

  # TODO: module option for theme

  # set default editors
  # home.sessionVariables.EDITOR = "${pkgs.helix}/bin/hx";
  programs.git.extraConfig.core.editor = "${pkgs.helix}/bin/hx";

  programs.helix = {
    enable = true;
    # package = inputs.helix.packages."${pkgs.system}".default;  # get from the helix flake
    defaultEditor = true;

    settings = {
      theme = "base16_transparent";
      # theme = "ayu_evolve";
      editor = {
        rulers = [80];
        auto-format = true;
        cursor-shape.insert = "bar";
        soft-wrap.enable = true;
        whitespace.render.tab = "all";
        file-picker.hidden = false;
      };

      keys.normal = {
        C-s = ":w";
        g.h = "goto_first_nonwhitespace";
        g.s = "goto_line_start";
        X = ["goto_first_nonwhitespace" "extend_to_line_end"];
        "{" = ["goto_prev_paragraph" "collapse_selection"];
        "}" = ["goto_next_paragraph" "collapse_selection"];
        ret = ["open_below" "normal_mode"];
        C-right = "move_next_word_start";
        C-left = "move_prev_word_start";
        space.c = "toggle_comments";
        space.u = "switch_to_lowercase";
        space.U = "switch_to_uppercase";
        A-up = [
          "ensure_selections_forward"
          "extend_to_line_bounds"
          "extend_char_right"
          "extend_char_left"
          "delete_selection"
          "move_line_up"
          "add_newline_above"
          "move_line_up"
          "replace_with_yanked"
        ];
        A-down = [
          "ensure_selections_forward"
          "extend_to_line_bounds"
          "extend_char_right"
          "extend_char_left"
          "delete_selection"
          "add_newline_below"
          "move_line_down"
          "replace_with_yanked"
        ];
      };
      keys.insert = {
        C-s = ":w";
        j.k = "normal_mode";
        up = "no_op";
        down = "no_op";
        left = "no_op";
        right = "no_op";
        pageup = "no_op";
        pagedown = "no_op";
        home = "no_op";
        end = "no_op";
      };
      keys.select = {
        "C-/" = "toggle_comments";
        space.c = "toggle_comments";
        space.u = "switch_to_lowercase";
        space.U = "switch_to_uppercase";
        esc = ["normal_mode" "collapse_selection"];
      };
    };
  };
}
