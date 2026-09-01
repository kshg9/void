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
        self.nixosModules.isolate-agents
        self.nixosModules.isolate-agy
        self.nixosModules.isolate-pi
        self.nixosModules.isolate-dsh
        self.nixosModules.isolate-apps
      ];

      users.users.${user} = {
        hashedPasswordFile = "/persist/passwords/${user}";
        extraGroups = [
          "wheel"
          "networkmanager"
          "libvirtd"
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
        ];

        programs.noctalia.settings.include.files = [
          config.sops.templates."wallhaven.toml".path
        ];

        packages = with pkgs; [
          #obsidian
          #anki-bin
          qbittorrent
          rclone
          gh

          # dev
          tmux
          zk
          zeal
          jujutsu

          # CLI tools & utils
          socat
          treefmt

          # Apps
          sioyek
          mpv
          thunderbird-bin
          librewolf-bin
          gnome-text-editor

          # Recon
          rustscan
        ];
      };
    };
}
