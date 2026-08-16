{
  flake.nixosModules.chrome =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      config = lib.mkIf config.extras.chrome.enable {
        environment.systemPackages = [ pkgs.google-chrome ];

        programs.chromium = {
          enable = true;
          extensions = [
            "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
          ];
          extraOpts = {
            "BrowserSignin" = 0;
            "SyncDisabled" = true;
            "PasswordManagerEnabled" = false;
          };
        };

      };
    };
}
