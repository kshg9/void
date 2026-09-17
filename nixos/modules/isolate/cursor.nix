{
  inputs,
  ...
}:
{
  flake.nixosModules.isolate-cursor =
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

      cursorJailed = jail "cursor" llmPkgs.cursor-agent (
        with jail.combinators;
        [
          network
          gui
          (persist-home "cursor")

          (try-readwrite (noescape "~/Projects"))
          (try-readwrite (noescape "~/Downloads"))
          agent-runtime
          (add-pkg-deps (
            with pkgs;
            [
              eza
              fd
            ]
          ))
        ]
      );
    in
    {
      environment.systemPackages = [ cursorJailed ];
    };
}
