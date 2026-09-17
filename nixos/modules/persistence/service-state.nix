{ self, ... }:
{
  flake.nixosModules.serviceState =
    { config, lib, ... }:
    let
      cfg = config.persistence;
      helpers = self.lib.persistenceHelpers lib;
      state = helpers.discoverState {
        services = config.systemd.services;
        registry = config.system.serviceRegistry;
        inherit (cfg.serviceState) excludeServices excludePaths;
      };
    in
    {
      config = lib.mkMerge [
        {
          persistence.serviceState.discovered =
            if cfg.enable && cfg.serviceState.enable then state.directories else [ ];
        }
        (lib.mkIf (cfg.enable && cfg.serviceState.enable) {
          warnings = map (
            entry:
            "State path not automatically persisted (${entry}); add an explicit persistence.directories entry if needed."
          ) state.skipped;
          systemd.tmpfiles.rules = lib.optional (
            state.privateDirectories != [ ]
          ) "d /var/lib/private 0700 root root -";
          environment.etc."nixos/persistence.json".text = builtins.toJSON {
            inherit (state) directories privateDirectories skipped;
            services = lib.mapAttrs (_: service: {
              inherit (service) unit;
              inherit (service.state) directories paths persist;
            }) config.system.serviceRegistry;
          };
        })
      ];
    };
}
