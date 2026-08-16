# Toggle for all heavy modules.
{ lib, self, ... }: {
  flake.nixosModules.extras =
    { ... }:
    {
      options.extras = {
        nvidia.enable = lib.mkEnableOption "the NVIDIA GPU driver stack";
        vicinae.enable = lib.mkEnableOption "the vicinae CLI";
        waydroid.enable = lib.mkEnableOption "Waydroid Android container";
        chrome.enable = lib.mkEnableOption "Google Chrome / Chromium browsers";
        emacs.enable = lib.mkEnableOption "the Emacs editor";
        kube.enable = lib.mkEnableOption "Kubernetes tooling (kubectl, k3d, helm)";
        lanzaboote.enable = lib.mkEnableOption "Secure Boot using lanzaboote";
      };

      imports = [
        self.nixosModules.nvidia
        self.nixosModules.vicinae
        self.nixosModules.waydroid
        self.nixosModules.chrome
        self.nixosModules.emacs
        self.nixosModules.kube
        self.nixosModules.lanzaboote
      ];
    };
}
