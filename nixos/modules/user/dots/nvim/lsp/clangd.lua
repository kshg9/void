-- clangd: the C and C++ language server.
--
-- Neovim picks this file up automatically for the "clangd" configuration
-- (`:h lsp-config`). The binary itself comes from Nix.

return {
  cmd = { "clangd" },

  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },

  -- clangd walks up from the file until it finds one of these. With a
  -- compile_commands.json it knows your exact compiler flags, which is the
  -- best case.
  root_markers = {
    "compile_commands.json",
    ".clangd",
    "CMakeLists.txt",
    "Makefile",
    ".git",
  },
}
