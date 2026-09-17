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

      agent-runtime = helpers.agentRuntime jail;

      opencodeJailed = jail "opencode" llmPkgs.opencode2 (
        with jail.combinators;
        [
          network
          gui
          (persist-home "opencode")

          (try-readwrite (noescape "~/Projects"))
          (try-readwrite (noescape "~/Downloads"))
          agent-runtime
          (add-pkg-deps (
            with pkgs;
            [
              nodejs
              pnpm
              python3
            ]
          ))
        ]
      );
    in
    {
      packages = [ opencodeJailed ];
    };
}
