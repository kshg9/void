{
  inputs,
  ...
}:
{
  flake.hjemModules.isolate-agy =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.init pkgs;
      helpers = inputs.self.lib.jailHelpers pkgs lib;

      agyJailed = jail "agy" llmPkgs.antigravity-cli [
        (helpers.cliAgent jail {
          name = "agy";
          runtimePackages = with pkgs; [
            eza
            fd
            python3
          ];
        })
      ];
    in
    {
      packages = [ agyJailed ];
    };
}
