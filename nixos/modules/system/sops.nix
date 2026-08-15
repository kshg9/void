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
        keyFile = "/var/lib/sops-nix/key.txt";
        generateKey = true;
      };

      environment.systemPackages = with pkgs; [
        sops
        age
      ];
    };
}
