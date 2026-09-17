{
  # Import this module only on machines running as QEMU/SPICE guests.
  flake.nixosModules.qemuGuest =
    { config, lib, ... }:
    {
      services = {
        qemuGuest.enable = lib.mkDefault true;
        spice-vdagentd.enable = lib.mkDefault true;
        spice-autorandr.enable = lib.mkDefault config.services.xserver.enable;
      };
    };
}
