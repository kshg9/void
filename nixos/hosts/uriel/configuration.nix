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
        self.nixosModules.neovim
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
        self.nixosModules.xdg

        # Per-user Hjem profile.
        self.nixosModules.userKdj
        self.nixosModules.userYjh

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.uriel

        inputs.nixos-hardware.nixosModules.lenovo-ideapad-15ach6
      ];

      extras = {
        devel.enable = true;
        emacs.enable = true;
        lanzaboote.enable = true;
        nvidia.enable = true;
        vicinae.enable = true;
        android.enable = true;
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
          HibernateDelaySec = "15m";
        };
      };

      boot.loader.systemd-boot.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Memory optimizations
      boot.tmp.useTmpfs = true;

      boot.kernelParams = [
        "zswap.enabled=1"
        "zswap.compressor=zstd"
        "zswap.zpool=zsmalloc"
        "zswap.max_pool_percent=20"
      ];

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
