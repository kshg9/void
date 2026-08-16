{
  flake.nixosModules.desktop-niri =
    {
      config,
      lib,
      ...
    }:
    lib.mkIf config.desktop.configNiri.enable {
      programs.niri.enable = true;

      hjem.extraModules = [
        (
          { config, lib, ... }:
          let
            assets = ../../../assets;
            avatar =
              let
                jpg = assets + "/${config.user}.jpg";
                png = assets + "/${config.user}.png";
              in
              if builtins.pathExists jpg then
                jpg
              else if builtins.pathExists png then
                png
              else
                null;
          in
          {
            # noctalia config
            programs.noctalia = {
              enable = true;
              settings = {
                shell = {
                  font_family = "Atkinson Hyperlegible Next";
                  settings_show_advanced = true;
                  avatar_path = lib.mkIf (avatar != null) avatar;
                };
                theme = {
                  mode = "dark";
                  source = "builtin";
                  builtin = "Catppuccin";
                };
                accessibility = {
                  ui_scale = 1.1;
                };
                bar = {
                  default = {
                    scale = 1.1;
                    position = "top";
                    thickness = 36;
                    margin_ends = 0;
                    margin_edge = 0;
                    background_opacity = 0.55;
                    radius = 0;
                    concave_edge_corners = false;
                    widget_spacing = 6;
                    capsule = true;
                    capsule_fill = "surface_variant";
                    capsule_radius = 8;
                    capsule_opacity = 0.9;
                    capsule_padding = 6;
                    start = [
                      "launcher"
                      "workspaces"
                    ];
                    center = [ "clock" ];
                    end = [
                      "tray"
                      "network"
                      "volume"
                      "battery"
                      "session"
                    ];
                  };
                };
                widget = {
                  clock = {
                    font_weight = 700;
                    format = "{:%-I:%M %p}";
                  };
                };
                backdrop = {
                  enabled = true;
                  blur_intensity = 0.5;
                  tint_intensity = 0.3;
                };
              };
            };
          }
        )
      ];
    };
}
