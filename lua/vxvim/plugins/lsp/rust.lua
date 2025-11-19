local grp = vim.api.nvim_create_augroup("Vxvim.rust", { clear = true })

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = grp,
  pattern = "Cargo.toml",
  callback = function(ev)
    require("crates").setup({
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    })
    vim.keymap.set("n", "<leader>ct", function() require("crates").toggle() end, {
      desc = "Crates Toggle",
      buffer = ev.buf,
    })
    vim.keymap.set("n", "<leader>cv", function() require("crates").show_versions_popup() end, {
      desc = "Crates Versions",
      buffer = ev.buf,
    })
    vim.keymap.set("n", "<leader>cf", function() require("crates").show_features_popup() end, {
      desc = "Crates Features",
      buffer = ev.buf,
    })
    vim.keymap.set("n", "<leader>cd", function() require("crates").show_dependencies_popup() end, {
      desc = "Crates Dependencies",
      buffer = ev.buf,
    })
  end,
})

vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, {
  server = {
    on_attach = function(_client, bufnr)
      vim.keymap.set(
        "n",
        "<leader>ce",
        function() vim.cmd.RustLsp("expandMacro") end,
        { desc = "Expand Macro", buffer = bufnr }
      )
      vim.keymap.set("n", "<leader>cR", function() vim.cmd.RustLsp("runnables") end, { desc = "Run", buffer = bufnr })
      vim.keymap.set(
        "n",
        "<leader>dR",
        function() vim.cmd.RustLsp("debuggables") end,
        { desc = "Rust Debuggables", buffer = bufnr }
      )
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        -- Add clippy lints for Rust if using rust-analyzer
        checkOnSave = true,
        -- Enable diagnostics if using rust-analyzer
        diagnostics = {
          enable = true,
        },
        procMacro = {
          enable = true,
          ignored = {},
        },
        files = {
          excludeDirs = {
            ".direnv",
            ".git",
            ".github",
            ".gitlab",
            "bin",
            "node_modules",
            "target",
            "venv",
            ".venv",
          },
        },
      },
    },
  },
})
