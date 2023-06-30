-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options herejk
vim.o.background = "dark"
vim.g.fzf_preview_window = {}
vim.g.fzf_buffers_jump = 1
vim.g.wrap = "linebreak"
vim.cmd("let g:fzf_layout = { 'down': '40%'}")
vim.cmd("let g:python3_host_prog = expand('~/.pyenv/versions/3.8.10-local/bin/python') ")
vim.cmd("set wrap linebreak")
vim.cmd("set termguicolors")
vim.diagnostic.config({
  virtual_text = false,
})
-- Example config in Lua
vim.g.gruvbox_baby_background_color = "mid"
vim.g.gruvbox_baby_function_style = "NONE"
vim.g.gruvbox_baby_keyword_style = "italic"

vim.g.gruvbox_baby_use_original_palette = 1

-- Load the colorscheme
-- vim.cmd("let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }")
-- vim.o.background = "light" -- or "light" for light mode
