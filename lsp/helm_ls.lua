-- https://github.com/mrjosh/helm-ls
-- Install: https://github.com/mrjosh/helm-ls#installation
-- If you need Helm file highlighting, use https://github.com/towolf/vim-helm.

---@type vim.lsp.Config
return {
  cmd = { "helm_ls", "serve" },
  filetypes = { "helm", "yaml.helm-values" },
  root_markers = { "Chart.yaml" },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
}
