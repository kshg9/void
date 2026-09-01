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

        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              user = "greeter";
              command = "${pkgs.tuigreet}/bin/tuigreet --config ${../user/dots/tuigreet/config.toml}";
            };
          };
        };

        security.pam.services.greetd.enableGnomeKeyring = true;

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
