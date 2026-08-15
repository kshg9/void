{
  flake.hjemModules.vscodium =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        (vscode-with-extensions.override {
          vscode = vscodium-fhs;
          vscodeExtensions = with vscode-extensions; [
            jnoortheen.nix-ide
            yoavbls.pretty-ts-errors
            #llvm-vs-code-extensions.vscode-clangd
            #rust-lang.rust-analyzer
          ];
        })
      ];
    };
}
