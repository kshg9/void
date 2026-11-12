-- Build and run.
--
-- <leader>m  runs :make, so a Makefile in the project decides what happens.
--            If something failed, the quickfix list opens with the errors.
-- <leader>r  compiles the current C/C++ file and runs it in a terminal split.

local function make()
  vim.cmd("make")

  -- Only open the quickfix list when there is something to look at.
  local qf = vim.fn.getqflist({ title = 0, items = 0 })
  if #qf.items > 0 then
    vim.cmd("copen")
  end
end

local function compile_and_run()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" then
    vim.notify("Save the file before running it", vim.log.levels.WARN)
    return
  end

  local compiler = ({ c = "gcc", cpp = "g++" })[vim.bo.filetype]
  if not compiler then
    vim.notify("No compiler known for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end

  -- Build into a temporary directory so nothing is left in your project.
  local outdir = vim.fn.tempname()
  vim.fn.mkdir(outdir, "p")
  local binary = outdir .. "/" .. vim.fn.fnamemodify(path, ":t:r")

  -- -g keeps the debug symbols, so gdb works on the binary later.
  local cmd = table.concat({
    compiler,
    "-g",
    "-Wall",
    "-Wextra",
    "-o",
    vim.fn.shellescape(binary),
    vim.fn.shellescape(path),
  }, " ")

  vim.fn.jobstart(cmd, {
    on_exit = function(_, code)
      if code ~= 0 then
        vim.notify("Compilation failed", vim.log.levels.ERROR)
        return
      end

      -- Run the program in a split below the current window.
      vim.cmd("botright split")
      vim.cmd("terminal " .. vim.fn.shellescape(binary))
      vim.cmd("startinsert")
    end,
  })
end

vim.keymap.set("n", "<leader>m", make, { desc = "Build (:make)" })
vim.keymap.set("n", "<leader>r", compile_and_run, { desc = "Compile and run this file" })
