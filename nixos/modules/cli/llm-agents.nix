{
  inputs,
  ...
}:
{
  flake.nixosModules.llm-agents =
    { pkgs, ... }:
    {
      hjem.users.kdj.packages =
        (with inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}; [
          pi
          dsh
          claude-desktop
          antigravity-cli
          chatgpt

          workmux
        ])
        ++ (with pkgs; [
          nodejs
          pnpm
        ]);
    };
}
