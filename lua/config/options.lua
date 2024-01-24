-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options herejk
vim.g.fzf_preview_window = {}
vim.g.fzf_buffers_jump = 1
vim.g.wrap = "linebreak"
vim.cmd("let g:fzf_layout = { 'down': '40%'}")
vim.cmd("let g:python3_host_prog = expand('~/.pyenv/versions/3.8.10-local/bin/python') ")
vim.cmd("set wrap linebreak")
vim.cmd("set termguicolors")
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }

vim.opt.foldmethod = "indent"
vim.o.foldcolumn = "0" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.autoread = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.nu = true
vim.opt.relativenumber = false
vim.opt.guicursor = ""

vim.opt.smartindent = true

vim.cmd("set nofixeol")
vim.cmd("set nofixendofline")

vim.diagnostic.config({
  virtual_text = false,
})
vim.opt.sessionoptions:append("localoptions") -- Save localoptions to session file

-- Example config in Lua
--

-- Load the colorscheme
vim.cmd("let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }")
vim.schedule(function()
  vim.o.background = "dark"
  vim.cmd("set title")
  vim.cmd("set titleold=")
end)
