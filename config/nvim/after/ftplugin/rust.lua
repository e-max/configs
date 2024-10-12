local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<leader>a', function()
  vim.cmd.RustLsp 'codeAction' -- supports rust-analyzer's grouping
  -- or vim.lsp.buf.codeAction() if you don't want grouping.
end, { silent = true, buffer = bufnr, desc = 'Advanced Code Action' })

vim.keymap.set('n', 'gP', function()
  vim.cmd.RustLsp 'openCargo'
end, { silent = true, buffer = bufnr, desc = 'Go to Cargo.toml' })

vim.keymap.set('n', 'gp', function()
  vim.cmd.RustLsp 'parentModule'
end, { silent = true, buffer = bufnr, desc = 'Go to [P]arent module' })
