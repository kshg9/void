{ inputs, ... }: {
  flake.nixosModules.llm-agents = { pkgs, ... }: {
    hjem.users.kdj.packages = with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
      opencode
      antigravity-cli
    ];
  };
}
