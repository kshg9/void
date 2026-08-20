{
  inputs,
  ...
}:
{
  flake.nixosModules.isolate-agents =
    { pkgs, ... }:
    let
      llmPkgs = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};
    in
    {
      imports = [ inputs.nixjail.nixosModules.nixjail ];

      nixjail.bwrap.profiles = [
        {
          packages = f: p: {
            claude-desktop = llmPkgs.claude-desktop;
            antigravity-cli = llmPkgs.antigravity-cli;
            chatgpt = llmPkgs.chatgpt;
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
            "$HOME/Documents"
          ];

          extraConfig = [
            "\$(for b in \${NIXJAIL_RW_BINDS:-}; do echo \"--bind-try \$b \$b\"; done)"
            "\$(for b in \${NIXJAIL_RO_BINDS:-}; do echo \"--ro-bind-try \$b \$b\"; done)"
            "\${NIXJAIL_EXTRA:-}"
          ];
        }
      ];

      hjem.users.kdj.packages = [
        llmPkgs.workmux
      ];
    };
}
