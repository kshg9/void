{
  flake.nixosModules.qemu = {
    programs.virt-manager.enable = true;

    # systemd-creds uses this host key to decrypt libvirt's persisted credential.
    persistence.files = [ "/var/lib/systemd/credential.secret" ];

    # Initialize credentials only after persistent state is mounted and prepared.
    systemd.services.virt-secret-init-encryption = {
      requires = [ "libvirtd-config.service" ];
      after = [ "libvirtd-config.service" ];
      unitConfig.RequiresMountsFor = [ "/var/lib/libvirt" ];
    };

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true;
    };

    networking.firewall.trustedInterfaces = [ "virbr0" ];
  };
}
