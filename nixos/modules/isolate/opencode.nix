{
  inputs,
  ...
}:
{
  flake.hjemModules.isolate-opencode =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.init pkgs;

      helpers = inputs.self.lib.jailHelpers pkgs lib;

      opencodeJailed = jail "opencode" llmPkgs.opencode2 [
        (helpers.cliAgent jail {
          name = "opencode";
          runtimePackages = with pkgs; [
            nodejs
            pnpm
            python3
          ];
        })
      ];
    in
    {
      packages = [ opencodeJailed ];
    };
}
