local set = vim.keymap.set
local vxvim = require("vxvim")
local icons = vxvim.config.icons

local function term_nav(dir)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function() vim.cmd.wincmd(dir) end)
  end
end

require("edgy").setup((function()
  local opts = {
    bottom = {
      {
        ft = "toggleterm",
        size = { height = 0.4 },
        filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
      },
      {
        ft = "noice",
        size = { height = 0.4 },
        filter = function(_, win) return vim.api.nvim_win_get_config(win).relative == "" end,
      },
      "Trouble",
      { ft = "qf", title = "QuickFix" },
      {
        ft = "help",
        size = { height = 20 },
        -- don't open help files in edgy that we're editing
        filter = function(buf) return vim.bo[buf].buftype == "help" end,
      },
      { title = "Spectre", ft = "spectre_panel", size = { height = 0.4 } },
      { title = "Neotest Output", ft = "neotest-output-panel", size = { height = 15 } },
    },
    left = {
      { title = "Neotest Summary", ft = "neotest-summary" },
      -- "neo-tree",
    },
    right = {
      { title = "Grug Far", ft = "grug-far", size = { width = 0.4 } },
      {
        title = "Overseer",
        ft = "OverseerList",
        open = function() require("overseer").open() end,
      },
    },
    keys = {
      -- increase width
      ["<c-Right>"] = function(win) win:resize("width", 2) end,
      -- decrease width
      ["<c-Left>"] = function(win) win:resize("width", -2) end,
      -- increase height
      ["<c-Up>"] = function(win) win:resize("height", 2) end,
      -- decrease height
      ["<c-Down>"] = function(win) win:resize("height", -2) end,
    },
  }

  -- trouble
  for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
    opts[pos] = opts[pos] or {}
    table.insert(opts[pos], {
      ft = "trouble",
      filter = function(_, win)
        return vim.w[win].trouble
          and vim.w[win].trouble.position == pos
          and vim.w[win].trouble.type == "split"
          and vim.w[win].trouble.relative == "editor"
          and not vim.w[win].trouble_preview
      end,
    })
  end

  -- snacks terminal
  for _, pos in ipairs({ "top", "bottom", "left", "right" }) do
    opts[pos] = opts[pos] or {}
    table.insert(opts[pos], {
      ft = "snacks_terminal",
      size = { height = 0.4 },
      title = "%{b:snacks_terminal.id}: %{b:term_title}",
      filter = function(_, win)
        return vim.w[win].snacks_win
          and vim.w[win].snacks_win.position == pos
          and vim.w[win].snacks_win.relative == "editor"
          and not vim.w[win].trouble_preview
      end,
    })
  end
  return opts
end)())

set("n", "<leader>ue", function() require("edgy").toggle() end, { desc = "Edgy Toggle" })

set("n", "<leader>uE", function() require("edgy").select() end, { desc = "Edgy Select Window" })

require("snacks").setup({
  image = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  toggle = {},
  words = { enabled = true },
  explorer = { enabled = true },
  bigfile = { enabled = true },
  quickfile = { enabled = true },
  terminal = {
    win = {
      keys = {
        nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
        nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
        nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
        nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
      },
    },
  },
  picker = {
    win = {
      input = {
        keys = {
          ["<a-c>"] = {
            "toggle_cwd",
            mode = { "n", "i" },
          },
        },
      },
    },
    actions = {
      ---@param p snacks.Picker
      toggle_cwd = function(p)
        local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
        p:set_cwd(cwd)
        p:find()
      end,
    },
  },
  dashboard = {
    preset = {
      header = [[
          ██╗   ██╗██╗  ██╗██╗   ██╗██╗███╗   ███╗
          ██║   ██║╚██╗██╔╝██║   ██║██║████╗ ████║
          ██║   ██║ ╚███╔╝ ██║   ██║██║██╔████╔██║
          ╚██╗ ██╔╝ ██╔██╗ ╚██╗ ██╔╝██║██║╚██╔╝██║
           ╚████╔╝ ██╔╝ ██╗ ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚═══╝  ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
   ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "p", desc = "Projects", action = ":lua Snacks.picker.projects()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
    },
    sections = {
      { section = "header" },
      { section = "keys", gap = 1, padding = 1 },
    },
  },
})

-- Top Pickers & Explorer
set("n", "<leader><space>", function() Snacks.picker.smart() end, {
  desc = "Smart Find Files",
})

set("n", "<leader>,", function() Snacks.picker.buffers() end, {
  desc = "Buffers",
})

set("n", "<leader>/", function() Snacks.picker.grep() end, {
  desc = "Grep",
})

set("n", "<leader>:", function() Snacks.picker.command_history() end, {
  desc = "Command History",
})
set("n", "<leader>n", function() Snacks.notifier.show_history() end, {
  desc = "Notification History",
})

set("n", "<leader>e", function() Snacks.explorer() end, {
  desc = "Explorer Snacks",
})

-- find
set("n", "<leader>fb", function() Snacks.picker.buffers() end, {
  desc = "Buffers",
})

set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, {
  desc = "Find Config File",
})

set("n", "<leader>ff", function() Snacks.picker.files() end, {
  desc = "Find Files",
})

set("n", "<leader>fg", function() Snacks.picker.git_files() end, {
  desc = "Find Git Files",
})

set("n", "<leader>fp", function() Snacks.picker.projects() end, {
  desc = "Projects",
})

set("n", "<leader>fr", function() Snacks.picker.recent() end, {
  desc = "Recent",
})

-- git
set("n", "<leader>gb", function() Snacks.picker.git_branches() end, {
  desc = "Git Branches",
})

set({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })

set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })

set("n", "<leader>gl", function() Snacks.picker.git_log() end, {
  desc = "Git Log",
})

set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, {
  desc = "Git Log Line",
})

set("n", "<leader>gs", function() Snacks.picker.git_status() end, {
  desc = "Git Status",
})

set("n", "<leader>gS", function() Snacks.picker.git_stash() end, {
  desc = "Git Stash",
})

set("n", "<leader>gd", function() Snacks.picker.git_diff() end, {
  desc = "Git Diff (hunks)",
})

set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, {
  desc = "Git Log File",
})

set({ "n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })

-- Grep
set("n", "<leader>sb", function() Snacks.picker.lines() end, {
  desc = "Buffer Lines",
})

set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, {
  desc = "Grep Open Buffers",
})

set("n", "<leader>sg", function() Snacks.picker.grep() end, {
  desc = "Grep",
})

set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, {
  desc = "Visual selection or word",
})

-- search
set("n", '<leader>s"', function() Snacks.picker.registers() end, {
  desc = "Registers",
})

set("n", "<leader>s/", function() Snacks.picker.search_history() end, {
  desc = "Search History",
})

set("n", "<leader>sa", function() Snacks.picker.autocmds() end, {
  desc = "Autocmds",
})

set("n", "<leader>sc", function() Snacks.picker.command_history() end, {
  desc = "Command History",
})

set("n", "<leader>sC", function() Snacks.picker.commands() end, {
  desc = "Commands",
})

set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, {
  desc = "Diagnostics",
})

set("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, {
  desc = "Buffer Diagnostics",
})

set("n", "<leader>sh", function() Snacks.picker.help() end, {
  desc = "Help Pages",
})

set("n", "<leader>sH", function() Snacks.picker.highlights() end, {
  desc = "Highlights",
})

set("n", "<leader>si", function() Snacks.picker.icons() end, {
  desc = "Icons",
})

set("n", "<leader>sj", function() Snacks.picker.jumps() end, {
  desc = "Jumps",
})

set("n", "<leader>sk", function() Snacks.picker.keymaps() end, {
  desc = "Keymaps",
})

set("n", "<leader>sl", function() Snacks.picker.loclist() end, {
  desc = "Location List",
})

set("n", "<leader>sm", function() Snacks.picker.marks() end, {
  desc = "Marks",
})

set("n", "<leader>sM", function() Snacks.picker.man() end, {
  desc = "Man Pages",
})

set("n", "<leader>sR", function() Snacks.picker.resume() end, {
  desc = "Resume",
})

set("n", "<leader>sq", function() Snacks.picker.qflist() end, {
  desc = "Quickfix List",
})

set("n", "<leader>su", function() Snacks.picker.undo() end, {
  desc = "Undotree",
})

set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, {
  desc = "Colorschemes",
})

-- LSP
set("n", "gd", function() Snacks.picker.lsp_definitions() end, {
  desc = "Goto Definition",
})

set("n", "gD", function() Snacks.picker.lsp_declarations() end, {
  desc = "Goto Declaration",
})

set("n", "gr", function() Snacks.picker.lsp_references() end, {
  nowait = true,
  desc = "References",
})

set("n", "gI", function() Snacks.picker.lsp_implementations() end, {
  desc = "Goto Implementation",
})

set("n", "gy", function() Snacks.picker.lsp_type_definitions() end, {
  desc = "Goto T[y]pe Definition",
})

set("n", "gai", function() Snacks.picker.lsp_incoming_calls() end, {
  desc = "C[a]lls Incoming",
})

set("n", "gao", function() Snacks.picker.lsp_outgoing_calls() end, {
  desc = "C[a]lls Outgoing",
})

set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, {
  desc = "LSP Symbols",
})

set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, {
  desc = "LSP Workspace Symbols",
})

-- Other
set("n", "<leader>z", function() Snacks.zen() end, {
  desc = "Toggle Zen Mode",
})

set("n", "<leader>Z", function() Snacks.zen.zoom() end, {
  desc = "Toggle Zoom",
})

set("n", "<leader>.", function() Snacks.scratch() end, {
  desc = "Toggle Scratch Buffer",
})

set("n", "<leader>S", function() Snacks.scratch.select() end, {
  desc = "Select Scratch Buffer",
})

set("n", "<leader>cR", function() Snacks.rename.rename_file() end, {
  desc = "Rename File",
})

set("n", "<leader>un", function() Snacks.notifier.hide() end, {
  desc = "Dismiss All Notifications",
})

set("n", "<leader>dps", function() Snacks.profiler.scratch() end, {
  desc = "Profiler Scratch Buffer",
})

set("n", "<c-/>", function() Snacks.terminal() end, {
  desc = "Toggle Terminal",
})

set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, {
  desc = "Next Reference",
})

set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, {
  desc = "Prev Reference",
})

-- toggle options
Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
Snacks.toggle.diagnostics():map("<leader>ud")
Snacks.toggle.line_number():map("<leader>ul")
Snacks.toggle
  .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, name = "Conceal Level" })
  :map("<leader>uc")
Snacks.toggle
  .option("showtabline", { off = 0, on = vim.o.showtabline > 0 and vim.o.showtabline or 2, name = "Tabline" })
  :map("<leader>uA")
Snacks.toggle.treesitter():map("<leader>uT")
Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
Snacks.toggle.dim():map("<leader>uD")
Snacks.toggle.animate():map("<leader>ua")
Snacks.toggle.indent():map("<leader>ug")
Snacks.toggle.scroll():map("<leader>uS")
Snacks.toggle.profiler():map("<leader>dpp")
Snacks.toggle.profiler_highlights():map("<leader>dph")
Snacks.toggle.zoom():map("<leader>wm"):map("<leader>uZ")
Snacks.toggle.zen():map("<leader>uz")

if vim.lsp.inlay_hint then Snacks.toggle.inlay_hints():map("<leader>uh") end

require("bufferline").setup({
  highlights = require("catppuccin.special.bufferline").get_theme(),
  options = {
    close_command = function(n) Snacks.bufdelete(n) end,
    right_mouse_command = function(n) Snacks.bufdelete(n) end,
    diagnostics = "nvim_lsp",
    always_show_bufferline = false,
    diagnostics_indicator = function(_, _, diag)
      local ret = (diag.error and icons.diagnostics.Error .. diag.error .. " " or "")
        .. (diag.warning and icons.diagnostics.Warn .. diag.warning or "")
      return vim.trim(ret)
    end,
    offsets = {
      {
        filetype = "snacks_layout_box",
        text = "󰙅  File Explorer",
        separator = true,
      },
    },
    get_element_icon = function(opts) return icons.ft[opts.filetype] end,
  },
})

vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
  callback = function()
    vim.schedule(function() pcall(nvim_bufferline) end)
  end,
})

set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle Pin" })
set("n", "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", { desc = "Delete Non-Pinned Buffers" })
set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Delete Buffers to the Right" })
set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Delete Buffers to the Left" })
set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffe" })
set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Buffer" })
set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Buffer" })
set("n", "[B", "<cmd>BufferLineMovePrev<cr>", { desc = "Move buffer prev" })
set("n", "]B", "<cmd>BufferLineMoveNext<cr>", { desc = "Move buffer next" })

require("lualine").setup({
  options = {
    theme = "catppuccin",
    globalstatus = vim.o.laststatus == 3,
    disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },

    lualine_c = {
      {
        "diagnostics",
        symbols = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          hint = icons.diagnostics.Hint,
        },
      },
      { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
      {
        "aerial",
        sep = " ", -- separator between symbols
        sep_icon = "", -- separator between icon and symbol

        -- The number of symbols to render top-down. In order to render only 'N' last
        -- symbols, negative numbers may be supplied. For instance, 'depth = -1' can
        -- be used in order to render only current symbol.
        depth = 5,

        -- When 'dense' mode is on, icons are not rendered near their symbols. Only
        -- a single icon that represents the kind of current symbol is rendered at
        -- the beginning of status line.
        dense = false,

        -- The separator to be used to separate symbols in dense mode.
        dense_sep = ".",

        -- Color the symbol icons.
        colored = true,
      },
    },
    lualine_x = {
      Snacks.profiler.status(),
      "overseer",
            -- stylua: ignore
            -- {
            --   function() return require("noice").api.status.command.get() end,
            --   cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
            --   color = function() return { fg = Snacks.util.color("Statement") } end,
            -- },
            -- -- stylua: ignore
            -- {
            --   function() return require("noice").api.status.mode.get() end,
            --   cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
            --   color = function() return { fg = Snacks.util.color("Constant") } end,
            -- },
            -- -- stylua: ignore
            -- {
            --   function() return "  " .. require("dap").status() end,
            --   cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
            --   color = function() return { fg = Snacks.util.color("Debug") } end,
            -- },
            -- -- stylua: ignore
            -- {
            --   require("lazy.status").updates,
            --   cond = require("lazy.status").has_updates,
            --   color = function() return { fg = Snacks.util.color("Special") } end,
            -- },
			{
				"diff",
				symbols = {
					added = icons.git.added,
					modified = icons.git.modified,
					removed = icons.git.removed,
				},
				source = function()
					local gitsigns = vim.b.gitsigns_status_dict
					if gitsigns then
						return {
							added = gitsigns.added,
							modified = gitsigns.changed,
							removed = gitsigns.removed,
						}
					end
				end,
			},
    },
    lualine_y = {
      { "progress", separator = " ", padding = { left = 1, right = 0 } },
      { "location", padding = { left = 0, right = 1 } },
    },
    lualine_z = {
      function() return " " .. os.date("%R") end,
    },
  },
  extensions = {},
})

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
})

set("n", "<leader>sn", "", { desc = "+noice" })

set("c", "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, { desc = "Redirect Cmdline" })

set("n", "<leader>snl", function() require("noice").cmd("last") end, { desc = "Noice Last Message" })

set("n", "<leader>snh", function() require("noice").cmd("history") end, { desc = "Noice History" })

set("n", "<leader>sna", function() require("noice").cmd("all") end, { desc = "Noice All" })

set("n", "<leader>snd", function() require("noice").cmd("dismiss") end, { desc = "Dismiss All" })

set("n", "<leader>snt", function() require("noice").cmd("pick") end, { desc = "Noice Picker (Telescope/FzfLua)" })

set({ "i", "n", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(4) then return "<c-f>" end
end, { silent = true, expr = true, desc = "Scroll Forward" })

set({ "i", "n", "s" }, "<c-b>", function()
  if not require("noice.lsp").scroll(-4) then return "<c-b>" end
end, { silent = true, expr = true, desc = "Scroll Backward" })
