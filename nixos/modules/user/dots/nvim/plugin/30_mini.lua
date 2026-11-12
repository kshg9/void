-- The mini.nvim modules.
--
-- Each one is independent: comment out a setup() call to switch the feature
-- off. `:h mini.<name>` is the documentation.

-- Fuzzy finder: files, buffers, grep, help tags, ...
require("mini.pick").setup()

-- Extra pickers: diagnostics, git, LSP symbols, quickfix, ...
require("mini.extra").setup()

-- File explorer. `g?` inside it shows its own keymaps.
require("mini.files").setup()

-- Completion popup and signature help, fed by the LSP client.
require("mini.completion").setup()

-- "Smart" keys: one key, different behaviour depending on the context.
require("mini.keymap").setup()

-- Auto-closing brackets and quotes.
require("mini.pairs").setup()

-- Surrounding characters: sa/sd/sf/sr.
require("mini.surround").setup()

-- Extra text objects: af/if (function), aa/ia (argument), ac/ic (class).
require("mini.ai").setup()

-- Shows which key to press after <Leader>.
-- Triggers are what mini.clue watches; without one it never shows anything.
-- The trigger has to be the literal leader character: mini.clue compares it
-- with the left hand side of the mappings, and "<Leader>" is not expanded.
require("mini.clue").setup({
  triggers = {
    { mode = { "n", "x" }, keys = " " },
  },
  window = {
    delay = 300, -- how long to wait before the window appears
  },
})

-- Git changes in the sign column.
require("mini.diff").setup()

-- Move lines and selections with Alt + hjkl.
require("mini.move").setup()

require("mini.misc").setup()

-- "Open folder" behaviour: jump to the project root when you open a file.
require("mini.misc").setup_auto_root({
  ".git",
  "flake.nix",
  "Makefile",
  "CMakeLists.txt",
  "package.json",
  "pyproject.toml",
})

-- Remember where the cursor was in each file and put it back.
require("mini.misc").setup_restore_cursor()

-- Close a buffer without leaving a strange window layout behind.
require("mini.bufremove").setup()

-- More [ and ] jumps.
require("mini.bracketed").setup()

-- File icons in the statusline, pickers and explorer.
require("mini.icons").setup()

-- Git data: the branch in the statusline, and the `:Git` command.
require("mini.git").setup()

-- Snippets. mini.completion recommends it for handling LSP snippets.
require("mini.snippets").setup()

-- A better command line: history, completion, and a peek at what you type.
require("mini.cmdline").setup()

-- Notifications, and the LSP progress they show.
require("mini.notify").setup()

-- The buffer list at the top of the screen.
require("mini.tabline").setup()

-- Highlight the word under the cursor.
require("mini.cursorword").setup()

-- Split and join lines (gS), for long lists and broken expressions.
require("mini.splitjoin").setup()

-- Jump to a place on the screen (like Ctrl+Shift+Click in a browser).
require("mini.jump2d").setup()

-- Align tables and assignments (ga).
require("mini.align").setup()

-- The statusline: mode on the left, git/diff/diagnostics/lsp next to it, the
-- file name, and on the right the file type and the position in the file.
-- `:h MiniStatusline` shows how to rearrange it.
require("mini.statusline").setup()

-- `noselect` means nothing is selected until you press <Tab>, so the first
-- <Tab> lands on the first candidate.
vim.o.completeopt = "menuone,noselect,fuzzy"
