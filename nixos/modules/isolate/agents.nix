{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.isolate-agents =
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
      inherit (helpers) mkJailedDesktop;

      claudePkg = llmPkgs.claude-desktop;
      chatgptPkg = llmPkgs.chatgpt;

      claudeJailed = jail "claude-desktop" claudePkg (
        with jail.combinators;
        [
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

      chatgptJailed = jail "chatgpt" chatgptPkg (
        with jail.combinators;
        [
          (persist-home "chatgpt")
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
      environment.systemPackages = [
        (mkJailedDesktop claudeJailed claudePkg)
        (mkJailedDesktop chatgptJailed chatgptPkg)
      ];

    };
}
