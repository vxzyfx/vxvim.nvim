require("conform").setup({
  default_format_opts = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_format = "fallback", -- not recommended to change
  },
  formatters_by_ft = {
    cs = { "csharpier" },
    css = { "prettier" },
    html = { "prettier" },
    sh = { "shfmt", "shellcheck" },
    zsh = { "shfmt", "shellcheck" },
    go = { "goimports", "gofumpt" },
    lua = { "stylua" },
    nix = { "nixfmt" },
    php = { "php_cs_fixer" },
    kotlin = { "ktlint" },
    python = { "isort", "black" },
    typescript = { "prettier", "injected" },
    javascript = { "prettier", "injected" },
    ["markdown"] = { "prettier", "markdownlint-cli2", "injected" },
    ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "injected" },
  },
  formatters = {
    injected = {
      options = {
        ignore_errors = true,
      },
    },
    csharpier = {
      command = "csharpier",
      args = { "format" },
    },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args) require("conform").format({ bufnr = args.buf }) end,
})
