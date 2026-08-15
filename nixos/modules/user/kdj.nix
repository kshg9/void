{
  self,
  ...
}:
{
  flake.nixosModules.userKdj =
    { pkgs, ... }:
    let
      user = "kdj";
    in
    {
      imports = [
        (self.userBase user)
        self.nixosModules.llm-agents
        self.nixosModules.firefox
      ];

      users.users.${user} = {
        hashedPasswordFile = "/persist/passwords/${user}";
        extraGroups = [
          "wheel"
          "networkmanager"
          "keys"
          "libvirtd"
          "lp"
          "lpadmin"
          "docker"
        ];
      };

      hjem.users.${user} = {
        imports = [
          self.hjemModules.vscodium
          self.hjemModules.gtk
        ];

        packages = with pkgs; [
          # chromium
          #obsidian
          #anki-bin
          #qbittorrent
          #vesktop
          rclone
          # (use tldeer if in unstable or use tealdeer)
          tealdeer

          # dev tools specific to this founder
          #emacs-pgtk
          helix
          tmux
          zk
          neovim
          nixd
          statix
          nixfmt
          nix-diff
          hydra-check
          treefmt
          jujutsu

          # CLI tools & utils
          pciutils
          psmisc
          socat
          sops
          lsof
          rustscan
          onefetch

          # Apps
          sioyek
          mpv
        ];
      };
    };
}
