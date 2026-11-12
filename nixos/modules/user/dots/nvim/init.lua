-- Neovim configuration.
--
-- This directory is a dotfile: nixos/modules/user/dots/nvim -> ~/.config/nvim.
-- The Nix side (binary, plugins, language servers, grammars) is
-- nixos/modules/features/neovim.nix.
-- See ~/Documents/NOTE_NVIM.md for the whole picture.

-- Leader key. Must be set before any <Leader> mapping is created.
vim.g.mapleader = " "

-- Project local configuration: Neovim executes a .nvim.lua in the project
-- directory, so a project can bring its own servers and settings.
-- It has to be set here, because the search happens before plugin/ is sourced.
-- A file is only executed when you trust it (`:trust`, `:h trust`).
vim.o.exrc = true

-- Kanagawa "Dragon". Transparent, so the terminal shows through.
require("kanagawa").setup({ transparent = true })
vim.cmd.colorscheme("kanagawa-dragon")
