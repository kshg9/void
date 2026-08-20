{
  inputs,
  ...
}:
{
  flake.nixosModules.isolate-apps = {
    imports = [ inputs.nixjail.nixosModules.nixjail ];

    nixjail.bwrap.profiles = [
      {
        packages = f: p: {
          google-chrome = p.google-chrome;
          vesktop = p.vesktop;
        };

        xdg = true;
        dri = true;
        dev = true;
        tmp = true;

        shareNamespace = {
          ipc = true;
          pid = true;
        };

        autoBindHome = true;
        homeDirRoot = "$HOME/.nixjail";

        rwBinds = [
          "$HOME/Downloads"
          "$HOME/Pictures"
        ];

        extraConfig = [
          "\$(for b in \${NIXJAIL_RW_BINDS:-}; do echo \"--bind-try \$b \$b\"; done)"
          "\$(for b in \${NIXJAIL_RO_BINDS:-}; do echo \"--ro-bind-try \$b \$b\"; done)"
          "\${NIXJAIL_EXTRA:-}"
        ];
      }
    ];
  };
}
