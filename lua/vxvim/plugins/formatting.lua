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
    -- csharpier override removed: rely on conform's bundled definition,
    -- which handles stdin/stdout flow correctly across csharpier 1.x/2.x.
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("vxvim_conform_format_on_save", { clear = true }),
  pattern = "*",
  callback = function(args) require("conform").format({ bufnr = args.buf }) end,
})
