local lint = require("lint")

lint.linters_by_ft = {
  fish = { "fish" },
  sh = { "shellcheck" },
  zsh = { "shellcheck" },
  cmake = { "cmakelint" },
  php = { "phpcs" },
  kotlin = { "ktlint" },
  markdown = { "markdownlint-cli2" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("vxvim_nvim_lint", { clear = true }),
  callback = function() require("lint").try_lint() end,
})
