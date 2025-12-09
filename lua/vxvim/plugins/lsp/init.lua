require("vxvim.plugins.lsp.cmake")
require("vxvim.plugins.lsp.csharp")
require("vxvim.plugins.lsp.flutter")
require("vxvim.plugins.lsp.json")
require("vxvim.plugins.lsp.markdown")
require("vxvim.plugins.lsp.rust")

local vxvim = require("vxvim")
for _, lsp in pairs(vxvim.config.lsp_servers) do
  vim.lsp.enable(lsp)
end
