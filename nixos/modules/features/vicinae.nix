{ inputs, ... }: {
  flake.nixosModules.vicinae =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [
        inputs.vicinae.nixosModules.default
      ];

      config = lib.mkIf config.extras.vicinae.enable {
        environment.systemPackages = [
          inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
        programs.vicinae.input-server = {
          enable = true;
          package = inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default;
        };
      };
    };
  perSystem = { system, ... }: {
    packages.vicinae = inputs.vicinae.packages.${system}.default;
  };
}
