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
        self.nixosModules.isolate-agents
        self.nixosModules.isolate-pi
        self.nixosModules.isolate-dsh
      ];

      users.users.${user} = {
        hashedPasswordFile = "/persist/passwords/${user}";
        extraGroups = [
          "wheel"
          "networkmanager"
          "libvirtd"
          "lp"
          "lpadmin"
          "docker"
        ];
      };

      hjem.users.${user} = {
        imports = [
          self.hjemModules.gtk
        ];

        packages = with pkgs; [
          #obsidian
          #anki-bin
          qbittorrent
          vesktop
          rclone
          gh
          tealdeer

          # dev
          tmux
          zk
          jujutsu

          # CLI tools & utils
          lsof
          rustscan
          socat
          treefmt

          # Apps
          sioyek
          mpv
          google-chrome
        ];
      };
    };
}
