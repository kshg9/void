{ inputs, ... }: {
  flake.nixosModules.vicinae =
    { config, lib, ... }:
    lib.mkIf config.extras.vicinae.enable { };

  perSystem = { system, ... }: {
    packages.vicinae = inputs.vicinae.packages.${system}.default;
  };
}
