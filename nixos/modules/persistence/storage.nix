{ inputs, self, ... }: {
  flake.nixosModules.impermanenceImpl =
    {
      lib,
      config,
      ...
    }:
    let
      cfg = config.persistence;
      helpers = self.lib.persistenceHelpers lib;
    in
    {
      imports = [
        inputs.impermanence.nixosModules.impermanence
        self.nixosModules.serviceState
        self.nixosModules.rootRollback
      ];

      config = lib.mkIf cfg.enable {
        fileSystems = {
          "/persist".neededForBoot = true;
          "/home".neededForBoot = true;
          "/var/log".neededForBoot = true;
        };
        programs.fuse.userAllowOther = true;
        boot.tmp.cleanOnBoot = lib.mkDefault true;

        boot.initrd.systemd.enable = true;

        environment.persistence = {
          "/persist/system" = {
            hideMounts = true;
            directories = helpers.collapseDirectories (
              cfg.directories
              ++ [
                "/etc/nixos"
                "/var/lib/bluetooth"
                "/var/lib/nixos"
                "/var/lib/systemd/coredump"
                "/etc/NetworkManager/system-connections"
              ]
              ++ map (
                directory:
                if lib.hasPrefix "/var/lib/private/" directory then
                  {
                    inherit directory;
                    mode = "0700";
                  }
                else
                  directory
              ) cfg.serviceState.discovered
            );
            files = [
              "/etc/machine-id"
              "/etc/lact/config.yaml"
            ]
            ++ cfg.files;
          };
        };

      };
    };
}
