{
  flake.nixosModules.tailscale = { config, ... }: {
    system.serviceRegistry.tailscale = {
      unit = "tailscaled";
      # The packaged unit is not part of config.systemd.services discovery.
      state.directories = [ "tailscale" ];
    };

    networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

    services.tailscale = {
      enable = true;
      openFirewall = true;
      extraSetFlags = [ "--operator=kdj" ];
    };
  };
}
