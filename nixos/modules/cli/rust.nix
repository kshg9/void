{ inputs, ... }: {
  flake.nixosModules.rust =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.extras.rust.enable {
        environment.systemPackages = [
          inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system}.complete.toolchain
        ];
      };
    };
}
