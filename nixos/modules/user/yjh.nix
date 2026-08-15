{
  self,
  ...
}:
{
  flake.nixosModules.userYjh =
    {
      pkgs,
      ...
    }:
    let
      user = "yjh";
    in
    {
      imports = [ (self.userBase user) ];

      users.users.${user} = {
        extraGroups = [
          "keys"
          "libvirtd"
          "lp"
          "docker"
          "lpadmin"
        ];
        hashedPasswordFile = "/persist/passwords/${user}";
      };

      hjem.users.${user}.packages = with pkgs; [
        firefox
      ];

    };
}
