{
  inputs,
  ...
}:
{
  flake.nixosModules.lanzaboote =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        inputs.lanzaboote.nixosModules.lanzaboote
      ];

      config = lib.mkIf config.extras.lanzaboote.enable {
        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = {
          enable = true;

          pkiBundle = "/var/lib/sbctl";

          autoGenerateKeys.enable = true;
          autoEnrollKeys = {
            enable = true;
            includeMicrosoftKeys = true;
            includeFirmwareBuiltinKeys = true;
          };
        };

        environment.systemPackages = [
          # Debugging/verification: `sbctl status`, `sbctl verify`, manual enroll.
          pkgs.sbctl
        ];

        persistence.directories = [ "/var/lib/sbctl" ];
      };
    };
}
