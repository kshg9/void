# Toggle for all heavy modules.
{ lib, self, ... }: {
  flake.nixosModules.extras =
    { ... }:
    {
      options.extras = {
        nvidia.enable = lib.mkEnableOption "the NVIDIA GPU driver stack";
        vicinae.enable = lib.mkEnableOption "the vicinae CLI";
        emacs.enable = lib.mkEnableOption "the Emacs editor";
        lanzaboote.enable = lib.mkEnableOption "Secure Boot using lanzaboote";
        rust.enable = lib.mkEnableOption "Rust toolchain using fenix";
        devel.enable = lib.mkEnableOption "C/C++ dev and debugging tools";
      };

      imports = [
        self.nixosModules.nvidia
        self.nixosModules.vicinae
        self.nixosModules.emacs
        self.nixosModules.lanzaboote
        self.nixosModules.rust
        self.nixosModules.devel
      ];
    };
}
