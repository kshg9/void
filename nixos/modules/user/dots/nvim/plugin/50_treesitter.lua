-- Tree-sitter: syntax highlighting and structure aware editing.
--
-- Neovim 0.12 contains the tree-sitter engine itself. The *grammars* (the
-- parser for each language plus the highlight queries) are provided by Nix,
-- see nixos/modules/features/neovim.nix.
--
-- Read `:h treesitter` to learn what this buys you: `g?` shows the structure
-- of the file, motions like `ci(` and `va{` work on real syntax, and the
-- highlighter knows about comments, strings and functions.

-- Neovim calls the language of a shell script "sh", but the grammar is called
-- "bash". Tell it where to look.
vim.treesitter.language.register("bash", "sh")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("Treesitter", { clear = true }),
  callback = function(args)
    -- The language is taken from the filetype. Not every filetype has a
    -- grammar, and that is not an error.
    pcall(vim.treesitter.start, args.buf)
  end,
})
