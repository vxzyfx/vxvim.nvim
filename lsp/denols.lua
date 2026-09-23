-- https://github.com/denoland/deno
-- Deno's built-in language server.

local lsp = vim.lsp

local function virtual_text_document_handler(uri, res, client)
  if not res then return nil end

  local lines = vim.split(res.result, "\n")
  local bufnr = vim.uri_to_bufnr(uri)

  local current_buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  if #current_buf ~= 0 then return nil end

  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.api.nvim_set_option_value("readonly", true, { buf = bufnr })
  vim.api.nvim_set_option_value("modified", false, { buf = bufnr })
  vim.api.nvim_set_option_value("modifiable", false, { buf = bufnr })
  lsp.buf_attach_client(bufnr, client.id)
end

local function virtual_text_document(uri, client)
  local params = {
    textDocument = {
      uri = uri,
    },
  }
  local result = client:request_sync("deno/virtualTextDocument", params)
  virtual_text_document_handler(uri, result, client)
end

local function denols_handler(err, result, ctx, config)
  if not result or vim.tbl_isempty(result) then return nil end

  local client = vim.lsp.get_client_by_id(ctx.client_id)
  for _, res in pairs(result) do
    local uri = res.uri or res.targetUri
    if uri:match("^deno:") then
      virtual_text_document(uri, client)
      res["uri"] = uri
      res["targetUri"] = uri
    end
  end

  lsp.handlers[ctx.method](err, result, ctx, config)
end

---@type vim.lsp.Config
return {
  cmd = { "deno", "lsp" },
  cmd_env = { NO_COLOR = true },
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(bufnr, on_dir)
    -- Only attach to Deno projects: prefer the nearest deno.json(c)/deno.lock over
    -- the nearest package manager lockfile, so Deno modules inside a mostly-Node
    -- monorepo still attach while plain Node files do not.
    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local deno_lock_root = vim.fs.root(bufnr, { "deno.lock" })
    local project_root = vim.fs.root(bufnr, { { "deno.lock", "deno.json", "deno.jsonc" }, { ".git" } })
    if
      (deno_lock_root and (not project_root or #deno_lock_root > #project_root))
      or (deno_root and (not project_root or #deno_root >= #project_root))
    then
      on_dir(project_root or deno_lock_root or deno_root)
    end
  end,
  settings = {
    deno = {
      enable = true,
      suggest = {
        imports = {
          hosts = {
            ["https://deno.land"] = true,
          },
        },
      },
    },
  },
  handlers = {
    ["textDocument/definition"] = denols_handler,
    ["textDocument/typeDefinition"] = denols_handler,
    ["textDocument/references"] = denols_handler,
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "LspDenolsCache", function()
      client:exec_cmd({
        title = "DenolsCache",
        command = "deno.cache",
        arguments = { {}, vim.uri_from_bufnr(bufnr) },
      }, { bufnr = bufnr }, function(err, _, ctx)
        if err then
          local uri = ctx.params.arguments[2]
          vim.notify("cache command failed for" .. vim.uri_to_fname(uri), vim.log.levels.ERROR)
        end
      end)
    end, {
      desc = "Cache a module and all of its dependencies.",
    })
  end,
}
