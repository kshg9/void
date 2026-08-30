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

      hjem.users.${user} = {
        imports = [
          self.hjemModules.gtk
        ];

        packages = with pkgs; [
          #obsidian
          #anki-bin
          qbittorrent
          rclone
          gh
          tealdeer

          # dev
          tmux
          zk
          zeal
          jujutsu

          # CLI tools & utils
          lsof
          rustscan
          socat
          treefmt

          # Apps
          sioyek
          mpv
          thunderbird-bin
          librewolf-bin
          cudatext
        ];
      };
    };
}
