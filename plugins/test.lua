vim.pack.add({
  { src = "https://github.com/nvim-neotest/neotest" },
  { src = "https://github.com/nvim-neotest/neotest-python" },
  { src = "https://github.com/nvim-neotest/nvim-nio" },
  { src = "https://github.com/sidlatau/neotest-dart" },
  { src = "https://github.com/llllvvuu/neotest-foundry" },
  { src = "https://github.com/fredrikaverpil/neotest-golang" },
  { src = "https://github.com/alfaix/neotest-gtest" },
  { src = "https://github.com/mmllr/neotest-swift-testing" },
  { src = "https://github.com/lawrence-laz/neotest-zig" },
  { src = "https://github.com/marilari88/neotest-vitest" },
  { src = "https://github.com/nsidorenco/neotest-vstest" },
  { src = "https://github.com/rcasia/neotest-java" },
  { src = "https://github.com/codymikol/neotest-kotlin" },
})

local set = vim.keymap.set

require("neotest").setup({
  adapters = {
    ["rustaceanvim.neotest"] = {},
    ["neotest-dart"] = {
      command = "flutter",
      use_lsp = true,
    },
    ["neotest-foundry"] = {},
    ["neotest-golang"] = {
      dap_go_enabled = true, -- requires leoluz/nvim-dap-go
    },
    ["neotest-gtest"] = {},
    ["neotest-python"] = {},
    ["neotest-zig"] = {},
    ["neotest-vitest"] = {},
    ["neotest-vstest"] = {},
    ["neotest-swift-testing"] = {},
    ["neotest-java"] = {},
    ["neotest-kotlin"] = {},
  },
  status = { virtual_text = true },
  output = { open_on_run = true },
})

set("n", "<leader>t", "", { desc = "+test" })
set("n", "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, { desc = "Run File (Neotest)" })
set(
  "n",
  "<leader>tT",
  function() require("neotest").run.run(vim.uv.cwd()) end,
  { desc = "Run All Test Files (Neotest)" }
)
set("n", "<leader>tr", function() require("neotest").run.run() end, { desc = "Run Nearest (Neotest)" })
set("n", "<leader>tl", function() require("neotest").run.run_last() end, { desc = "Run Last (Neotest)" })
set("n", "<leader>ts", function() require("neotest").summary.toggle() end, { desc = "Toggle Summary (Neotest)" })
set(
  "n",
  "<leader>to",
  function() require("neotest").output.open({ enter = true, auto_close = true }) end,
  { desc = "Show Output (Neotest)" }
)
set(
  "n",
  "<leader>tO",
  function() require("neotest").output_panel.toggle() end,
  { desc = "Toggle Output Panel (Neotest)" }
)
set("n", "<leader>tS", function() require("neotest").run.stop() end, { desc = "Stop (Neotest)" })
set(
  "n",
  "<leader>tw",
  function() require("neotest").watch.toggle(vim.fn.expand("%")) end,
  { desc = "Toggle Watch (Neotest)" }
)
