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
        boot.loader.systemd-boot.enable = false;

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

        };

        environment.systemPackages = [
          # Debugging/verification: `sbctl status`, `sbctl verify`, manual enroll.
          pkgs.sbctl
        ];

        persistence.directories = [
          "/var/lib/sbctl"
        ];
      };
    };
}
