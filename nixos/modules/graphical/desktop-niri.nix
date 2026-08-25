{
  flake.nixosModules.desktop-niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf config.desktop.configNiri.enable {
      programs.niri.enable = true;
      environment.systemPackages = [ pkgs.xwayland-satellite ];
    };
}
