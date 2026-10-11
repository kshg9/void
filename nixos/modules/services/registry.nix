{
  flake.nixosModules.serviceRegistry =
    { lib, ... }:
    let
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
    in
    {
      options.system.serviceRegistry = lib.mkOption {
        default = { };
        description = "Persistence metadata for service state not fully declared by upstream units.";
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                  description = "Include this entry's persistence metadata; does not enable or disable the service.";
                };
                unit = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                  description = "Systemd unit name, without the .service suffix.";
                };
                state = {
                  directories = lib.mkOption {
                    type = lib.types.listOf relativePath;
                    default = [ ];
                    description = "StateDirectory names missing from automatic discovery.";
                  };
                  paths = lib.mkOption {
                    type = lib.types.listOf absolutePath;
                    default = [ ];
                    description = "Additional persistent paths for state not declared by a unit.";
                  };
                  persist = lib.mkOption {
                    type = lib.types.bool;
                    default = true;
                    description = "Persist this service's state; false also opts its unit out of automatic discovery.";
                  };
                };
              };
            }
          )
        );
      };
    };
}
