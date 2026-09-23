-- https://github.com/nix-community/nixd
-- Install: nix profile install github:nix-community/nixd

---@type vim.lsp.Config
return {
  cmd = { "nixd" },
  filetypes = { "nix" },
  root_markers = { "flake.nix", ".git" },
}
