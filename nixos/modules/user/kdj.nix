{
  inputs,
  self,
  ...
}:
{
  flake.nixosModules.userKdj =
    { pkgs, config, ... }:
    let
      user = "kdj";
      inherit (self.packages.${pkgs.stdenv.hostPlatform.system})
        opencode
        unisw;
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [
        (self.userBase user)
      ];

      users.users.${user} = {
        hashedPasswordFile = "/persist/passwords/${user}";
        extraGroups = [
          "wheel"
          "networkmanager"
          "libvirtd"
          "kvm"
          "lp"
          "lpadmin"
        ];
      };

      sops.secrets.wallhaven_api = { };
      sops.templates."wallhaven.toml" = {
        owner = user;
        content = ''
          [plugin_settings."noctalia/wallhaven"]
          api_key = "${config.sops.placeholder.wallhaven_api}"
        '';
      };

      hjem.users.${user} = {
        imports = [
          self.hjemModules.gtk
          self.hjemModules.isolate-apps
          self.hjemModules.isolate-agents
        ];

        programs.noctalia.settings.include.files = [
          config.sops.templates."wallhaven.toml".path
        ];

        packages = with pkgs; [
          # AI agents
          llmPkgs.pi
          llmPkgs.dsh
          opencode
          unisw

          bubblewrap
          nodejs
          pnpm
          python3

          yt-dlp
          qbittorrent
          rclone
          gh

          # dev
          uv
          tmux
          zk
          zeal
          jujutsu
          neovim
          vscodium-fhs

          # CLI tools & utils
          socat
          treefmt
          shfmt

          # Apps
          sioyek
          thunderbird-bin
          librewolf-bin
          libreoffice
        ];
      };
    };
}
