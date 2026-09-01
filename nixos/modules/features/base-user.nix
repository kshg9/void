{
  flake.hjemModules.baseUser =
    { pkgs, ... }:
    {
      packages = with pkgs; [
        # CLI Core
        git
        starship
        eza
        fd
        bat
        ripgrep
        fzf
        file
        jq
        zoxide
        difftastic
        lsof
        tealdeer

        # Terminal File Manager
        yazi

        # Misc Utilities
        ffmpeg
        _7zz
        poppler-utils
        imagemagick
      ];

      xdg.config.files = {
        "yazi/plugins/full-border.yazi".source = "${pkgs.yaziPlugins.full-border}";
        "yazi/plugins/git.yazi".source = "${pkgs.yaziPlugins.git}";
      };
    };
}
