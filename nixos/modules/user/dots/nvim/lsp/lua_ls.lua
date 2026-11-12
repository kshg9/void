-- lua-language-server: makes this very configuration understandable.
--
-- The binary comes from Nix; see nixos/modules/features/neovim.nix.

return {
  cmd = { "lua-language-server" },

  filetypes = { "lua" },

  -- Walk up until one of these is found; that directory is the project root.
  root_markers = {
    ".luarc.json",
    "stylua.toml",
    "selene.toml",
    "init.lua",
    ".git",
  },

  settings = {
    Lua = {
      -- Look for modules next to the file, like a plain Lua interpreter would.
      runtime = {
        version = "LuaJIT",
        path = {
          "?.lua",
          "?/init.lua",
        },
      },
      -- Tell the server about the plugins this configuration uses.
      workspace = {
        library = {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
        },
        checkThirdParty = false,
      },
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}
