{
  inputs,
  self,
  ...
}:
{
  flake.hjemModules.isolate-apps =
    {
      pkgs,
      ...
    }:
    let
      jail = inputs.jail-nix.lib.init pkgs;

      mkJailedDesktop = self.lib.mkJailedDesktop pkgs pkgs.lib;

      vesktopPkg = pkgs.vesktop;
      bravePkg = pkgs.brave-origin;

      braveJailed = jail "brave" bravePkg (
        with jail.combinators;
        [
          (persist-home "brave")
          network
          gui
          (add-pkg-deps [ pkgs.wl-clipboard ])
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
          (add-pkg-deps [ pkgs.wl-clipboard ])
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
      packages = [
        (mkJailedDesktop braveJailed bravePkg)
        (mkJailedDesktop vesktopJailed vesktopPkg)
      ];
    };
}
