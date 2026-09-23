-- https://github.com/LuaLS/lua-language-server
-- Install: https://luals.github.io/#neovim-install
-- Neovim API/plugin types are provided by lazydev.nvim (see lua/vxvim/plugins/coding.lua).

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    { ".emmyrc.json", ".luarc.json", ".luarc.jsonc" },
    { ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" },
    { ".git" },
  },
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
    },
  },
}
