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
    {
      imports = [
        self.nixosModules.nixpkgsConfig
        self.nixosModules.cachix
        self.nixosModules.nixTools

        "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
      ];

      # Auto-start tmux on the primary TTY (tty1) when the LiveCD boots
      programs.bash.loginShellInit = ''
        if [ "$(tty)" = "/dev/tty1" ]; then
          exec tmux new-session -A -s install
        fi
      '';

      # Builds flakes-installer.iso
      image.baseName = lib.mkForce "flakes-installer";

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

      environment.systemPackages = [
        inputs.disko.packages.${pkgs.stdenv.hostPlatform.system}.disko
        pkgs.helix
        pkgs.tmux
        pkgs.neovim
        pkgs.changepass

        # One-shot installer script natively wrapped
        (pkgs.writeShellScriptBin "urielOS" ''
          set -euo pipefail
          target=''${1:-uriel}
          username=''${2:-kdj}

          sudo disko --mode destroy,format,mount --flake "github:kshg9/void#$target"

          sudo mkdir -p /mnt/persist/system/etc/nixos
          sudo git clone https://github.com/kshg9/void /mnt/persist/system/etc/nixos/void

          sudo nixos-install --no-root-passwd --flake /mnt/persist/system/etc/nixos/void#"$target"

          sudo nixos-enter --root /mnt -c "changepass $username"
        '')
      ];
    };
}
