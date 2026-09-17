{
  inputs,
  self,
  ...
}:
{
  flake.hjemModules.isolate-agents =
    {
      pkgs,
      ...
    }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
      jail = inputs.jail-nix.lib.extend {
        inherit pkgs;
      };

      helpers = self.lib.jailHelpers pkgs pkgs.lib;
      mkJailedDesktop = self.lib.mkJailedDesktop pkgs pkgs.lib;
      agent-runtime = helpers.agentRuntime jail;

      claudePkg = llmPkgs.claude-desktop;

      claudeJailed = jail "claude-desktop" claudePkg (
        with jail.combinators;
        [
          agent-runtime
          (persist-home "claude-desktop")
          network
          gui
          gpu
          unsafe-dbus
          open-urls-in-browser

          (try-readwrite "/tmp")

          (try-readwrite (noescape "~/Projects"))
          (try-readwrite (noescape "~/Documents"))
          (try-readwrite (noescape "~/Downloads"))
        ]
      );
    in
    {
      packages = [
        (mkJailedDesktop claudeJailed claudePkg)
      ];

    };
}
