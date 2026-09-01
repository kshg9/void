{
  flake.nixosModules.kube =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.extras.kube.enable {
        environment.systemPackages = with pkgs; [
          kubectl
          k3d
          kubernetes-helm
          podman-compose
        ];

        services.k3s = {
          enable = true;
          role = "server";
        };

        networking.firewall.trustedInterfaces = [
          "cni0"
          "flannel.1"
        ];

        virtualisation.podman = {
          enable = true;
          dockerCompat = true;
        };

        persistence.directories = [
          "/var/lib/rancher/k3s"
          "/var/lib/containers"
        ];
      };
    };
}
