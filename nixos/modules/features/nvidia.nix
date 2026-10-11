{
  flake.nixosModules.nvidia =
    {
      config,
      lib,
      ...
    }:
    lib.mkIf config.extras.nvidia.enable {
      services.xserver.videoDrivers = [ "nvidia" ];

      nixpkgs.config.cudaSupport = true;

      hardware.nvidia = {
        open = false;
        modesetting.enable = true;

        prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          nvidiaBusId = lib.mkForce "PCI:1:0:0";
          amdgpuBusId = lib.mkForce "PCI:5:0:0";
        };

        powerManagement = {
          enable = true;
          finegrained = true;
        };

        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      # NixOS wires the NVIDIA units to suspend and hibernate separately.
      # The combined operation also needs them, plus NVIDIA's transition hook.
      systemd.services.nvidia-suspend = {
        before = [ "systemd-suspend-then-hibernate.service" ];
        requiredBy = [ "systemd-suspend-then-hibernate.service" ];
      };
      systemd.services.nvidia-resume = {
        after = [ "systemd-suspend-then-hibernate.service" ];
        requiredBy = [ "systemd-suspend-then-hibernate.service" ];
      };
      environment.etc."systemd/system-sleep/nvidia".source =
        "${config.hardware.nvidia.package}/lib/systemd/system-sleep/nvidia";

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}
