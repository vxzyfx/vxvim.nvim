require("lazydev").setup({
  library = {
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    { path = "snacks.nvim", words = { "Snacks" } },
  },
})

require("blink.cmp").setup({
  appearance = {
    use_nvim_cmp_as_default = false,
    nerd_font_variant = "mono",
  },
  completion = {
    accept = {
      -- experimental auto-brackets support
      auto_brackets = {
        enabled = true,
      },
    },
    menu = {
      draw = {
        treesitter = { "lsp" },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
    ghost_text = {
      enabled = true,
    },
  },
  signature = { enabled = true },
  sources = {
    per_filetype = {
      lua = { inherit_defaults = true, "lazydev" },
    },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100, -- show at a higher priority than lsp
      },
    },
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
  },
  keymap = {
    preset = "enter",
    ["<C-y>"] = { "select_and_accept" },
  },
})

require("mini.pairs").setup({
  modes = { insert = true, command = true, terminal = false },
})
require("mini.ai").setup({})
require("ts-comments").setup({})
require("nvim-ts-autotag").setup({})
