vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/saghen/blink.cmp" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

require("vxvin.config.options")
require("vxvin.config.keymaps")
require("vxvin.plugins.colorscheme")
require("vxvin.plugins.coding")
require("vxvin.plugins.editor")
require("vxvin.plugins.ui")
require("vxvin.plugins.treesitter")
require("vxvin.plugins.formatting")
require("vxvin.plugins.linting")
require("vxvin.plugins.dap")
require("vxvin.plugins.http")
