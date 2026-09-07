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

      vesktopPkg = pkgs.vesktop;
      bravePkg = pkgs.brave-origin;

      braveJailed = jail "brave" bravePkg (
        with jail.combinators;
        [
          (persist-home "brave")
          network
          gui
          gpu
          pipewire
          pulse
          unsafe-dbus
          camera

          (try-readwrite (noescape "~/Downloads"))
          (try-readwrite (noescape "~/Pictures"))
          (try-readwrite "/tmp")
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
        (mkJailedDesktop braveJailed bravePkg)
        (mkJailedDesktop vesktopJailed vesktopPkg)
      ];
    };
}
