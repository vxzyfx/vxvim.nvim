local buf = vim.api.nvim_get_current_buf()
local kulala = require("kulala")

local set = vim.keymap.set

kulala.setup({
  ui = {
    max_response_size = 320000,
  },
  contenttypes = {
    ["application/vnd.optile.payment.enterprise-v1-extensible+json"] = "application/json",
  },
})

set("n", "<leader>R", "", { desc = "+Rest" })
set("n", "<leader>Rb", function() kulala.scratchpad() end, { desc = "Open scratchpad", buffer = buf })
set("n", "<leader>Rc", function() kulala.copy() end, { desc = "Copy as cURL", buffer = buf })
set("n", "<leader>RC", function() kulala.from_curl() end, { desc = "Paste from curl", buffer = buf })
set(
  "n",
  "<leader>Rg",
  function() kulala.download_graphql_schema() end,
  { desc = "Download GraphQL schema", buffer = buf }
)
set("n", "<leader>Ri", function() kulala.inspect() end, { desc = "Inspect current request", buffer = buf })
set("n", "<leader>Rn", function() kulala.jump_next() end, { desc = "Jump to next request", buffer = buf })
set("n", "<leader>Rp", function() kulala.jump_prev() end, { desc = "Jump to previous request", buffer = buf })
set("n", "<leader>Rq", function() kulala.close() end, { desc = "Close window", buffer = buf })
set("n", "<leader>Rr", function() kulala.replay() end, { desc = "Replay the last request", buffer = buf })
set("n", "<leader>Rs", function() kulala.run() end, { desc = "Send the request", buffer = buf })
set("n", "<leader>RS", function() kulala.show_stats() end, { desc = "Show stats", buffer = buf })
set("n", "<leader>Rt", function() kulala.toggle_view() end, { desc = "Toggle headers/body", buffer = buf })
set("n", "<leader>Rj", function() kulala.open_cookies_jar() end, { desc = "Open cookies jar", buffer = buf })
set("n", "<leader>Re", function() kulala.set_selected_env() end, { desc = "Select environment", buffer = buf })
set("n", "<leader>Rx", function() kulala.scripts_clear_global() end, { desc = "Clear globals", buffer = buf })
set("n", "<leader>RX", function() kulala.clear_cached_files() end, { desc = "Clear cached files", buffer = buf })
set(
  "n",
  "<leader>Ru",
  function() require("kulala.ui.auth_manager").open_auth_config() end,
  { desc = "Manage Auth Config", buffer = buf }
)
