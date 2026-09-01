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

      dshPkg = helpers.wrapAgent llmPkgs.dsh (
        with pkgs;
        [
          bash
          nodejs
          pnpm
          wl-clipboard
        ]
      );
      agent-runtime = helpers.agentRuntime jail;

      dshJailed = jail "dsh" dshPkg (
        with jail.combinators;
        [
          network
          gui
          (persist-home "dsh")

          (try-readwrite (noescape "~/Projects"))
          (try-readwrite (noescape "~/Downloads"))

          agent-runtime
        ]
      );
    in
    {
      environment.systemPackages = [ dshJailed ];
    };
}
