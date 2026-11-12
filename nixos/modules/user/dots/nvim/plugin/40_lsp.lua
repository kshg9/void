-- Language servers.
--
-- The settings of each server live in lsp/<server>.lua, which Neovim reads by
-- itself (`:h lsp-config`). The binaries come from Nix.

-- Only the servers you always want. A project enables another one with
-- `vim.lsp.enable("basedpyright")` in its .nvim.lua (see 'exrc').
vim.lsp.enable({ "clangd", "nixd", "lua_ls", "bashls", "yamlls" })

-- Errors and warnings get a sign in the gutter, everything is underlined.
-- The message itself stays out of the file; hover with `K` to read it.
vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  virtual_text = false,
  float = { border = "rounded" },
})

-- Format on save, but only when a server that can format is attached and the
-- file has no errors: formatting a file that does not compile can mangle it.
local function can_format(bufnr)
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
    if client:supports_method("textDocument/formatting") then
      for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
          return false
        end
      end
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("LspFormat", { clear = true }),
  callback = function(args)
    if can_format(args.buf) then
      vim.lsp.buf.format({ bufnr = args.buf, async = false })
    end
  end,
})

-- gd, K, grn, gra, grr, gri, gO are Neovim defaults already.
vim.keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format({ async = false })
end, { desc = "Format document (LSP)" })

vim.keymap.set("n", "<leader>ld", function()
  vim.diagnostic.open_float()
end, { desc = "Show diagnostics for this line" })

vim.keymap.set("n", "<leader>lr", function()
  vim.lsp.buf.rename()
end, { desc = "Rename symbol (LSP)" })
