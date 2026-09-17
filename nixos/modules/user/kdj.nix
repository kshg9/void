{
  self,
  ...
}:
{
  flake.nixosModules.userKdj =
    { pkgs, config, ... }:
    let
      user = "kdj";
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
          self.hjemModules.isolate-agy
          self.hjemModules.isolate-cursor
          self.hjemModules.isolate-opencode
        ];

        programs.noctalia.settings.include.files = [
          config.sops.templates."wallhaven.toml".path
        ];

        packages = with pkgs; [
          #anki-bin
          yt-dlp
          qbittorrent
          rclone
          gh

          # dev
          tmux
          zk
          zeal
          jujutsu
          helix
          vscodium-fhs

          # CLI tools & utils
          socat
          treefmt
          shfmt

          # Apps
          sioyek
          thunderbird-bin
          librewolf-bin

          # Misc
          rustscan
        ];
      };
    };
}
