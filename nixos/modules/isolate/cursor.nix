{
  inputs,
  ...
}:
{
  flake.hjemModules.isolate-cursor =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.init pkgs;
      helpers = inputs.self.lib.jailHelpers pkgs lib;

      cursorJailed = jail "cursor" llmPkgs.cursor-agent [
        (helpers.cliAgent jail {
          name = "cursor";
          runtimePackages = with pkgs; [
            eza
            fd
            python3
          ];
        })
      ];
    in
    {
      packages = [ cursorJailed ];
    };
}
