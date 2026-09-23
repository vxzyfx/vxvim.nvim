-- https://github.com/qiuxiang/solidity-ls
-- Install: npm i -g solidity-ls
-- Make sure that solc is installed and matches the version of the file (solc-select is recommended).
-- For Foundry/Hardhat projects prefer `solidity_ls_nomicfoundation`.

---@type vim.lsp.Config
return {
  cmd = { "solidity-ls", "--stdio" },
  filetypes = { "solidity" },
  root_markers = { ".git", "package.json" },
  settings = { solidity = { includePath = "", remapping = {} } },
}
