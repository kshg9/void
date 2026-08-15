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

    # Persist systemd backlight state across reboots so brightness set in Noctalia/brightnessctl is restored
    persistence.directories = [
      "/var/lib/systemd/backlight"
      "/var/lib/sops-nix"
    ];

    # Only this user's $HOME persists
    persistence.user = "kdj";
  };
}
