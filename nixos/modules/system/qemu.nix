{
  flake.nixosModules.qemu = {
    programs.virt-manager.enable = true;

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    services = {
      spice-autorandr.enable = true;
      spice-vdagentd.enable = true;
      qemuGuest.enable = true;
    };

    networking.firewall.trustedInterfaces = [ "virbr0" ];
  };
}
