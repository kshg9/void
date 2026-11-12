-- Keymaps.
--
-- <Leader> is <Space>. Every leader mapping goes through `nmap_leader()` so it
-- stays one line long and always carries a description. The description is
-- what mini.clue shows you right after you press <Space>.

local map = vim.keymap.set

local function nmap_leader(suffix, rhs, desc)
  map("n", "<Leader>" .. suffix, rhs, { desc = desc })
end

--- Pickers (mini.pick and mini.extra) -------------------------------------
-- `:Pick <name>` opens a picker by name; `:Pick` with completion shows them all.

nmap_leader("f", "<Cmd>Pick files<CR>", "Files")
nmap_leader("/", "<Cmd>Pick grep_live<CR>", "Live grep")
nmap_leader("b", "<Cmd>Pick buffers<CR>", "Buffers")
nmap_leader("h", "<Cmd>Pick help<CR>", "Help tags")
nmap_leader("d", '<Cmd>Pick diagnostic scope="all"<CR>', "Diagnostics")
nmap_leader("q", '<Cmd>Pick list scope="quickfix"<CR>', "Quickfix list")
nmap_leader("c", "<Cmd>Pick commands<CR>", "Commands")
nmap_leader("o", '<Cmd>Pick lsp scope="document_symbol"<CR>', "Symbols in file")
nmap_leader("W", '<Cmd>Pick lsp scope="workspace_symbol"<CR>', "Symbols in workspace")
nmap_leader("t", "<Cmd>Pick treesitter<CR>", "Tree-sitter symbols")
nmap_leader("p", "<Cmd>Pick resume<CR>", "Resume last picker")

--- Explorer (mini.files) ---------------------------------------------------
-- mini.files has no command, it is called from Lua.

nmap_leader("e", function()
  require("mini.files").open()
end, "File explorer")

--- Editing ----------------------------------------------------------------

nmap_leader("w", "<Cmd>write<CR>", "Save")
nmap_leader("x", function()
  require("mini.bufremove").delete()
end, "Close buffer")
nmap_leader("X", function()
  require("mini.bufremove").wipeout()
end, "Close buffer (wipe out)")

-- Jump between buffers with <Tab> / <S-Tab> (like Ctrl+Tab in VS Code).
map("n", "<Tab>", "<Cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Window navigation.
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Leave terminal mode with <Esc>.
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

--- "Smart" insert mode keys (mini.keymap) --------------------------------
-- One key, different behaviour depending on the context:
-- <Tab> cycles the completion popup, <CR> accepts it, and both still behave
-- normally when no popup is open.

local map_multistep = require("mini.keymap").map_multistep
map_multistep("i", "<Tab>", { "pmenu_next" })
map_multistep("i", "<S-Tab>", { "pmenu_prev" })
map_multistep("i", "<CR>", { "pmenu_accept", "minipairs_cr" })
map_multistep("i", "<BS>", { "minipairs_bs" })
