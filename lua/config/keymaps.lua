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

-- map("n", "<tab>", "<cmd>e #<cr>", { desc = "jk" })
map("n", "<leader>gg", toggleFugitiveGit)
map("n", "<leader>gP", "<cmd>Dispatch git push<cr>")
map("n", "<leader>gp", "<cmd>Dispatch git pull<cr>", { desc = "Git Pull" })
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
map("n", "<leader>gl", "<cmd>DiffviewFileHistory<cr>")
map("n", "<leader><space>", "<cmd>Tags<cr>")
-- map("n", "<leader>ff", "<cmd>GFiles<cr>")
-- map("n", "<leader>fF", "<cmd>Files<cr>")
-- map("n", "<tab>", "<cmd>Telescope buffers<cr>")
-- map("n", "<leader>fr", "<cmd>History<cr>")
-- map("n", "<leader>t", "<cmd>terminal<cr>")
map("t", "<esc>", "<C-\\><C-n>", { desc = "jk", silent = true })
map({ "i", "t" }, "jk", "<esc>", { desc = "jk", silent = true })
map({ "n", "t" }, "<C-j>", "<C-d>zz", { desc = "jk", silent = true })
map({ "n", "t" }, "<C-k>", "<C-u>zz", { desc = "jk", silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape & clear highlighted search" })
map({ "n" }, "<leader>so", "<cmd>source %<cr>", { desc = "Refresh vim" })
map({ "n" }, "n", "nzzzv", { desc = "Next " })
map({ "n" }, "N", "Nzzzv", { desc = "Next " })
-- vim.keymap.set({ "n" }, "<leader>(", "ysiw(", { desc = "Next ", silent = true })

-- map("n", "j", "jzz", { desc = "jk", silent = true })
-- map("n", "k", "kzz", { desc = "jk", silent = true })
--
