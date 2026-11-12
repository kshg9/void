-- bash-language-server: shell scripts.
--
-- The binary comes from Nix; see nixos/modules/features/neovim.nix.

return {
  -- The server needs the "start" argument to speak LSP.
  cmd = { "bash-language-server", "start" },

  filetypes = { "bash", "sh" },

  root_markers = {
    ".bashrc",
    ".bash_profile",
    ".bash_login",
    ".profile",
    "PKGBUILD",
    ".git",
  },
}
