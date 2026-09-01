{
  inputs,
  ...
}:
{
  flake.nixosModules.isolate-pi =
    {
      pkgs,
      lib,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.init pkgs;

      helpers = inputs.self.lib.jailHelpers pkgs lib;

      piPkg = helpers.wrapAgent llmPkgs.pi (
        with pkgs;
        [
          nodejs
          pnpm
          wl-clipboard
        ]
      );
      agent-runtime = helpers.agentRuntime jail;

      piJailed = jail "pi" piPkg (
        with jail.combinators;
        [
          network
          gui
          (persist-home "pi")

          (try-readwrite (noescape "~/Projects"))
          (try-readwrite (noescape "~/Downloads"))

          agent-runtime
        ]
      );
    in
    {
      environment.systemPackages = [ piJailed ];
    };
}
