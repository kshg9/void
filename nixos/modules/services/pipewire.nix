{
  flake.nixosModules.pipewire =
    { pkgs, ... }:
    {
      services.pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        pulse.enable = true;
      };

      environment.systemPackages = [ pkgs.pipewire.jack ];
    };
}
