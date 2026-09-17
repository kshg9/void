{ self, ... }:
{
  flake.nixosModules.base = {
    imports = [
      self.nixosModules.persistenceOptions
      self.nixosModules.serviceRegistry
    ];
  };
}
