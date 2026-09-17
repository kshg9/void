{
  self,
  ...
}:
{
  flake.nixosModules.impermanence = { ... }: {
    imports = [
      self.nixosModules.impermanenceImpl
    ];

    persistence = {
      enable = true;
      nukeRoot.enable = true;
      # Persist systemd backlight state so brightness is restored.
      directories = [ "/var/lib/systemd/backlight" ];
    };
  };
}
