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
      imports = [
        (self.userBase user)
      ];

      users.users.${user} = {
        extraGroups = [
          "lp"
          "lpadmin"
        ];
        hashedPasswordFile = "/persist/passwords/${user}";
      };

      hjem.users.${user} = {
        imports = [
          self.hjemModules.gtk
        ];
      };

    };
}
