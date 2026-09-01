{
  flake.hjemModules.sharedApps =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        # Shared DE Utilities
        playerctl
        brightnessctl
        wlsunset
        wl-clipboard

        # GUI Apps
        kitty
        nautilus
      ];
    };
}
