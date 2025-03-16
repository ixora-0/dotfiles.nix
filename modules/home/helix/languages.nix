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
      This includes support for css, html, json, and also eslint.
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

    r.enable = lib.mkEnableOption "Whether to enabe the R LSP";
    yaml.enable = lib.mkEnableOption "Whether to enabe the yaml LSP";
  };
  options.modules.helix.languages.prettier.enable = lib.mkEnableOption ''Whether to enable prettier'';
  config.programs.helix.extraPackages = let
    includeLSP = opt: lsps: lib.mkIf (cfg.lsp.enableAll || opt) lsps;
  in lib.mkMerge (with pkgs; [
    (includeLSP cfg.lsp.taplo.enable             [taplo])
    (includeLSP cfg.lsp.rustAnalyzer.enable      [rust-analyzer cargo rustPackages.clippy])
    (includeLSP cfg.lsp.vscodeLangservers.enable [vscode-langservers-extracted])
    (includeLSP cfg.lsp.lua.enable               [lua-language-server])
    (includeLSP cfg.lsp.typescript.enable        [nodePackages_latest.typescript-language-server])
    (includeLSP cfg.lsp.svelte.enable            [nodePackages_latest.svelte-language-server])
    (includeLSP cfg.lsp.tailwind.enable          [tailwindcss-language-server])
    (includeLSP cfg.lsp.ruff.enable              [ruff-lsp])
    (includeLSP cfg.lsp.pyright.enable           [pyright])
    (includeLSP cfg.lsp.nil.enable               [nil])
    (includeLSP cfg.lsp.marksman.enable          [marksman])
    (includeLSP cfg.lsp.r.enable                 [(rWrapper.override { packages = [rPackages.languageserver]; })])
    (includeLSP cfg.lsp.yaml.enable                 [yaml-language-server])
  ]);

  config.programs.helix.languages.language-server = lib.mkMerge [
    # rust
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.rustAnalyzer.enable) {
      rust-analyzer.config.check.command = "clippy";
    })

    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.vscodeLangservers.enable) {
      vscode-json-language-server.config.json.keepLines.enable = true;
      # eslint
      eslint.command = "vscode-eslint-language-server";
      eslint.args = ["--stdio"];
      eslint.config = {
        validate = "on";
        quiet = false;
        experimental.userFlatConfig = true;
        rulesCustomizations = [];
        run = "onType";
        problems.shortenToSingleLine = false;
        nodePath = "location";  # use the workspace folder or file location to start eslint server
        codeAction = {
          disableRuleComment = { enable = true; location = "separateLine"; };
          showDocumentation = { enable = true; };
        };
      };
    })

    # ruff
    (lib.mkIf (cfg.lsp.enableAll || cfg.lsp.ruff.enable) {
      ruff.command = "ruff-lsp";
      # ruff.config.line-length = 88;
    })
  ];

  config.programs.helix.languages.language = [
    # toml
    {
      name = "toml";
      auto-format = true;
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
      roots = ["tsconfig.json" "package.json"];
    }
    {
      name = "javascript";
      auto-format = true;
      formatter = lib.mkIf cfg.prettier.enable {
        command = "${pkgs.nodePackages.prettier}/bin/prettier"; 
        args = ["--parser" "espree"];
      };
      language-servers = [
        { 
          name = "typescript-language-server";
          except-features = ["format"];
        }
        "eslint"
      ];
      roots = ["package.json"];
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
      roots = ["package.json"];
    }
    {
      name = "css";
      auto-format = true;
      language-servers = [
        {
          name = "vscode-css-language-server";
          except-features = lib.mkIf cfg.prettier.enable ["format"];
        }
      ];
      formatter = lib.mkIf cfg.prettier.enable {
        command = "${pkgs.nodePackages.prettier}/bin/prettier";
        args = ["--parser" "css"];
      };
    }
    {
      name = "html";
      auto-format = true;
      language-servers = [
        {
          name = "vscode-html-language-server";
          except-features = lib.mkIf cfg.prettier.enable ["format"];
        }
      ];
      formatter = lib.mkIf cfg.prettier.enable {
        command = "${pkgs.nodePackages.prettier}/bin/prettier";
        args = ["--parser" "html"];
      };
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
      language-servers = let
        bothEnabled = cfg.lsp.enableAll || (cfg.lsp.ruff.enable && cfg.lsp.pyright.enable);
      in [
        {
          name = "ruff";
          only-features = lib.mkIf bothEnabled ["format" "diagnostics"];
        }
        {
          name = "pyright";
          except-features = lib.mkIf bothEnabled ["format" "diagnostics"];
        }
      ];
    }
  ];
}
