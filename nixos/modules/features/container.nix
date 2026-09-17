{
  flake.nixosModules.container =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {

      config = lib.mkIf config.extras.container.enable {
        virtualisation = {
          podman.enable = true;
        };
        environment.systemPackages = with pkgs; [ distrobox ];
      };
    };
}
