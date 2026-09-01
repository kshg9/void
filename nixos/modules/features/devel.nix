{
  flake.nixosModules.devel =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.extras.devel.enable {
        environment.systemPackages = with pkgs; [
          strace
          ltrace
          bpftrace
          perf

          patchelf
          imhex

          man-pages
          man-pages-posix
        ];

        documentation = {
          dev.enable = true;
          man.cache.enable = true;
        };
      };
    };
}
