-- https://github.com/rcjsuen/dockerfile-language-server-nodejs
-- Install: npm install -g dockerfile-language-server-nodejs

---@type vim.lsp.Config
return {
  cmd = { "docker-langserver", "--stdio" },
  filetypes = { "dockerfile" },
  root_markers = { "Dockerfile" },
}
