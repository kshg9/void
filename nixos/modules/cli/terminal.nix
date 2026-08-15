{
  flake.hjemModules.terminal =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        playerctl
        brightnessctl
        bibata-cursors
        kitty
        yazi
        git
        difftastic
        eza
        fd
        bat
        magika-cli
        ripgrep
        fzf
        htop
        zoxide
        just
        wl-clipboard
        helix
        libqalculate
        starship
        wlsunset
        nautilus
      ];

      xdg.config.files = {
        "yazi/plugins/full-border.yazi".source = "${pkgs.yaziPlugins.full-border}";
      };
    };
}
