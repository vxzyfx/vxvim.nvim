local set = vim.keymap.set
local vxvim = require("vxvim")
local executable = require("vxvim.util.executable")

local adapter_specs = {
  {
    name = "rustaceanvim.neotest",
    executable = vxvim.config.neotest_executables["rustaceanvim.neotest"],
    factory = function() return require("rustaceanvim.neotest") end,
  },
  {
    name = "neotest-dart",
    executable = vxvim.config.neotest_executables["neotest-dart"],
    factory = function() return require("neotest-dart")({ command = "flutter", use_lsp = true }) end,
  },
  {
    name = "neotest-foundry",
    executable = vxvim.config.neotest_executables["neotest-foundry"],
    factory = function() return require("neotest-foundry") end,
  },
  {
    name = "neotest-golang",
    executable = vxvim.config.neotest_executables["neotest-golang"],
    factory = function() return require("neotest-golang")({ dap = { justMyCode = false } }) end,
  },
  {
    name = "neotest-gtest",
    executable = vxvim.config.neotest_executables["neotest-gtest"],
    factory = function() return require("neotest-gtest") end,
  },
  {
    name = "neotest-python",
    executable = vxvim.config.neotest_executables["neotest-python"],
    factory = function() return require("neotest-python")({ dap = { justMyCode = false }, runner = "pytest" }) end,
  },
  {
    name = "neotest-zig",
    executable = vxvim.config.neotest_executables["neotest-zig"],
    factory = function() return require("neotest-zig") end,
  },
  {
    name = "neotest-vitest",
    executable = vxvim.config.neotest_executables["neotest-vitest"],
    factory = function() return require("neotest-vitest") end,
  },
  {
    name = "neotest-vstest",
    executable = vxvim.config.neotest_executables["neotest-vstest"],
    factory = function() return require("neotest-vstest") end,
  },
  {
    name = "neotest-swift-testing",
    executable = vxvim.config.neotest_executables["neotest-swift-testing"],
    factory = function() return require("neotest-swift-testing") end,
  },
  -- require("neotest-java"),
  -- require("neotest-kotlin"),
}

local adapters = {}

for _, spec in ipairs(adapter_specs) do
  local result = executable.evaluate(spec.executable)
  if result.available then table.insert(adapters, spec.factory()) end
end

-- neotest expects `adapters` as a list of adapter instances. Each adapter is
-- either a static module (use `require("name")`) or a callable that accepts
-- options (use `require("name")(opts)`). Per consensus delta Δ6:
--   static:    rustaceanvim.neotest, neotest-foundry, neotest-gtest,
--              neotest-zig, neotest-swift-testing
--   callable:  neotest-dart, neotest-golang, neotest-python, neotest-vitest,
--              neotest-vstest
require("neotest").setup({
  adapters = adapters,
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
