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
          nvidiaBusId = "PCI:1:0:0";
          amdgpuBusId = "PCI:5:0:0";
        };

        powerManagement = {
          enable = true;
          finegrained = true;
        };

        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
}
