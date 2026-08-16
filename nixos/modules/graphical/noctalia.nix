{ inputs, ... }: {
  flake.nixosModules.noctalia = { pkgs, lib, ... }: {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs.noctalia = {
      enable = true;
      package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      recommendedServices.enable = true;
    };

    # Override default recommendation of noctalia
    services.power-profiles-daemon.enable = false;
  };
}
