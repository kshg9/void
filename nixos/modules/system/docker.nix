{
  flake.nixosModules.docker = { pkgs, ... }: {
    virtualisation.docker.enable = true;
    persistence.directories = [
      "/var/lib/docker"
    ];
    environment.systemPackages = with pkgs; [
      docker-compose
    ];
  };
}
