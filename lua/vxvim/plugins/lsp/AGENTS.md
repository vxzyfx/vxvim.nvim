# LSP PLUGIN GLUE

Plugin-managed language server configurations. These languages are intentionally **not** in `vxvim.config.lsp_servers` — the third-party plugin owns the server lifecycle.

## STRUCTURE

```
lua/vxvim/plugins/lsp/
├── init.lua      # loads all per-language modules, then vim.lsp.enable(lsp_servers)
├── cmake.lua     # cmake-tools.nvim
├── csharp.lua    # roslyn.nvim
├── flutter.lua   # flutter-tools.nvim
├── json.lua      # SchemaStore.nvim (jsonls + yamlls schemas)
├── markdown.lua  # render-markdown.nvim
└── rust.lua      # rustaceanvim + crates.nvim
```

## WHERE TO LOOK

| Language | File | Plugin |
|----------|------|--------|
| Rust | `rust.lua` | rustaceanvim + crates.nvim |
| C# | `csharp.lua` | roslyn.nvim |
| Flutter/Dart | `flutter.lua` | flutter-tools.nvim |
| CMake | `cmake.lua` | cmake-tools.nvim |
| JSON / YAML | `json.lua` | SchemaStore.nvim |
| Markdown | `markdown.lua` | render-markdown.nvim |

## CONVENTIONS

- Buffer-local keymaps for Rust (`Cargo.toml`) are registered inside a `BufRead,BufNewFile` autocmd on `Cargo.toml`.
- `crates.nvim` is a one-shot global setup (registers autocmds + completion sources). Do not re-run it from a per-buffer autocmd.
- `rustaceanvim` config lives in `vim.g.rustaceanvim` (global), not via `setup()`.
- SchemaStore.nvim provides schemas for both `jsonls` and `yamlls`; yamlls' built-in schema store is explicitly disabled in favor of SchemaStore's index.

## ANTI-PATTERNS

- **Never add these languages to `lsp_servers`** in `init.lua`. Doing so causes the plugin and native `vim.lsp.enable` to both start the same server.
- **Never call `vim.lsp.enable()` for plugin-managed servers.** The plugin handles registration.
- **Do not put buffer-local crates.nvim setup in a global autocmd.** It only needs `require("crates").setup()` once.
