vim.filetype.add({
  extension = {
    ["http"] = "http",
  },
})

require("kulala").setup({
  default_view = "body",
  default_env = "dev",
  debug = false,
})

local set = vim.keymap.set
set("n", "<leader>Rs", function() require("kulala").run() end, { desc = "Send request" })
set("n", "<leader>Ra", function() require("kulala").run_all() end, { desc = "Send all requests" })
set("n", "<leader>Rt", function() require("kulala").toggle_view() end, { desc = "Toggle headers/body" })
