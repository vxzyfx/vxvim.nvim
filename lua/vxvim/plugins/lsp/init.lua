require("vxvim.plugins.lsp.cmake")
require("vxvim.plugins.lsp.csharp")
require("vxvim.plugins.lsp.flutter")
require("vxvim.plugins.lsp.json")
require("vxvim.plugins.lsp.markdown")
require("vxvim.plugins.lsp.rust")

local vxvim = require("vxvim")
local executable = require("vxvim.util.executable")

for _, lsp in pairs(vxvim.config.lsp_servers) do
  local result = executable.evaluate(vxvim.config.lsp_executables[lsp])

  if result.available then vim.lsp.enable(lsp) end
end
