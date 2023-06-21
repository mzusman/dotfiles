-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  ---@cast keys LazyKeysHandler
  -- do not create the keymap if a lazy keys handler exists
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local function showFugitiveGit()
  if vim.fn.FugitiveHead() ~= "" then
    vim.cmd([[
    Git
    " wincmd H  " Open Git window in vertical split
    " setlocal winfixwidth
    " vertical resize 31
    " setlocal winfixwidth
    setlocal nonumber
    setlocal norelativenumber
    ]])
  end
end
local function toggleFugitiveGit()
  if vim.fn.buflisted(vim.fn.bufname("fugitive:///*/.git//$")) ~= 0 then
    vim.cmd([[ execute ":bdelete" bufname('fugitive:///*/.git//$') ]])
  else
    showFugitiveGit()
  end
end

function fuzzyFindFiles()
  require("telescope.builtin").grep_string({
    path_display = { "smart" },
    only_sort_text = true,
    word_match = "-w",
    search = "",
  })
end

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("t", "<S-tab>", "<C-n>")
vim.keymap.set("t", "<tab>", "<C-p>")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
map("n", "<leader>eo", "<cmd>e /Users/morzusman/.config/nvim/lua/config/keymaps.lua<cr>")
-- vim.keymap.del("n", "<leader>so")
-- map("n", "<leader>so", "<cmd>source %<cr>")

-- map("n", "<tab>", "<cmd>e #<cr>", { desc = "jk" })
map("n", "<leader>gg", toggleFugitiveGit)
map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>")
map("n", "<leader>gP", "<cmd>Dispatch git push<cr>")
map("n", "<leader>gp", "<cmd>Dispatch git pull<cr>", { desc = "Git Pull" })
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>")
map("n", "<leader>fs", "<cmd>RG<cr>")
-- map("n", "<leader>ff", "<cmd>GFiles<cr>")
-- map("n", "<leader>fF", "<cmd>Files<cr>")
map("n", "<tab>", "<cmd>Buffers<cr>")
map("n", "<space><space>", "<cmd>GFiles<cr>")

-- map("n", "<leader>fr", "<cmd>History<cr>")
-- map("n", "<leader>t", "<cmd>terminal<cr>")
map("t", "<esc>", "<C-\\><C-n>", { desc = "jk", silent = true })
map({ "i", "t" }, "jk", "<esc>", { desc = "jk", silent = true })
map({ "n", "t" }, "<C-j>", "<C-d>zz", { desc = "jk", silent = true })
map({ "n", "t" }, "<C-k>", "<C-u>zz", { desc = "jk", silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape & clear highlighted search" })
map({ "n" }, "<leader>o", "<cmd>source %<cr><cmd>echo 'Sourced'<cr>", { desc = "Refresh vim" })
map({ "n" }, "n", "nzzzv", { desc = "Next " })
map({ "n" }, "N", "Nzzzv", { desc = "Next " })
map("n", "<C-f>", "<cmd>silent !tmux neww sh ~/.config/nvim/configs/tmux-sessionizer<CR>")

-- Don't yank on delete char
map("v", "p", '"_dP', { silent = true })
map("n", "<Leader>pr", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", { silent = true })
map("v", "<Leader>pr", "<cmd>lua require('spectre').open_visual()<CR>")
map("n", "vv", "0v$", { silent = true })
map("v", "j", "jzz", { silent = true })
map("v", "k", "kzz", { silent = true })

vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
-- map("n", "j", "jzz", { desc = "jk", silent = true })
-- map("n", "k", "kzz", { desc = "jk", silent = true })
--
--
