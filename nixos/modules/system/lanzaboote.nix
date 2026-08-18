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
          # refered https://discourse.nixos.org/t/secure-boot-hibernation/78366/3
          configurationLimit = 8; # maximum by systemd-pcrlock (see https://github.com/nix-community/lanzaboote/blob/b9e331d75d4618c7073ea08ff30fddf9a7d2fb08/nix/modules/lanzaboote.nix#L429-L438)

          autoGenerateKeys.enable = true;
          autoEnrollKeys = {
            enable = true;
            includeMicrosoftKeys = true;
            includeFirmwareBuiltinKeys = true;
          };

          measuredBoot = {
            enable = true;

            # PCR 0: BIOS/Firmware
            # PCR 4: Bootloader (Lanzaboote)
            # PCR 7: Secure Boot state
            pcrs = [
              0
              4
              7
            ];

            autoCryptenroll = {
              enable = true;
              # Ties your TPM directly to your LUKS partition for passwordless boot!
              # If your BIOS, Bootloader, or Secure Boot state changes, the TPM safely locks the drive.
              device = "/dev/disk/by-id/nvme-SAMSUNG_MZALQ512HBLU-00BL2_S65DNX1T647774-part3";
              autoReboot = true;
            };
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
