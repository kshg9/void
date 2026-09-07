{
  inputs,
  ...
}:
{
  flake.nixosModules.isolate-dsh =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.init pkgs;

      helpers = inputs.self.lib.jailHelpers pkgs lib;

      agent-runtime = helpers.agentRuntime jail;

      dshJailed = jail "dsh" llmPkgs.dsh (
        with jail.combinators;
        [
          network
          gui
          (persist-home "dsh")

          (try-readwrite (noescape "~/Projects"))
          (try-readwrite (noescape "~/Downloads"))
          agent-runtime
          (add-pkg-deps (
            with pkgs;
            [
              nodejs
              pnpm
            ]
          ))
        ]
      );
    in
    {
      environment.systemPackages = [ dshJailed ];
    };
}
