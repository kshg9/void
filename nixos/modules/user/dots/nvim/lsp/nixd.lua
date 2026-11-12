-- nixd: the Nix language server.
--
-- The binary comes from Nix; see nixos/modules/features/neovim.nix.

return {
  cmd = { "nixd" },

  filetypes = { "nix" },

  root_markers = {
    "flake.nix",
    "flake.lock",
    "default.nix",
    ".git",
  },
}
