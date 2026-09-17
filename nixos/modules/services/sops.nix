{
  inputs,
  ...
}:
{
  flake.nixosModules.sops =
    { pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops.age = {
        keyFile = "/persist/system/var/lib/sops-nix/key.txt";
        generateKey = true;
      };

      system.serviceRegistry.sops = {
        unit = "sops-install-secrets";
        state.paths = [ "/var/lib/sops-nix" ];
      };

      environment.systemPackages = with pkgs; [
        sops
        age
      ];
    };
}
