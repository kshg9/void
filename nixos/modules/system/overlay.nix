{
  self,
  ...
}:
{
  flake.overlays.default =
    final: prev:
    let
      system = prev.stdenv.hostPlatform.system;
      myPkgs = self.packages.${system} or { };
      addPkgs = removeAttrs myPkgs (builtins.attrNames prev);
    in
    addPkgs;
}
