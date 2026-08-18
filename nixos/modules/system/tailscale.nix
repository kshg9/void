{
  flake.nixosModules.tailscale =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.tailscale ];

      persistence.directories = [
        "/var/lib/tailscale"
      ];

      services.tailscale = {
        enable = true;
        openFirewall = true; # Automatically manages ports and trusted interfaces natively
        extraSetFlags = [ "--operator=kdj" ];
      };
    };
}
