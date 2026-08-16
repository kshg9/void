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
          # TPM unlock setup commands:
          # sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0+7 /dev/nvme0n1p3
          # sudo systemd-cryptenroll /dev/nvme0n1p3
          pkgs.sbctl
        ];

        persistence.directories = [ "/var/lib/sbctl" ];
      };
    };
}
