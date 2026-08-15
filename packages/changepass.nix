{
  perSystem =
    { pkgs, ... }:
    {
      # Impermanence friendly passwd alternative
      packages.changepass = pkgs.writeShellApplication {
        name = "changepass";
        runtimeInputs = [
          pkgs.shadow
          pkgs.whois
        ];

        text = builtins.readFile ./changepass.sh;
      };
    };
}
