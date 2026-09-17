{
  flake.nixosModules.rootRollback =
    {
      config,
      lib,
      pkgs,
      utils,
      ...
    }:
    let
      cfg = config.persistence;
      device = "/dev/mapper/${cfg.luksName}";
      deviceUnit = "${utils.escapeSystemdPath device}.device";
    in
    {
      config = lib.mkIf (cfg.enable && cfg.nukeRoot.enable) {
        boot.initrd.systemd.services.rollback = {
          description = "Restore the Btrfs root from its blank template";
          requiredBy = [ "sysroot.mount" ];
          requires = [ deviceUnit ];
          after = [
            deviceUnit
            "systemd-hibernate-resume.service"
          ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            # Later initrd mounts require sysroot.mount again. Keep rollback
            # active so that dependency cannot rerun it on the mounted root.
            RemainAfterExit = true;
          };
          path = [
            pkgs.btrfs-progs
            pkgs.util-linux
            pkgs.coreutils
          ];
          environment.ROLLBACK_DEVICE = device;
          script = builtins.readFile ./rollback.sh;
        };
      };
    };
}
