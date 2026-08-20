{ self, ... }: {
  flake.nixosModules.desktop =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        self.nixosModules.pipewire
        self.nixosModules.noctalia
        self.nixosModules.desktop-niri
      ];

      options.desktop = {
        configNiri.enable = lib.mkEnableOption "the Niri config (niri + noctalia bar + dotfiles)";
        # configRiver.enable = lib.mkEnableOption # TODO Reka (Emacs + Wayland)
      };

      config = {
        services.xserver.enable = true;

        # Minimal default SDDM configuration with Bibata cursor
        # https://discourse.nixos.org/t/sddm-ignoring-cursor-theming/71645
        services.displayManager.sddm = {
          enable = true;
          package = pkgs.kdePackages.sddm;
          extraPackages = [ pkgs.bibata-cursors ];
          setupScript =
            let
              xresources = pkgs.writeText "xresources" ''
                Xcursor.theme: ${config.environment.variables.XCURSOR_THEME}
                Xcursor.size: ${config.environment.variables.XCURSOR_SIZE}
              '';
            in
            ''
              ${pkgs.xrdb}/bin/xrdb -merge ${xresources}
            '';
          settings = {
            General = {
              InputMethod = "";
            };
            Theme = {
              CursorTheme = "Bibata-Modern-Ice";
              CursorSize = 28;
              FacesDir = "/etc/sddm/faces";
            };
          };
        };

        security.pam.services.sddm.enableGnomeKeyring = true;

        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };

        programs.dconf = {
          enable = true;
          profiles.user.databases = [
            {
              settings = {
                "org/gnome/desktop/interface" = {
                  color-scheme = "prefer-dark";
                };
              };
            }
          ];
        };

        environment.variables = {
          XCURSOR_THEME = "Bibata-Modern-Ice";
          XCURSOR_SIZE = "28";
          NIXOS_OZONE_WL = "1";
        };

        environment.systemPackages = [
          pkgs.bibata-cursors
        ];

        fonts.packages = with pkgs; [
          nerd-fonts.commit-mono
          ubuntu-sans
          atkinson-hyperlegible-next
        ];

        fonts.fontconfig.defaultFonts = {
          serif = [ "Ubuntu Sans" ];
          sansSerif = [ "Ubuntu Sans" ];
          monospace = [ "CommitMono Nerd Font Mono" ];
        };
      };
    };
}
