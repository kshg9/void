{
  inputs,
  ...
}:
{
  flake.nixosModules.general =
    { pkgs, ... }:
    {
      imports = [
        inputs.hjem.nixosModules.default
      ];

      hjem.extraModules = [
        inputs.hjem-impure.hjemModules.default
        inputs.noctalia.hjemModules.default
      ];

      environment.systemPackages = with pkgs; [
        changepass
        btop
        binutils

        nixd
        statix
        nixfmt
        nix-diff
        hydra-check

        pciutils
        psmisc

        neovim
        helix
        junction
      ];

      environment.variables = {
        EDITOR = "hx";
        BROWSER = "xdg-open";
      };

      time.timeZone = "Asia/Kolkata";

      services.fwupd.enable = true;

      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_IN";
        LC_IDENTIFICATION = "en_IN";
        LC_MEASUREMENT = "en_IN";
        LC_MONETARY = "en_IN";
        LC_NAME = "en_IN";
        LC_NUMERIC = "en_IN";
        LC_PAPER = "en_IN";
        LC_TELEPHONE = "en_IN";
        LC_TIME = "en_IN";
      };

      programs.fish.enable = true;

      services.upower.enable = true;
      security.polkit.enable = true;

      services.tlp = {
        enable = true;
        settings = {
          # 1 -> caps at 60%, 0 -> 100%
          START_CHARGE_THRESH_BAT0 = "0";
          STOP_CHARGE_THRESH_BAT0 = "1";
        };
      };

      hardware = {
        enableAllFirmware = true;
        bluetooth.enable = true;
        bluetooth.powerOnBoot = false;
      };
    };
}
