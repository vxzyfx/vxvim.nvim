-- https://github.com/neocmakelsp/neocmakelsp
-- CMake LSP implementation. Completion requires snippet support from the client,
-- which blink.cmp already provides.

---@type vim.lsp.Config
return {
  cmd = { "neocmakelsp", "stdio" },
  filetypes = { "cmake" },
  root_markers = { ".neocmake.toml", ".git", "build", "cmake" },
}
