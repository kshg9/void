{ inputs, ... }: {
  flake.nixosModules.nixTools = { pkgs, ... }: {
    imports = [
      inputs.nix-index-database.nixosModules.nix-index
    ];

    programs.nix-index-database.comma.enable = true;

    programs.direnv = {
      enable = true;
      silent = true;
      loadInNixShell = true;
      nix-direnv.enable = true;
    };

    nix.package = pkgs.lix;
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      allowed-users = [ "@wheel" ];
      trusted-users = [ "root" ];
      require-sigs = true;
      allow-import-from-derivation = false;
      accept-flake-config = false;
      warn-dirty = false;
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      show-trace = true;
      builders-use-substitutes = true;
    };

    nix.channel.enable = false;

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
        openssl
        stdenv.cc.cc.lib
      ];
    };

    programs.appimage = {
      enable = true;
      binfmt = true;
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep 10 --keep-since 3d";
      };
      flake = "/etc/nixos/void";
    };
  };
}
