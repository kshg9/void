{
  inputs,
  self,
  lib,
  ...
}:
{
  options.flake = {
    hjemModules = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
      description = "Exported hjem modules";
    };

    lib = lib.mkOption {
      type = lib.types.lazyAttrsOf lib.types.unspecified;
      default = { };
      description = "Shared construction helpers for this flake";
    };
  };

  config.flake.lib = {
    mkHost =
      { module }:
      inputs.nixpkgs.lib.nixosSystem {
        modules = [ module ];
        specialArgs = {
          inherit inputs self;
        };
      };

    mkDots =
      {
        dir,
      }:
      let
        rootDir = "${dir}";
        findPaths =
          pathInside:
          let
            fullPath = dir + (if pathInside == "" then "" else "/${pathInside}");
            contents = builtins.readDir fullPath;
            paths = lib.mapAttrsToList (
              n: type:
              let
                rel = if pathInside == "" then n else "${pathInside}/${n}";
              in
              if type == "directory" then findPaths rel else rel
            ) contents;
          in
          lib.flatten paths;
        filesList = if builtins.pathExists dir then findPaths "" else [ ];
      in
      lib.genAttrs filesList (file: {
        source = "${rootDir}/${file}";
      });
  };
}
