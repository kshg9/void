-- yaml-language-server: yaml files.
--
-- The binary comes from Nix; see nixos/modules/features/neovim.nix.

return {
  cmd = { "yaml-language-server", "--stdio" },

  filetypes = { "yaml" },

  root_markers = {
    ".yamllint",
    "yaml-language-server.yaml",
    ".git",
  },
}
