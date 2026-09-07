{
  inputs,
  ...
}:
{
  flake.nixosModules.isolate-agy =
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

      agyJailed = jail "agy" llmPkgs.antigravity-cli (
        with jail.combinators;
        [
          network
          gui
          (persist-home "agy")

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
      environment.systemPackages = [ agyJailed ];
    };
}
