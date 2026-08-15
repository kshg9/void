{
  self,
  config,
  ...
}:
{
  flake.nixosConfigurations.sandbox = config.flake.lib.mkHost {
    module = self.nixosModules.hostSandbox;
  };

  flake.nixosModules.hostSandbox =
    {
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        self.nixosModules.base
        self.nixosModules.nixpkgsConfig
        self.nixosModules.general

        self.nixosModules.nixTools
        self.nixosModules.keyd
        self.nixosModules.cachix
        self.nixosModules.extras

        self.nixosModules.userBiyoo

        (modulesPath + "/virtualisation/qemu-vm.nix")
      ];

      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.wayland.enable = true;
      programs.labwc.enable = true;
      fonts.packages = with pkgs; [
        ubuntu-sans
        nerd-fonts.commit-mono
      ];

      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      boot.kernelPackages = pkgs.linuxPackages_latest;

      networking.hostName = "sandbox";
      networking.networkmanager.enable = true;

      system.stateVersion = "26.05";

      virtualisation.memorySize = 4096;
      virtualisation.diskSize = 40960;
      virtualisation.qemu.options = [
        "-device virtio-vga-gl"
        "-display gtk,gl=on,grab-on-hover=on"
      ];

      virtualisation.sharedDirectories = {
        host-share = {
          source = "/home/kdj/Downloads";
          target = "/mnt/host";
        };
      };
    };
}
