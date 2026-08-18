{
  self,
  ...
}:
{
  flake.nixosModules.impermanence = { ... }: {
    imports = [
      self.nixosModules.impermanenceImpl
    ];

    persistence.enable = true;
    persistence.nukeRoot.enable = true;

    # Persist systemd backlight state across reboots so brightness is restored
    persistence.directories = [
      "/var/lib/systemd/backlight"
      "/var/lib/sops-nix"
    ];
  };
}
