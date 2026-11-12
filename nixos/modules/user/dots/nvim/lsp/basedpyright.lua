-- basedpyright: the Python language server (a fork of Pyright).
--
-- The binary comes from Nix; see nixos/modules/features/neovim.nix.
--
-- This server is NOT started globally. A Python project enables it with one
-- line in its own .nvim.lua (the 'exrc' option is on):
--
--     vim.lsp.enable("basedpyright")
--
-- The settings below are then used as they are.

return {
  -- --stdio tells the server to talk over stdin/stdout, which is what Neovim
  -- expects.
  cmd = { "basedpyright-langserver", "--stdio" },

  filetypes = { "python" },

  -- Walk up until one of these is found; that directory is the project root.
  root_markers = {
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git",
  },
}
