{
  inputs,
  ...
}:
{
  flake.nixosModules.isolate-pi =
    { pkgs, lib, ... }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

      wrapAgent =
        pkg:
        pkgs.symlinkJoin {
          name = "${pkg.name}-deps-wrapped";
          paths = [ pkg ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            for bin in $out/bin/*; do
              wrapProgram "$bin" \
                --prefix PATH : ${
                  lib.makeBinPath [
                    pkgs.nodejs
                    pkgs.pnpm
                  ]
                }
            done
          '';
        };
    in
    {
      imports = [ inputs.nixjail.nixosModules.nixjail ];

      nixjail.bwrap.profiles = [
        {
          packages = f: p: {
            pi = wrapAgent llmPkgs.pi;
          };

          xdg = true;

          autoBindHome = true;
          homeDirRoot = "$HOME/.nixjail";

          rwBinds = [
            "$HOME/Projects"
          ];

          extraConfig = [
            "\$(for b in \${NIXJAIL_RW_BINDS:-}; do echo \"--bind-try \$b \$b\"; done)"
            "\$(for b in \${NIXJAIL_RO_BINDS:-}; do echo \"--ro-bind-try \$b \$b\"; done)"
            "\${NIXJAIL_EXTRA:-}"
          ];
        }
      ];
    };
}
