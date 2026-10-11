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
      chromiumPkg = pkgs.ungoogled-chromium;

      chromiumJailed = jail "chromium" chromiumPkg (
        with jail.combinators;
        [
          (persist-home "chromium")
          network
          gui
          (add-pkg-deps [ pkgs.wl-clipboard ])
          gpu
          pipewire
          pulse
          unsafe-dbus
          camera

          (try-readwrite (noescape "~/Downloads"))
          (try-readwrite (noescape "~/Documents"))
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
          (try-readwrite (noescape "~/Documents"))
          (try-readwrite (noescape "~/Pictures"))
        ]
      );
    in
    {
      packages = [
        (mkJailedDesktop chromiumJailed chromiumPkg)
        (mkJailedDesktop vesktopJailed vesktopPkg)
      ];
    };
}
