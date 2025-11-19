local overseer = require("overseer")
local set = vim.keymap.set

overseer.setup({
  dap = false,
  task_list = {
    bindings = {
      ["<C-j>"] = false,
      ["<C-k>"] = false,
    },
  },
  form = {
    win_opts = {
      winblend = 0,
    },
  },
  confirm = {
    win_opts = {
      winblend = 0,
    },
  },
  task_win = {
    win_opts = {
      winblend = 0,
    },
  },
})

set("n", "<leader>ow", "<cmd>OverseerToggle<cr>", { desc = "Task list" })
set("n", "<leader>oo", "<cmd>OverseerRun<cr>", { desc = "Run Task" })
