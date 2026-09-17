{
  flake.nixosModules.android =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {

      config = lib.mkIf config.extras.android.enable {
        nixpkgs.config.android_sdk.accept_license = true;

        environment.systemPackages = with pkgs; [
          android-studio
          android-tools
          jetbrains.idea
        ];
      };
    };
}
