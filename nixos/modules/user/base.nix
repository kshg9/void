{ self, ... }:
{
  flake.userBase =
    name:
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      users.mutableUsers = false;

      users.users.${name} = {
        isNormalUser = true;
        description = "${name}'s account";
        extraGroups = [ ];
        shell = pkgs.fish;
      };

      environment.etc =
        let
          jpg = ../../../assets + "/${name}.jpg";
          png = ../../../assets + "/${name}.png";
          userIcon =
            if builtins.pathExists jpg then
              jpg
            else if builtins.pathExists png then
              png
            else
              null;
        in
        lib.mkIf (userIcon != null) {
          "sddm/faces/${name}.face.icon".source = userIcon;
        };

      hjem = {
        clobberByDefault = true;

        users.${name} = {
          imports = [
            self.hjemModules.baseUser
            self.hjemModules.sharedApps
          ];

          enable = true;
          user = name;
          directory = "/home/${name}";

          files = self.lib.mkDots { dir = ./home; };

          xdg.config.files = self.lib.mkDots { dir = ./dots; };

          impure = {
            enable = true;
            dotsDir = "${./dots}";
            dotsDirImpure = "/etc/nixos/void/nixos/modules/user/dots";
            parseAttrs = [
              config.hjem.users.${name}.files
              config.hjem.users.${name}.xdg.config.files
            ];
          };
        };
      };
    };
}
