local schemastore = require("schemastore")

vim.lsp.config("jsonls", {
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
})

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        -- Disable yamlls' built-in schema store; use SchemaStore.nvim's index instead
        enable = false,
        url = "",
      },
      schemas = schemastore.yaml.schemas(),
    },
  },
})
