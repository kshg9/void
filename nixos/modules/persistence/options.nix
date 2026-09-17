{
  flake.nixosModules.persistenceOptions = { lib, ... }: {
    options.persistence = {
      enable = lib.mkEnableOption "enable persistence";

      nukeRoot.enable = lib.mkEnableOption "Restore the root filesystem from its blank Btrfs snapshot on every boot.";

      luksName = lib.mkOption {
        type = lib.types.str;
        default = "enc";
        description = ''
          LUKS mapper name (the device name after cryptsetup open,
          becomes /dev/mapper/<name>).
        '';
      };

      directories = lib.mkOption {
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
        default = [ ];
        description = ''
          directories to persist
        '';
      };

      files = lib.mkOption {
        type = lib.types.listOf (lib.types.either lib.types.str lib.types.attrs);
        default = [ ];
        description = ''
          files to persist
        '';
      };

      serviceState = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Discover persistent state from systemd units and the service registry.";
        };
        excludeServices = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Units whose state should not be automatically persisted.";
        };
        excludePaths = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Paths, including their descendants, excluded from automatic persistence.";
        };
        discovered = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          readOnly = true;
          description = "Automatically discovered persistent state paths.";
        };
      };
    };
  };
}
