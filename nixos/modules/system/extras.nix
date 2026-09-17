# Toggle for all heavy modules.
{ lib, self, ... }: {
  flake.nixosModules.extras =
    { ... }:
    {
      options.extras = {
        nvidia.enable = lib.mkEnableOption "the NVIDIA GPU driver stack";
        emacs.enable = lib.mkEnableOption "the Emacs editor";
        lanzaboote.enable = lib.mkEnableOption "Secure Boot using lanzaboote";
        devel.enable = lib.mkEnableOption "C/C++ dev and debugging tools";
        container.enable = lib.mkEnableOption "containerization options";
        android.enable = lib.mkEnableOption "Android & Java development tools";
      };

      imports = [
        self.nixosModules.nvidia
        self.nixosModules.emacs
        self.nixosModules.lanzaboote
        self.nixosModules.devel
        self.nixosModules.container
        self.nixosModules.android
      ];
    };
}
