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
        self.nixosModules.docker
        self.nixosModules.qemu
        self.nixosModules.firefox

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
        chrome.enable = true;
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

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      # Memory optimizations (tmpfs and zram)
      boot.tmp.useTmpfs = true;
      zramSwap.enable = true;
      boot.kernel.sysctl."vm.swappiness" = 100;

      networking.hostName = "uriel";
      networking.networkmanager.enable = true;

      sops.defaultSopsFile = ./../../../secrets/uriel.yaml;
      sops.secrets.github_ssh_private_key = {
        path = "/home/kdj/.ssh/id_ed25519_gh";
        owner = "kdj";
        group = "users";
        mode = "0600";
      };
      sops.secrets.github_ssh_pubkey = {
        path = "/home/kdj/.ssh/id_ed25519_gh.pub";
        owner = "kdj";
        group = "users";
        mode = "0444";
      };
      sops.secrets.vcs_ssh_private_key = {
        path = "/home/kdj/.ssh/id_ed25519_vcs";
        owner = "kdj";
        group = "users";
        mode = "0600";
      };
      sops.secrets.vcs_ssh_pubkey = {
        path = "/home/kdj/.ssh/id_ed25519_vcs.pub";
        owner = "kdj";
        group = "users";
        mode = "0444";
      };

      system.stateVersion = "26.05";
    };
}
