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

      agyPkg = helpers.wrapAgent llmPkgs.antigravity-cli (
        with pkgs;
        [
          bash
          coreutils
          wl-clipboard
        ]
      );
      agent-runtime = helpers.agentRuntime jail;

      agyJailed = jail "agy" agyPkg (
        with jail.combinators;
        [
          network
          gui
          (persist-home "agy")

          (try-readwrite (noescape "~/Projects"))
          (try-readwrite (noescape "~/Downloads"))

          # (try-readonly "/var/log")
          # ——— dynamic CWD ~/JailedProject: JAIL_RW=. agy ———
          agent-runtime
        ]
      );
    in
    {
      environment.systemPackages = [ agyJailed ];
    };
}
