local lint = require("lint")

lint.events = { "BufWritePost", "BufReadPost", "InsertLeave" }
lint.linters_by_ft = {
  fish = { "fish" },
  sh = { "shellcheck" },
  zsh = { "shellcheck" },
  cmake = { "cmakelint" },
  php = { "phpcs" },
  kotlin = { "ktlint" },
  markdown = { "markdownlint-cli2" },
  -- Use the "*" filetype to run linters on all filetypes.
  -- ['*'] = { 'global linter' },
  -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
  -- ['_'] = { 'fallback linter' },
  -- ["*"] = { "typos" },
}
lint.linters = {}
