{
  flake.nixosModules.tailscale = { config, ... }: {
    persistence.directories = [
      "/var/lib/tailscale"
    ];

    networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

    services.tailscale = {
      enable = true;
      openFirewall = true;
      extraSetFlags = [ "--operator=kdj" ];
    };
  };
}
