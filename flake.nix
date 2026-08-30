{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    flake-parts.url = "github:hercules-ci/flake-parts";
    impermanence.url = "github:nix-community/impermanence";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem-impure = {
      url = "github:Rexcrazy804/hjem-impure";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vicinae.url = "github:vicinaehq/vicinae";
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixjail = {
      url = "github:kshg9/nixjail";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jail-nix = {
      url = "sourcehut:~alexdavid/jail.nix";
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      inherit (lib.fileset) toList fileFilter;

      isNixModule = file: file.hasExt "nix" && file.name != "flake.nix" && !lib.hasPrefix "_" file.name;

      importTree = path: toList (fileFilter isNixModule path);

      mkFlake = inputs.flake-parts.lib.mkFlake { inherit inputs; };
    in
    mkFlake {
      imports =
        importTree ./nixos/hosts
        ++ importTree ./nixos/modules
        ++ importTree ./packages
        ++ [ inputs.disko.flakeModules.default ];

      systems = [ "x86_64-linux" ];
    };
}
