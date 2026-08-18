{
  inputs,
  self,
  config,
  ...
}:

{
  flake.nixosConfigurations.installer = config.flake.lib.mkHost {
    module = self.nixosModules.hostInstaller;
  };

  flake.nixosModules.hostInstaller =
    {
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    let
      maximizer = inputs.maximizer.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      imports = [
        self.nixosModules.nixpkgsConfig
        self.nixosModules.cachix

        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
      ];

      # Minimal installer interface Kitty + X11
      services.xserver.displayManager.lightdm.enable = true;
      services.displayManager.autoLogin = {
        enable = true;
        user = "nixos";
      };
      services.displayManager.defaultSession = "kitty-installer";
      services.xserver.desktopManager.session = [
        {
          name = "kitty-installer";
          start =
            let
              kittyPayload = pkgs.writeShellScript "kitty-installer-payload" ''
                # Launch the maximizer in the background to resize our window
                ${maximizer}/bin/maximize_program kitty-installer > /dev/null 2>&1 &

                # Exec replaces the current shell with tmux
                exec ${pkgs.tmux}/bin/tmux new -A -s install
              '';
            in
            ''
              ${pkgs.kitty}/bin/kitty --title kitty-installer -e ${kittyPayload} &
              waitPID=$!
            '';
        }
      ];

      # Builds flakes-installer.iso
      image.baseName = lib.mkForce "flakes-installer";

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        show-trace = true;
        fallback = false;
      };

      environment.systemPackages = [
        inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
        pkgs.kitty
        pkgs.tmux
        pkgs.neovim
        pkgs.changepass
      ];

      # One-shot installer. Usage: urielOS [target] [user]
      environment.shellAliases = {
        urielOS = "${pkgs.writeShellScript "urielOS" ''
          set -e
          target=''${1:-uriel}
          username=''${2:-kdj}

          sudo disko --mode destroy,format,mount --flake "github:kshg9/void#$target"

          sudo mkdir -p /mnt/persist/system/etc/nixos
          sudo git clone https://github.com/kshg9/void /mnt/persist/system/etc/nixos/void

          sudo nixos-install --no-root-passwd --flake /mnt/persist/system/etc/nixos/void#"$target"

          sudo nixos-enter --root /mnt -c "changepass $username"
        ''}";
      };
    };
}
