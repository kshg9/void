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

      environment.systemPackages = with pkgs; [
        xwayland-satellite
        swayidle
      ];

      services.swayidle = {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = "${pkgs.niri}/bin/niri msg action power-off-monitors";
            resumeCommand = "${pkgs.niri}/bin/niri msg action power-on-monitors";
          }
          {
            timeout = 900;
            command = "systemctl suspend-then-hibernate";
          }
        ];
        events = {
          "before-sleep" = "${pkgs.niri}/bin/niri msg action power-off-monitors";
          "after-resume" = "${pkgs.niri}/bin/niri msg action power-on-monitors";
        };
      };
    };
}
