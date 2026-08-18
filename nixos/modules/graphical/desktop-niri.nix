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

      sops.secrets.wallhaven_api = { };

      sops.templates."wallhaven.toml".owner = "kdj";

      sops.templates."wallhaven.toml".content = ''
        [plugin_settings."noctalia/wallhaven"]
        api_key = "${config.sops.placeholder.wallhaven_api}"
      '';

      hjem.extraModules = [
        (
          hjemArgs@{ ... }:
          let
            hjemConfig = hjemArgs.config;
            hjemLib = hjemArgs.lib;
            assets = ../../../assets;
            avatar =
              let
                jpg = assets + "/${hjemConfig.user}.jpg";
                png = assets + "/${hjemConfig.user}.png";
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
                include.files = [ config.sops.templates."wallhaven.toml".path ];
                shell = {
                  font_family = "Atkinson Hyperlegible Next";
                  settings_show_advanced = true;
                  avatar_path = hjemLib.mkIf (avatar != null) avatar;
                };
                theme = {
                  mode = "dark";
                  source = "wallpaper";
                };
                plugins = {
                  enabled = [ "noctalia/wallhaven" ];
                };
                plugin_settings."noctalia/wallhaven" = {
                  download_dir = "~/Pictures/Wallhaven";
                };
                wallpaper = {
                  directory = "~/Pictures/Wallhaven";
                };
                accessibility = {
                  ui_scale = 1.12;
                };
                bar = {
                  default = {
                    scale = 1.12;
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
                    format = "{:%-I:%M %p}";
                    font_weight = 700;
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
