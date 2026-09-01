# Toggle for all heavy modules.
{ lib, self, ... }: {
  flake.nixosModules.extras =
    { ... }:
    {
      options.extras = {
        nvidia.enable = lib.mkEnableOption "the NVIDIA GPU driver stack";
        vicinae.enable = lib.mkEnableOption "the vicinae CLI";
        waydroid.enable = lib.mkEnableOption "Waydroid Android container";
        emacs.enable = lib.mkEnableOption "the Emacs editor";
        kube.enable = lib.mkEnableOption "Kubernetes tooling (kubectl, k3d, helm)";
        lanzaboote.enable = lib.mkEnableOption "Secure Boot using lanzaboote";
        rust.enable = lib.mkEnableOption "Rust toolchain using fenix";
        devel.enable = lib.mkEnableOption "C/C++ dev and debugging tools";
      };

      imports = [
        self.nixosModules.nvidia
        self.nixosModules.vicinae
        self.nixosModules.waydroid
        self.nixosModules.emacs
        self.nixosModules.kube
        self.nixosModules.lanzaboote
        self.nixosModules.rust
        self.nixosModules.devel
      ];
    };
}
