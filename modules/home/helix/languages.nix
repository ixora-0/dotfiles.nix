{ lib, config, pkgs, ... }: let
  cfg = config.modules.helix.languages;
in
{
  options.modules.helix.languages.lsp = {
    enableAll = lib.mkEnableOption ''
      If true, enable all available LSPs.
      If false, follows individual LSP enable option.
    '';
    taplo.enable = lib.mkEnableOption "Whether to enable the taplo LSP";
    rustAnalyzer.enable = lib.mkEnableOption "Whether to enable the rust-analyzer LSP";
    vscodeLangservers.enable = lib.mkEnableOption ''
      Whether to enable vscode-langeservers-extracted LSP.
      This includes support for css, html, json ,and also eslint.
    '';
    typescript.enable = lib.mkEnableOption ''
      Whether to enable the typescript LSP. Also supports javascript.
    '';
    svelte.enable = lib.mkEnableOption "Whether to enable the svelte LSP";
    tailwind.enable = lib.mkEnableOption "Whether to enable the tailwindcss LSP";

    lua.enable = lib.mkEnableOption "Whether to enable the lua LSP";

    ruff.enable = lib.mkEnableOption "Whether to enable the ruff LSP";
    pyright.enable = lib.mkEnableOption "Whether to enable the pyright LSP";

    nil.enable = lib.mkEnableOption "Whether to enable the nil LSP";
    marksman.enable = lib.mkEnableOption "Whether to enable the marksman LSP";
  };
  options.modules.helix.languages.prettier.enable = lib.mkEnableOption ''Whether to enable prettier'';
  config.programs.helix.extraPackages = let 
    includeLSP = opt: lsp: lib.lists.optional (cfg.lsp.enableAll || opt) lsp;
  in with pkgs; (
    includeLSP cfg.lsp.taplo.enable             taplo ++
    includeLSP cfg.lsp.lua.enable               lua-language-server ++
    includeLSP cfg.lsp.vscodeLangservers.enable vscode-langservers-extracted ++
    includeLSP cfg.lsp.typescript.enable        nodePackages_latest.typescript-language-server
  );

  config.programs.helix.languages.language-server = lib.mkMerge [
    # rust
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.rustAnalyzer.enable) {
      rust-analyzer.command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
      rust-analyzer.config.check.command = "${pkgs.clippy}/bin/cargo-clippy";
    })

    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.vscodeLangservers.enable) {
      vscode-json-language-server.config.json.keepLines.enable = true;
      # eslint
      eslint.command = "${pkgs.vscode-langservers-extracted}/bin/vscode-eslint-language-server";
      eslint.args = ["--stdio"];
      eslint.config = {
        validate = "on";
        experimental.userFlatConfig = false;
        rulesCustomizations = [];
        run = "onType";
        problems.shortenToSingleLine = false;
        nodePath = "";  # use the workspace folder or file location to start eslint server
      };
    })
    # svelte
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.svelte.enable) {
      svelteserver.command = "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver";
    })
    # tailwindcss
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.svelte.enable) {
      tailwindcss-ls.command = "${pkgs.tailwindcss-language-server}/bin/tailwindcss-language-server";
    })

    # ruff
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.ruff.enable) {
      ruff.command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
      # ruff.config.line-length = 88;
    })
    # pyright
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.pyright.enable) {
      pyright.command = "${pkgs.nodePackages.pyright}/bin/pyright-langserver";
    })

    # nil
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.nil.enable) {
      nil.command = "${pkgs.nil}/bin/nil";
    })

    # marksman
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.marksman.enable) {
      marksman.command = "${pkgs.marksman}/bin/marksman";
    })
  ];

  config.programs.helix.languages.language = [
    # toml
    {
      name = "toml";
      auto-format = true;
      formatter = lib.mkIf (cfg.lsp.enableAll || cfg.lsp.taplo.enable) {
        command = "${pkgs.taplo}/bin/taplo"; 
        args = ["fmt" "-"];
      };
    }

    # rust
    {
      name = "rust";
      rulers = [100];
      auto-format = true;
    }

    # web langs
    {
      name = "typescript";
      auto-format = true;
      formatter = lib.mkIf cfg.prettier.enable {
        command = "${pkgs.nodePackages.prettier}/bin/prettier"; 
        args = ["--parser" "typescript"];
      };
      language-servers = [
        { 
          name = "typescript-language-server";
          except-features = ["format"];
        }
        "eslint"
      ];
    }
    {
      name = "javascript";
      auto-format = true;
      formatter = lib.mkIf cfg.prettier.enable {
        command = "${pkgs.nodePackages.prettier}/bin/prettier"; 
        args = ["--parser" "javascript"];
      };
      language-servers = [
        { 
          name = "typescript-language-server";
          except-features = ["format"];
        }
        "eslint"
      ];
    }
    {
      name = "svelte";
      auto-format = true;
      formatter = lib.mkIf cfg.prettier.enable {
        command = "${pkgs.nodePackages.prettier}/bin/prettier"; 
        args = ["--parser" "svelte"];
      };
      language-servers = [
        { 
          name = "svelteserver";
          except-features = ["format"];
        }
        "eslint"
        "tailwindcss-ls"
      ];
    }

    # lua
    {
      name = "lua";
      indent.tab-width = 2;
      indent.unit = "  ";
      auto-format = true;
    }

    # python
    {
      name = "python";
      rulers = [88];
      auto-format = true;
      language-servers = [
        # {
        #   name = "ruff";
        #   only-features = ["format", "diagnostics"];
        # }
        "ruff"
        {
          name = "pyright";
          except-features = ["format"];
        }
      ];
    }
  ];
}
