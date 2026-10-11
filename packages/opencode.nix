{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.opencode = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode2;
        binName = "opencode";
        exePath = "bin/opencode2";
        filesToExclude = [ "bin/opencode2" ];
      };
    };
}
