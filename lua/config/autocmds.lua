-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
--
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*Dockerfile*" },
  command = "set ft=Dockerfile",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yaml" },
  command = "set ft=jinja",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  pattern = { "*" },
  command = "set nofoldenable foldmethod=manual foldlevelstart=99",
})
