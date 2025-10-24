vim.pack.add({
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  { src = "https://github.com/folke/flash.nvim" },
  { src = "https://github.com/folke/which-key.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/folke/trouble.nvim" },
  { src = "https://github.com/folke/todo-comments.nvim" },
  { src = "https://github.com/stevearc/aerial.nvim" },
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  { src = "https://github.com/ThePrimeagen/refactoring.nvim" },
})

local set = vim.keymap.set

set({ "n", "v" }, "<leader>sr", function()
  local grug = require("grug-far")
  local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= "" and "*." .. ext or nil,
    },
  })
end, {
  desc = "Search and Replace",
})

require("grug-far").setup({
  headerMaxWidth = 80,
})
require("flash").setup({})

set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })

set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })

set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })

set({ "x", "o" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })

set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

require("which-key").setup({
  preset = "helix",
  defaults = {},
  spec = {
    {
      mode = { "n", "v" },
      { "<leader><tab>", group = "tabs" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>dp", group = "profiler" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>o", group = "overseer" },
      { "<leader>q", group = "quit/session" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
      { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      {
        "<leader>b",
        group = "buffer",
        expand = function() return require("which-key.extras").expand.buf() end,
      },
      {
        "<leader>w",
        group = "windows",
        proxy = "<c-w>",
        expand = function() return require("which-key.extras").expand.win() end,
      },
      -- better descriptions
      { "gx", desc = "Open with system app" },
    },
  },
})

vim.keymap.set("n", "<leader>?", function() require("which-key").show({ global = false }) end, {
  desc = "Buffer Local Keymaps (which-key)",
})

require("gitsigns").setup({
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  signs_staged = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
  },
  on_attach = function(buffer)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc }) end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
  end,
})

require("trouble").setup({
  modes = {
    lsp = {
      win = { position = "right" },
    },
  },
})

set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", { desc = "Buffer Diagnostics (Trouble)" })
set("n", "<leader>cS", "<cmd>Trouble lsp toggle<cr>", { desc = "LSP references/definitions/... (Trouble)" })
set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

set("n", "[q", function()
  if require("trouble").is_open() then
    require("trouble").prev({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cprev)
    if not ok then vim.notify(err, vim.log.levels.ERROR) end
  end
end, { desc = "Previous Trouble/Quickfix Item" })
set("n", "]q", function()
  if require("trouble").is_open() then
    require("trouble").next({ skip_groups = true, jump = true })
  else
    local ok, err = pcall(vim.cmd.cnext)
    if not ok then vim.notify(err, vim.log.levels.ERROR) end
  end
end, { desc = "Next Trouble/Quickfix Item" })

require("todo-comments").setup({})

set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next Todo Comment" })
set("n", "[t", function() require("todo-comments").jump_next() end, { desc = "Previous Todo Comment" })
set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })
set(
  "n",
  "<leader>xT",
  "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
  { desc = "Todo/Fix/Fixme (Trouble)" }
)
set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })
set("n", "<leader>sT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<<cr>", { desc = "Todo/Fix/Fixme" })

require("aerial").setup({
  attach_mode = "global",
  backends = { "lsp", "treesitter", "markdown", "man" },
  show_guides = true,
  layout = {
    resize_to_content = false,
    win_opts = {
      winhl = "Normal:NormalFloat,FloatBorder:NormalFloat,SignColumn:SignColumnSB",
      signcolumn = "yes",
      statuscolumn = " ",
    },
  },
  guides = {
    mid_item = "├╴",
    last_item = "└╴",
    nested_top = "│ ",
    whitespace = "  ",
  },
})

set("n", "<leader>cs", "<cmd>AerialToggle<cr>", { desc = "Aerial (Symbols)" })

require("harpoon").setup({
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  settings = {
    save_on_toggle = true,
  },
})
set("n", "<leader>H", function() require("harpoon"):list():add() end, { desc = "Harpoon File" })

set("n", "<leader>h", function()
  local harpoon = require("harpoon")
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon Quick Menu" })

set("n", "<leader>1", function() require("harpoon"):list():select(1) end, { desc = "Harpoon to File 1" })
set("n", "<leader>2", function() require("harpoon"):list():select(2) end, { desc = "Harpoon to File 2" })
set("n", "<leader>3", function() require("harpoon"):list():select(3) end, { desc = "Harpoon to File 3" })
set("n", "<leader>4", function() require("harpoon"):list():select(4) end, { desc = "Harpoon to File 4" })
set("n", "<leader>5", function() require("harpoon"):list():select(5) end, { desc = "Harpoon to File 5" })

require("refactoring").setup({
  prompt_func_return_type = {
    go = false,
    java = false,
    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },
  prompt_func_param_type = {
    go = false,
    java = false,
    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },
  printf_statements = {},
  print_var_statements = {},
  show_success_message = true,
})

set({ "n", "v" }, "<leader>r", "", { desc = "+refactor" })
set("v", "<leader>rs", function() require("refactoring").select_refactor() end, { desc = "Refactor", expr = true })
set(
  { "n", "v" },
  "<leader>ri",
  function() require("refactoring").refactor("Inline Variable") end,
  { desc = "Inline Variable", expr = true }
)
set(
  "n",
  "<leader>rb",
  function() require("refactoring").refactor("Extract Block") end,
  { desc = "Extract Block", expr = true }
)
set(
  "n",
  "<leader>rf",
  function() require("refactoring").refactor("Extract Block To File") end,
  { desc = "Extract Block To File", expr = true }
)
set("n", "<leader>rP", function() require("refactoring").debug.printf({ below = false }) end, { desc = "Debug Print" })
set("n", "<leader>rc", function() require("refactoring").debug.cleanup({}) end, { desc = "Debug Cleanup" })
set(
  "v",
  "<leader>rf",
  function() require("refactoring").refactor("Extract Function") end,
  { desc = "Extract Function", expr = true }
)
set(
  "v",
  "<leader>rF",
  function() require("refactoring").refactor("Extract Function To File") end,
  { desc = "Extract Function To File", expr = true }
)
set(
  "v",
  "<leader>rx",
  function() require("refactoring").refactor("Extract Variable") end,
  { desc = "Extract Variable", expr = true }
)
set(
  { "n", "v" },
  "<leader>rp",
  function() require("refactoring").debug.print_var() end,
  { desc = "Debug Print Variable" }
)
