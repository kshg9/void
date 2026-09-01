{
  flake.hjemModules.gtk =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        adwaita-icon-theme
      ];

      files = {
        ".icons/default/index.theme".text = ''
          [Icon Theme]
          Inherits=Bibata-Modern-Ice
        '';
        ".local/share/icons/default/index.theme".text = ''
          [Icon Theme]
          Inherits=Bibata-Modern-Ice
        '';
      };
    };
}
