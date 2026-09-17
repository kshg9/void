{
  inputs,
  ...
}:
{
  flake.hjemModules.isolate-codex =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.init pkgs;
      helpers = inputs.self.lib.jailHelpers pkgs lib;

      codexPkg = llmPkgs.codex;

      codexJailed = jail "codex" codexPkg [
        (helpers.cliAgent jail {
          name = "codex";
          background = true;
          runtimePackages = [ pkgs.bubblewrap ];
        })
      ];
    in
    {
      packages = [ codexJailed ];
    };
}
