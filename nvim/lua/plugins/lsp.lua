-- ── Server configurations ─────────────────────────────────────────────
vim.lsp.config('bashls', {
  cmd = { 'bash-language-server', 'start' },
  filetypes = { 'bash', 'sh' },
  root_markers = { '.git' },
})

vim.lsp.config('clangd', {
  cmd = { 'clangd' },
  filetypes = { 'c', 'cpp' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
})

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.git' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      diagnostics = { globals = { 'vim' } },
      telemetry = { enable = false },
    },
  },
})

-- ── Enable the servers ────────────────────────────────────────────────
vim.lsp.enable({ 'bashls', 'clangd', 'lua_ls' })

-- ── Keymaps ───────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,     opts)
    vim.keymap.set('n', 'gD',         vim.lsp.buf.declaration,    opts)
    vim.keymap.set('n', 'K',          vim.lsp.buf.hover,          opts)
    vim.keymap.set('n', 'gi',         vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,         opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,    opts)
    vim.keymap.set('n', 'gr',         vim.lsp.buf.references,     opts)
    vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,   opts)
    vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,   opts)
    vim.keymap.set('n', '<leader>e',  vim.diagnostic.open_float,  opts)
  end,
})

-- ── Diagnostic display ────────────────────────────────────────────────
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
