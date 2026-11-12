-- Options that make Neovim behave like a modern editor.
-- Every line here is a plain Vim option; `:h option-name` explains one.
-- Options that already have the value you want are not listed.

local o = vim.o

-- Numbers: the absolute number on the cursor line, relative numbers on the
-- others. Without 'number' the cursor line would only show "0".
o.number = true
o.relativenumber = true
o.cursorline = true

-- Indentation: spaces, never tabs. 4 for C, other languages override it in
-- their ftplugin file.
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.shiftround = true

-- Case insensitive search, but a capital letter still means "case sensitive".
o.ignorecase = true
o.smartcase = true

-- Preview the effect of a :s command while you type it.
o.inccommand = "split"

-- Undo history that survives closing the file.
o.undofile = true

-- No swap files: they are slow and rarely worth it.
o.swapfile = false

-- Yanks and puts use the system clipboard.
o.clipboard = "unnamedplus"

-- Keep some context around the cursor when scrolling.
o.scrolloff = 8
o.scrolljump = 8

-- Splits open on the side you expect.
o.splitright = true
o.splitbelow = true

-- <C-o> (jump back) also restores the scroll position.
vim.opt.jumpoptions:append("view")

-- True colour, needed by the theme.
o.termguicolors = true

-- Always show the statusline; mini.statusline needs this to tell the active
-- window from the inactive ones.
o.laststatus = 3

-- How long Neovim waits for the rest of a <Leader> sequence.
o.timeoutlen = 400
