vim.pack.add({
  -- colorscheme
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
  -- dependence
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
  -- coding
  { src = "https://github.com/echasnovski/mini.pairs" },
  { src = "https://github.com/nvim-mini/mini.ai" },
  { src = "https://github.com/folke/ts-comments.nvim" },
  { src = "https://github.com/windwp/nvim-ts-autotag" },
  { src = "https://github.com/folke/lazydev.nvim" },
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
  -- dap
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/theHamsta/nvim-dap-virtual-text" },
  { src = "https://github.com/mfussenegger/nvim-dap-python" },
  { src = "https://github.com/leoluz/nvim-dap-go" },
  -- editor
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/stevearc/aerial.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  { src = "https://github.com/lewis6991/async.nvim" },
  { src = "https://github.com/ThePrimeagen/refactoring.nvim" },
  -- formatting
  { src = "https://github.com/stevearc/conform.nvim" },
  -- http
  { src = "https://github.com/mistweaverco/kulala.nvim" },
  -- linting
  { src = "https://github.com/mfussenegger/nvim-lint" },
  -- task
  { src = "https://github.com/stevearc/overseer.nvim" },
  -- test
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
  -- { src = "https://github.com/rcasia/neotest-java" },
  -- { src = "https://github.com/codymikol/neotest-kotlin" },
  -- treesitter
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/romus204/tree-sitter-manager.nvim" },
  -- ui
  { src = "https://github.com/folke/edgy.nvim" },
  { src = "https://github.com/folke/snacks.nvim" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/akinsho/bufferline.nvim" },
  { src = "https://github.com/MunifTanjim/nui.nvim" },
  { src = "https://github.com/folke/noice.nvim" },
  -- lsp
  { src = "https://github.com/Civitasv/cmake-tools.nvim" },
  { src = "https://github.com/seblyng/roslyn.nvim" },
  { src = "https://github.com/akinsho/flutter-tools.nvim" },
  -- { src = "https://github.com/mfussenegger/nvim-jdtls" },
  { src = "https://github.com/b0o/SchemaStore.nvim" },
  -- { src = "https://github.com/AlexandrosAlexiou/kotlin.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
  { src = "https://github.com/Saecki/crates.nvim" },
  { src = "https://github.com/mrcjkb/rustaceanvim" },
})

local M = {}

M.config = {
  -- icons used by other plugins
  -- stylua: ignore
  icons = {
    misc = {
      dots = "󰇘",
    },
    ft = {
      octo = "",
    },
    dap = {
      Stopped             = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
      Breakpoint          = " ",
      BreakpointCondition = " ",
      BreakpointRejected  = { " ", "DiagnosticError" },
      LogPoint            = ".>",
    },
    diagnostics = {
      Error = " ",
      Warn  = " ",
      Hint  = " ",
      Info  = " ",
    },
    git = {
      added    = " ",
      modified = " ",
      removed  = " ",
    },
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Codeium       = "󰘦 ",
      Color         = " ",
      Control       = " ",
      Collapsed     = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Copilot       = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Folder        = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Keyword       = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      Reference     = " ",
      Snippet       = "󱄽 ",
      String        = " ",
      Struct        = "󰆼 ",
      Supermaven    = " ",
      TabNine       = "󰏚 ",
      Text          = " ",
      TypeParameter = " ",
      Unit          = " ",
      Value         = " ",
      Variable      = "󰀫 ",
    },
  },
  ---@type table<string, string[]|boolean>?
  kind_filter = {
    default = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      "Package",
      "Property",
      "Struct",
      "Trait",
    },
    markdown = false,
    help = false,
    -- you can specify a different filter for each filetype
    lua = {
      "Class",
      "Constructor",
      "Enum",
      "Field",
      "Function",
      "Interface",
      "Method",
      "Module",
      "Namespace",
      -- "Package", -- remove package since luals uses it for control flow structures
      "Property",
      "Struct",
      "Trait",
    },
  },
  lsp_servers = {
    "astro",
    "basedpyright",
    "bashls",
    "clangd",
    "dockerls",
    "elp",
    "expert",
    "gopls",
    "jsonls",
    "lua_ls",
    "neocmake",
    "nixd",
    "tailwindcss",
    "vue_ls",
    "phpactor",
    "ruby_lsp",
    "solidity", -- prefer "solidity_ls_nomicfoundation" for Hardhat/Foundry projects
    "sourcekit",
    "helm_ls",
    "yamlls",
    "zls",
  },
}

function M.setup(opts)
  if vim.fs.root(0, { "deno.json", "deno.jsonc" }) then
    table.insert(M.config.lsp_servers, "denols")
  else
    table.insert(M.config.lsp_servers, "vtsls")
  end
  require("vxvim.config.options")
  require("vxvim.config.keymaps")
  require("vxvim.plugins.colorscheme")
  require("vxvim.plugins.coding")
  require("vxvim.plugins.editor")
  require("vxvim.plugins.ui")
  require("vxvim.plugins.treesitter")
  require("vxvim.plugins.formatting")
  require("vxvim.plugins.linting")
  require("vxvim.plugins.dap")
  require("vxvim.plugins.http")
  require("vxvim.plugins.task")
  require("vxvim.plugins.lsp")
end

return M
