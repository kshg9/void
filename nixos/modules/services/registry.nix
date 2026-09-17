{
  flake.nixosModules.serviceRegistry =
    {
      config,
      lib,
      utils,
      ...
    }:
    let
      cfg = config.system.serviceRegistry;
      relativePath = lib.types.addCheck lib.types.str (
        value:
        value != ""
        && value != "."
        && !lib.hasPrefix "/" value
        && builtins.match "[A-Za-z0-9_./-]+" value != null
        && !lib.elem ".." (lib.splitString "/" value)
      );
      absolutePath = lib.types.addCheck lib.types.str (
        value: value != "/" && lib.hasPrefix "/" value && !lib.elem ".." (lib.splitString "/" value)
      );
      managed = lib.filterAttrs (_: service: service.enable && service.exec.argv != null) cfg;
    in
    {
      options.system.serviceRegistry = lib.mkOption {
        default = { };
        description = "Service registry: commands for custom units, state metadata for existing NixOS services.";
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }: {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Enable this registry entry and any custom unit it declares.";
                };
                unit = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                  description = "Systemd unit name, without the .service suffix.";
                };
                description = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                  description = "Description of a custom service.";
                };
                user = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Static service user; null uses a systemd dynamic user for custom units.";
                };
                after = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = "Units ordered before a custom service.";
                };
                wants = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ ];
                  description = "Dependencies started with a custom service.";
                };
                wantedBy = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [ "multi-user.target" ];
                  description = "Targets that start a custom service.";
                };
                exec = {
                  argv = lib.mkOption {
                    type = lib.types.nullOr (lib.types.addCheck (lib.types.listOf lib.types.str) (args: args != [ ]));
                    default = null;
                    description = "Command and arguments; null records metadata without replacing an upstream unit.";
                  };
                  packages = lib.mkOption {
                    type = lib.types.listOf lib.types.package;
                    default = [ ];
                    description = "Packages available on a custom service's PATH.";
                  };
                  restart = lib.mkOption {
                    type = lib.types.enum [
                      "no"
                      "on-failure"
                      "always"
                    ];
                    default = "on-failure";
                    description = "Restart policy for a custom service.";
                  };
                  restartDelay = lib.mkOption {
                    type = lib.types.str;
                    default = "5s";
                    description = "Delay before restarting a custom service.";
                  };
                };
                state = {
                  directories = lib.mkOption {
                    type = lib.types.listOf relativePath;
                    default = [ ];
                    description = "StateDirectory names; also set on custom units.";
                  };
                  paths = lib.mkOption {
                    type = lib.types.listOf absolutePath;
                    default = [ ];
                    description = "Additional persistent paths for state not declared by a unit.";
                  };
                  persist = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Persist this service's declared state while system persistence is enabled.";
                  };
                };
                limits = {
                  memory = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Optional systemd MemoryMax for custom services.";
                  };
                  cpu = lib.mkOption {
                    type = lib.types.nullOr lib.types.str;
                    default = null;
                    description = "Optional systemd CPUQuota for custom services.";
                  };
                };
              };
            }
          )
        );
      };

      config = {
        assertions = [
          {
            assertion =
              lib.length (lib.attrNames managed)
              == lib.length (lib.unique (lib.mapAttrsToList (_: service: service.unit) managed));
            message = "Custom system.serviceRegistry entries must have distinct unit names.";
          }
        ];
        systemd.services = lib.mapAttrs' (
          _: service:
          lib.nameValuePair service.unit {
            inherit (service)
              description
              after
              wants
              wantedBy
              ;
            path = service.exec.packages;
            serviceConfig = {
              ExecStart = utils.escapeSystemdExecArgs service.exec.argv;
              Restart = service.exec.restart;
              RestartSec = service.exec.restartDelay;
              DynamicUser = service.user == null;
              PrivateTmp = true;
              NoNewPrivileges = true;
              StateDirectory = service.state.directories;
            }
            // lib.optionalAttrs (service.user != null) { User = service.user; }
            // lib.optionalAttrs (service.limits.memory != null) { MemoryMax = service.limits.memory; }
            // lib.optionalAttrs (service.limits.cpu != null) { CPUQuota = service.limits.cpu; };
          }
        ) managed;
      };
    };
}
