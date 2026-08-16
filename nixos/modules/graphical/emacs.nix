{
  flake.nixosModules.emacs =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    lib.mkIf config.extras.emacs.enable {
      services.emacs = {
        enable = true;
        package = pkgs.emacs-pgtk;
        defaultEditor = false;
      };
    };
}
