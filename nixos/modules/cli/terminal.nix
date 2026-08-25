{
  flake.hjemModules.terminal =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        playerctl
        brightnessctl
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
        libqalculate
        starship
        wlsunset
        nautilus

        file
        ffmpeg
        _7zz
        jq
        poppler-utils
        imagemagick
      ];

      xdg.config.files = {
        "yazi/plugins/full-border.yazi".source = "${pkgs.yaziPlugins.full-border}";
        "yazi/plugins/git.yazi".source = "${pkgs.yaziPlugins.git}";
      };
    };
}
