# Neovim: the binary, the plugins, the language servers and the tree-sitter
# grammars all come from Nix. The Lua configuration is a dotfile and lives in
# ../user/dots/nvim, so it ends up in ~/.config/nvim.
{
  inputs,
  ...
}:
{
  flake.nixosModules.neovim =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      vimPlugins = pkgs.vimPlugins;

      # Languages that get a tree-sitter grammar.
      #
      # This list follows the files that actually exist in ~/Projects:
      # C and C++, Python, Nix, shell, Lua (this configuration), the web
      # projects (html, css, js, ts), Go, and the file formats around them.
      grammars = [
        "bash"
        "c"
        "cpp"
        "css"
        "diff"
        "fish"
        "gitcommit"
        "go"
        "html"
        "javascript"
        "json"
        "lua"
        "make"
        "markdown"
        "nix"
        "python"
        "toml"
        "typescript"
        "xml"
        "yaml"
      ];
    in
    {
      imports = [
        # The install module turns the wrapper into a normal option namespace
        # ("wrappers.neovim") with an "enable" flag. It is the same module as
        # inputs.wrappers.lib.getInstallModule { name = "neovim"; value = ...; }
        # for every wrapper, just pre-built.
        inputs.wrappers.nixosModules.neovim
      ];

      wrappers.neovim = {
        enable = true;

        # The Lua configuration is a dotfile, so the wrapper finds it in
        # ~/.config/nvim without being told where it is.

        # Plugins. mini.nvim holds all of its modules in one package; only the
        # ones you call setup() on are used, from the Lua configuration.
        specs.plugins.data = [
          vimPlugins.mini-nvim
          vimPlugins.kanagawa-nvim
        ];

        # Tree-sitter: the parser of a language, and the queries that say how
        # to highlight it.
        specs.treesitter.data = lib.concatMap (lang: [
          vimPlugins.nvim-treesitter.parsers.${lang}
          vimPlugins.nvim-treesitter.queries.${lang}
        ]) grammars;

        # Programs neovim should be able to call. These are binaries only:
        # which of them actually run is decided by the Lua configuration.
        runtimePkgs = with pkgs; [
          clang-tools # clangd (C/C++) and clang-format
          nixd # Nix language server
          nixfmt # formatter used by nixd
          basedpyright # Python language server, enabled per project
          ruff # Python linter and formatter
          lua-language-server # Lua, for this very configuration
          bash-language-server # shell scripts
          yaml-language-server # yaml
          ripgrep # `rg`, used by mini.pick
          fd # `fd`, alternative file finder
          gdb # debugger, for when you want one
        ];
      };

      environment.systemPackages = [
        config.wrappers.neovim.wrapper
      ];
    };
}
