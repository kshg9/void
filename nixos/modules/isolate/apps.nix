{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.isolate-apps =
    {
      pkgs,
      ...
    }:
    let
      jail = inputs.jail-nix.lib.init pkgs;

      helpers = self.lib.jailHelpers pkgs pkgs.lib;
      inherit (helpers) mkJailedDesktop;

      chromePkg = pkgs.google-chrome;
      vesktopPkg = pkgs.vesktop;

      chromeJailed = jail "chrome" chromePkg (
        with jail.combinators;
        [
          (persist-home "chrome")
          network
          gui
          gpu
          pipewire
          pulse
          unsafe-dbus
          camera

          (try-readwrite (noescape "~/Downloads"))
          (try-readwrite (noescape "~/Pictures"))
        ]
      );

      vesktopJailed = jail "vesktop" vesktopPkg (
        with jail.combinators;
        [
          (persist-home "vesktop")
          network
          gui
          gpu
          pipewire
          pulse
          unsafe-dbus
          camera

          (try-readwrite (noescape "~/Downloads"))
          (try-readwrite (noescape "~/Pictures"))
        ]
      );
    in
    {
      environment.systemPackages = [
        (mkJailedDesktop chromeJailed chromePkg)
        (mkJailedDesktop vesktopJailed vesktopPkg)
      ];
    };
}
