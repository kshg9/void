{
  inputs,
  ...
}:
{
  flake.hjemModules.isolate-pi =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.init pkgs;
      helpers = inputs.self.lib.jailHelpers pkgs lib;

      piPkg = llmPkgs.pi;

      piJailed = jail "pi" piPkg [
        (helpers.cliAgent jail {
          name = "pi";
          background = true;
        })
      ];
    in
    {
      packages = [ piJailed ];
    };
}
