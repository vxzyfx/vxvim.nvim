# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

`vxvim.nvim` is a Neovim configuration distribution (similar in spirit to LazyVim). It is consumed by adding it to a user's Neovim config and calling `require("vxvim").setup()`. There is no build system, test suite, or CI — the only "tooling" is `stylua` for Lua formatting (config in `stylua.toml`: 2-space indent, 120-col, double quotes preferred, `collapse_simple_statement = "Always"`).

## Plugin Manager

Uses Neovim 0.12+ **native** `vim.pack.add({...})` (not `lazy.nvim`, not `packer`). All plugin sources are declared as a single flat list at the top of `lua/vxvim/init.lua`. Adding a plugin = adding an entry to that list, then writing setup code in the appropriate `lua/vxvim/plugins/*.lua` file.

## LSP Wiring (Neovim 0.11+ style)

Two distinct mechanisms coexist — important to keep them straight:

1. **Top-level `lsp/<server>.lua` files** (e.g. `lsp/vtsls.lua`) — these are Neovim's native LSP config locations (loaded by name via `vim.lsp.enable("<name>")`). Return a config table.
2. **`vxvim.config.lsp_servers`** in `lua/vxvim/init.lua` — a list of server names that `lua/vxvim/plugins/lsp/init.lua` iterates over and calls `vim.lsp.enable(...)` on. The setup function dynamically swaps in `denols` vs `vtsls` based on whether `deno.json[c]` exists at the project root.
3. **Per-language plugin glue** lives under `lua/vxvim/plugins/lsp/<lang>.lua` (rust, csharp, flutter, json, markdown, cmake) — these wire up specialized plugins (rustaceanvim, roslyn.nvim, flutter-tools, SchemaStore, render-markdown, cmake-tools), which themselves manage the underlying language server. These languages are intentionally **not** in `lsp_servers` — the plugin owns the lifecycle.

When adding a new language server: prefer adding the name to `M.config.lsp_servers` and dropping a `lsp/<name>.lua` if non-default settings are needed. Only add a `lua/vxvim/plugins/lsp/<lang>.lua` file if you need a third-party plugin to manage it.

## Module Load Order

`require("vxvim").setup()` (in `lua/vxvim/init.lua`) requires modules in a deliberate order; do not reorder casually:

1. `config.options`, `config.keymaps` — must run before any plugin (sets `mapleader = " "`, etc.)
2. `plugins.colorscheme` (catppuccin) — runs early so later plugins pick up the theme
3. `plugins.coding` — completion (blink.cmp), pairs, ts-comments, lazydev, **and enables `lua_ls`**
4. `plugins.editor` — grug-far, flash, which-key, gitsigns, trouble, aerial, harpoon, refactoring
5. `plugins.ui` — edgy, snacks, bufferline, lualine, noice
6. `plugins.treesitter`, `plugins.formatting`, `plugins.linting`, `plugins.dap`, `plugins.http`, `plugins.task`
7. `plugins.lsp` — runs last; loads per-language modules then calls `vim.lsp.enable` for everything in `lsp_servers`

## Key Architectural Choices

- **`snacks.nvim` is the Swiss-army knife.** Picker, explorer, dashboard, terminal, notifier, statuscolumn, scratch, gitbrowse, lazygit, zen, indent, scope, scroll, words, bigfile, quickfile — all routed through Snacks. Most `<leader>f*`, `<leader>s*`, `<leader>g*` mappings call `Snacks.picker.*` or `Snacks.*`. Avoid adding telescope/fzf-lua/neo-tree — Snacks already covers those slots.
- **Format-on-save is unconditional** (`lua/vxvim/plugins/formatting.lua` registers a `BufWritePre` autocmd that runs `conform.format` on every buffer). Linting runs on `BufWritePost`, `BufReadPost`, `InsertLeave`.
- **Completion is `blink.cmp` with `preset = "enter"`** (Enter accepts) plus `<C-y>` to select-and-accept. Sources include a `lazydev` provider with `score_offset = 100` so Lua dev types outrank LSP.
- **Icons and `kind_filter` are centralized** in `M.config` in `lua/vxvim/init.lua` — other plugin files do `local vxvim = require("vxvim")` and read `vxvim.config.icons` (see `plugins/ui.lua` for the canonical pattern). When adding icons or per-filetype kind filters, edit the central table; do not redefine locally.
- **Test framework is `neotest`**, debug is `nvim-dap`, task runner is `overseer`. Adapters are listed explicitly in `plugins/test.lua` — adding a language requires both adding the adapter `src` to `init.lua` and registering it in `setup({ adapters = ... })`.
- **Edgy** owns docked window placement (Trouble, terminals, OverseerList, grug-far, neotest panels). When adding a windowed plugin, register its filetype with `edgy` rather than letting it open free-floating.

## Common Conventions

- All keymaps use `vim.keymap.set` (aliased to `local set =` or `local map =` at the top of each file). Always include a `desc = ...` so which-key surfaces it.
- `<leader>` groupings are declared in `plugins/editor.lua` under the `which-key` `spec` table — when adding a new top-level prefix, register it there.
- Stylua formatting is enforced project-wide for `*.lua`. Run `stylua .` before committing.

## What This Repo Is NOT

- Not a runnable application — there is no `init.lua` at the repo root. Users embed it into their own Neovim config.
- Not built on `lazy.nvim` — do not add `lazy = true`, `event = ...`, or other lazy.nvim spec keys to plugin entries.
- No tests, no CI config, no `package.json`/`Makefile`/etc.
