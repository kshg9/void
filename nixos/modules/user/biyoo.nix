# Sandbox VM setup to experiment on apps.
{
  self,
  ...
}:
{
  flake.nixosModules.userBiyoo =
    {
      pkgs,
      ...
    }:
    let
      user = "biyoo";
    in
    {
      imports = [ (self.userBase user) ];

      # Password: `vm`.
      users.users.${user} = {
        initialHashedPassword =
          "$6$LDUu.Y9KJo7bM5by$0MQdp3lNXE4qSUtuordK2EnS8PdY2e3XBZ3AgnQG9k8.Q7ySnwgNxZGq5UqNxXXxieyFXJZapvv34cKNNeNGg/";
        extraGroups = [ "wheel" ];
      };

      hjem.users.${user}.packages = [
        pkgs.yazi
      ];
    };
}
