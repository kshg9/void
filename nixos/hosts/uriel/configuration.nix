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

        # Per-user Hjem profile.
        self.nixosModules.userKdj
        self.nixosModules.userYjh

        inputs.disko.nixosModules.disko
        self.diskoConfigurations.uriel
      ];

      extras = {
        waydroid.enable = false;
        lanzaboote.enable = true;
      };

      desktop.configNiri.enable = true;

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

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
