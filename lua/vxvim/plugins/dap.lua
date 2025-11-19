local set = vim.keymap.set
---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

set(
  "n",
  "<leader>dB",
  function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
  { desc = "Breakpoint Condition" }
)
set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Run/Continue" })
set("n", "<leader>da", function() require("dap").continue({ before = get_args }) end, { desc = "Run with Args" })
set("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "Run to Cursor" })
set("n", "<leader>dg", function() require("dap").goto_() end, { desc = "Go to Line (No Execute)" })
set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
set("n", "<leader>dj", function() require("dap").down() end, { desc = "Down" })
set("n", "<leader>dk", function() require("dap").up() end, { desc = "Up" })
set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "Run Last" })
set("n", "<leader>do", function() require("dap").step_out() end, { desc = "Step Out" })
set("n", "<leader>dn", function() require("dap").step_over() end, { desc = "Step Over" })
set("n", "<leader>dP", function() require("dap").pause() end, { desc = "Pause" })
set("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "Toggle REPL" })
set("n", "<leader>ds", function() require("dap").session() end, { desc = "Session" })
set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })
set("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "Widgets" })
set("n", "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, { desc = "Debug Nearest" })
