{
  perSystem =
    { pkgs, ... }:
    {
      packages.unisw = pkgs.writers.writePython3Bin "unisw" { } (
        builtins.readFile ../scripts/unisw
      );
    };
}
