vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim" },
})

require("conform").setup({
  default_format_opts = {
    timeout_ms = 3000,
    async = false, -- not recommended to change
    quiet = false, -- not recommended to change
    lsp_format = "fallback", -- not recommended to change
  },
  formatters_by_ft = {
    cs = { "csharpier" },
    sh = { "shfmt", "shellcheck" },
    zsh = { "shfmt", "shellcheck" },
    go = { "goimports", "gofumpt" },
    lua = { "stylua" },
    nix = { "nixfmt" },
    php = { "php_cs_fixer" },
    kotlin = { "ktlint" },
    python = { "isort", "black" },
    ["markdown"] = { "prettier", "markdownlint-cli2" },
    ["markdown.mdx"] = { "prettier", "markdownlint-cli2" },
  },
  formatters = {
    injected = { options = { ignore_errors = true } },
    csharpier = {
      command = "csharpier",
      args = { "format" },
    },
    ["markdownlint-cli2"] = {
      condition = function(_, ctx)
        local diag = vim.tbl_filter(function(d) return d.source == "markdownlint" end, vim.diagnostic.get(ctx.buf))
        return #diag > 0
      end,
    },
  },
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args) require("conform").format({ bufnr = args.buf }) end,
})
