{
  inputs,
  self,
  config,
  ...
}:
{
  flake.nixosConfigurations.uriel = config.flake.lib.mkHost {
    module = self.nixosModules.hostUriel;
  };

  flake.nixosModules.hostUriel =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.nixpkgsConfig
        self.nixosModules.general
        self.nixosModules.desktop
        self.nixosModules.nixTools
        self.nixosModules.impermanence
        self.nixosModules.keyd
        self.nixosModules.printer
        self.nixosModules.cachix
        self.nixosModules.sops
        self.nixosModules.extras
        self.nixosModules.tailscale
        self.nixosModules.qemu
        self.nixosModules.firefox
        self.nixosModules.xdg

        # Per-user Hjem profile.
        self.nixosModules.userKdj
        self.nixosModules.userYjh

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.uriel

        inputs.nixos-hardware.nixosModules.lenovo-ideapad-15ach6
      ];

      extras = {
        lanzaboote.enable = true;
        vicinae.enable = true;
        nvidia.enable = true;
        emacs.enable = true;
      };

      desktop.configNiri.enable = true;
      services.fstrim.enable = true;

      services.logind.settings = {
        Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchExternalPower = "suspend";
          HandlePowerKey = "suspend";
        };
      };

      systemd.sleep.settings = {
        Sleep = {
          HibernateDelaySec = "1h";
        };
      };

      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Memory optimizations (tmpfs and zram)
      boot.tmp.useTmpfs = true;
      zramSwap.enable = true;
      boot.kernel.sysctl."vm.swappiness" = 100;

      networking.hostName = "uriel";
      networking.networkmanager.enable = true;

      sops.defaultSopsFile = ./../../../secrets/uriel.yaml;
      sops.secrets.github_ssh_private_key.owner = "kdj";
      sops.secrets.github_ssh_pubkey.owner = "kdj";
      sops.secrets.vcs_ssh_private_key.owner = "kdj";
      sops.secrets.vcs_ssh_pubkey.owner = "kdj";

      system.stateVersion = "26.05";
    };
}
