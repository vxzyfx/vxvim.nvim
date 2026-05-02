# PROJECT KNOWLEDGE BASE

**Generated:** 2026-05-03
**Commit:** 599c143
**Branch:** main

## OVERVIEW

`vxvim.nvim` is a Neovim configuration distribution (LazyVim-style) consumed by calling `require("vxvim").setup()`. Uses Neovim 0.12+ native `vim.pack.add()` (not lazy.nvim). No build system, tests, or CI — only `stylua` for formatting.

## STRUCTURE

```
.
├── after/
│   ├── ftplugin/       # filetype-specific overrides (e.g. http.lua)
│   └── queries/        # treesitter query tweaks
├── lsp/                # native Neovim LSP configs (loaded by vim.lsp.enable)
├── lua/vxvim/
│   ├── config/
│   │   ├── options.lua # vim.opt, leader, clipboard, etc.
│   │   └── keymaps.lua # generic keymaps (buffers, windows, diagnostics, tabs)
│   ├── init.lua        # entry point: plugin list, icons, kind_filter, lsp_servers
│   └── plugins/        # plugin setup files (one per category)
│       ├── colorscheme.lua
│       ├── coding.lua      # blink.cmp, mini.pairs, lazydev
│       ├── dap.lua
│       ├── editor.lua      # grug-far, flash, which-key, gitsigns, trouble, aerial, harpoon, refactoring
│       ├── formatting.lua  # conform.nvim + unconditional format-on-save
│       ├── http.lua
│       ├── linting.lua
│       ├── lsp/            # plugin-managed language server glue
│       ├── task.lua        # overseer
│       ├── test.lua        # neotest adapters
│       ├── treesitter.lua
│       └── ui.lua          # edgy, snacks, bufferline, lualine, noice
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Add a plugin | `init.lua` (vim.pack.add list) + `plugins/<category>.lua` | Flat list at top of init.lua |
| Add native LSP | `lsp/<name>.lua` + `init.lua` `lsp_servers` list | Loaded via `vim.lsp.enable` |
| Add plugin-managed LSP | `plugins/lsp/<lang>.lua` | e.g. rust, csharp, flutter |
| Change icons / kind_filter | `init.lua` `vxvim.config` | Centralized; do not redefine locally |
| Add keymaps | `config/keymaps.lua` or per-plugin file | Always use `desc = "..."` |
| Register `<leader>` group | `plugins/editor.lua` which-key `spec` | |
| Format config | `plugins/formatting.lua` | Unconditional format-on-save |
| Lint config | `plugins/linting.lua` | Runs on BufWritePost, BufReadPost, InsertLeave |
| DAP config | `plugins/dap.lua` | Auto-opens/closes dap-ui on session events |
| Test adapters | `plugins/test.lua` | Static vs callable adapter pattern (see inline comments) |

## CONVENTIONS

- **Formatting:** `stylua.toml` enforces 2-space indent, 120-col, double quotes, `collapse_simple_statement = "Always"`. Run `stylua .` before committing.
- **Keymaps:** All use `vim.keymap.set` aliased to `local set` or `local map` at file top. Always include `desc = "..."` for which-key.
- **Icons:** Read from `local vxvim = require("vxvim")` then `vxvim.config.icons`. Never redefine locally.
- **Module load order** (in `init.lua` `setup()`) is deliberate — do not reorder casually. `config.options` and `config.keymaps` must run before any plugin.

## ANTI-PATTERNS (THIS PROJECT)

- **No lazy.nvim spec keys.** Do not add `lazy = true`, `event = ...`, `ft = ...`, etc. This is native `vim.pack.add`, not lazy.nvim.
- **No telescope / fzf-lua / neo-tree.** Snacks.nvim already covers pickers, explorer, and git. Do not add alternatives.
- **Do not add plugin-managed languages to `lsp_servers`.** Rust, C#, Flutter, CMake, JSON/YAML (SchemaStore), Markdown are handled by plugins in `plugins/lsp/`. Adding them to `lsp_servers` would cause double startup.
- **Do not disable format-on-save conditionally.** The autocmd in `plugins/formatting.lua` is unconditional (`pattern = "*"`).
- **Do not put an `init.lua` at repo root.** This is a library, not a standalone application.

## UNIQUE STYLES

- **`snacks.nvim` as Swiss-army knife.** Picker, explorer, dashboard, terminal, notifier, statuscolumn, scratch, gitbrowse, lazygit, zen, indent, scope, scroll, words, bigfile, quickfile — all routed through Snacks.
- **`edgy` owns docked windows.** Trouble, terminals, OverseerList, grug-far, neotest panels are registered with edgy. Do not let these plugins open free-floating.
- **Completion:** `blink.cmp` with `preset = "enter"` (Enter accepts) and `<C-y>` for select-and-accept. `lazydev` source has `score_offset = 100` so Lua dev types outrank LSP.
- **Deno vs vtsls swap:** `init.lua` dynamically inserts `denols` (if `deno.json[c]` exists) or `vtsls` into `lsp_servers` at runtime.

## COMMANDS

```bash
stylua .   # format all Lua files before committing
```

## NOTES

- `vim.pack.add` downloads/plugins are not pinned to lockfiles; versions are specified inline with `version = ...` where needed.
- Some neotest adapters are commented out (`neotest-java`, `neotest-kotlin`) — enable by uncommenting in `plugins/test.lua` and adding the `src` to `init.lua`'s `vim.pack.add` list.
