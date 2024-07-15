-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local function map(mode, lhs, rhs, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

local function projects()
  vim.cmd(
    -- "call fzf#run({'source': 'find ~/projects -maxdepth 1 -mindepth 1 -type d| sort -n', 'sink': 'FZF', 'down': '40%'})"
    "call fzf#run({'source': 'ls -dt ~/projects/*', 'sink': 'FZF', 'down': '40%'})"
  )
end

function bibtexx()
  vim.cmd("let $FZF_BIBTEX_SOURCES = '~/projects/bibtex.bib'")
  vim.cmd(
    -- "call fzf#run({'source': 'find ~/projects -maxdepth 1 -mindepth 1 -type d| sort -n', 'sink': 'FZF', 'down': '40%'})"
    "call fzf#run({'source': 'bibtex-ls', 'sink*': function('<sid>bibtex_cite_sink'), 'down': '40%','options': '--ansi --layout=reverse-list --multi'})"
  )
end

function fuzzyFindFiles()
  require("telescope.builtin").grep_string({
    path_display = { "smart" },
    only_sort_text = true,
    word_match = "-w",
    search = "",
  })
end

-- local Workspace = require("projections.workspace")
-- Add workspace command
-- vim.api.nvim_create_user_command("AddWorkspace", function()
-- Workspace.add(vim.loop.cwd())
-- end, {})

-- vim.keymap.set("n", "<leader>rn", ":IncRename ")
vim.keymap.set("n", "<leader>qs", function()
  require("persistence").select()
end)

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("t", "<S-tab>", "<C-n>")
vim.keymap.set("t", "<tab>", "<C-p>")
vim.keymap.set("t", "<S-j>", "<C-n>")
vim.keymap.set("t", "<S-k>", "<C-p>")
map("n", "<leader>e", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end)
map("n", "<leader>E", function()
  require("mini.files").open(vim.uv.cwd(), true)
end)
-- map("v", "J", ":m '>+1<CR>gv=gv")
-- map("v", "K", ":m '<-2<CR>gv=gv")
map("n", "<S-h>", "^")
map("n", "<S-l>", "$")
-- map(
-- "n",
-- "gr",
-- "<cmd> require('telescope.builtin').lsp_references({ trim_text = true, show_line = false, fname_width = 80 })<cr>"
-- )
map("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- map("n", "<leader>eo", "<cmd>e /Users/morzusman/.config/nvim/lua/config/keymaps.lua<cr>")

if vim.g.neovide == true then
  vim.api.nvim_set_keymap(
    "n",
    "<C-+>",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor + 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap(
    "n",
    "<C-->",
    ":lua vim.g.neovide_scale_factor = vim.g.neovide_scale_factor - 0.1<CR>",
    { silent = true }
  )
  vim.api.nvim_set_keymap("n", "<C-0>", ":lua vim.g.neovide_scale_factor = 1<CR>", { silent = true })
end

-- vim.keymap.del("n", "<leader>so")
-- map("n", "<leader>e", "<cmd>E<cr>")

-- map("n", "<tab>", "<cmd>e #<cr>", { desc = "jk" })
-- map("n", "<leader>fp", projects)
--
map("n", "<leader>ac", bibtexx)
map("n", "<leader>gg", "<cmd>vertical Git<cr>")

map("n", "<leader>gb", "<cmd>FzfLua git_branches<cr>")
map("n", "<leader>gt", "<cmd>FzfLua git_tags<cr>")
map("n", "<leader>gP", "<cmd>Git push<cr>")
map("n", "<leader>gp", "<cmd>Git pull<cr>", { desc = "Git Pull" })
map("n", "<leader>gl", "<cmd>Flogsplit<cr>", { desc = "Git log" })
map("n", "<leader>gc", "<cmd>DiffviewClose<cr>", { desc = "Close Diffview" })
map("n", "<leader>gh", "<cmd>DiffviewFileHistory<cr>")
map("n", "\\", "*")
map("n", "'", "#")
map({ "v", "n" }, "$", "g_")
map("n","<leader>db","<cmd>%bd|e#<cr>")

if vim.g.neovide then
  vim.keymap.set("v", "<D-c>", '"+y') -- Copy
  vim.keymap.set("n", "<D-v>", '"+P') -- Paste normal mode
  vim.keymap.set("v", "<D-v>", '"+P') -- Paste visual mode
  vim.keymap.set("c", "<D-v>", "<C-R>+") -- Paste command mode
  vim.keymap.set("i", "<D-v>", '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap("", "<D-v>", "+p<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("!", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<D-v>", "<C-R>+", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<D-v>", "<C-R>+", { noremap = true, silent = true })
-- map("n", "<leader>ff", "<cmd>GFiles<cr>")

-- map("n", "<leader><space>", "<cmd>Telescope find_files<cr>")
map("n", "<leader>gm", "<cmd>DiffviewOpen origin/master<cr>")
map("n", "<leader>fs", "<cmd>FzfLua grep_project<cr>")
map("n", "<leader>ff", "<cmd>FzfLua files<cr>")
map("n", "<leader><space>", "<cmd>FzfLua lsp_live_workspace_symbols<cr>")

-- map("n", "<leader>vd", function()
-- vim.diagnostic.open_float()
-- end)
map("n", "§", "<cmd>FzfLua resume<cr>")

-- map("n", "<CR>", "<cmd>lua require('harpoon.mark').add_file()<cr>")
-- map("n", "§", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>")
-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- vim.keymap.set("n", "K", function()
-- local winid = require("ufo").peekFoldedLinesUnderCursor()
-- if not winid then
-- choose one of coc.nvim and nvim lsp
-- vim.fn.CocActionAsync("definitionHover") -- coc.nvim
-- vim.lsp.buf.hover()
-- end
-- end)
map("n", "<CR>", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>")
map("n", "gd", "<cmd>FzfLua lsp_definitions<cr>")
map("n", "gr", "<cmd>FzfLua lsp_references<cr>")
map("n", "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>")
map("n", "<C-l>", "<cmd>bn<cr>")
map("n", "<C-h>", "<cmd>bp<cr>")
map("n", "<C-w><C-w>", "<cmd>bd<cr>")
-- map("n", "<leader><space>", )
-- map("n", "<leader>ff", git_ls)

-- map("n", "<leader>fr", "<cmd>History<cr>")
-- map("n", "<leader>t", "<cmd>terminal<cr>")

map("t", "<esc>", "<C-\\><C-n>", { desc = "jk", silent = true })
map({ "i", "t" }, "jk", "<esc>", { desc = "jk", silent = true })
map("n", "J", "mzJ`z", { desc = "" })

map({ "n", "t" }, "<C-j>", "<C-d>zz", { desc = "jk", silent = true })
map({ "n", "t" }, "<C-k>", "<C-u>zz", { desc = "jk", silent = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
map({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>", { desc = "Escape & clear highlighted search" })
map({ "n" }, "<leader>o", "<cmd>source %<cr><cmd>echo 'Sourced'<cr>", { desc = "Refresh vim" })
map({ "n" }, "n", "nzzzv", { desc = "Next " })
map({ "n" }, "N", "Nzzzv", { desc = "Next " })
map({ "n" }, "<D-v>", '"+p', { desc = "Next " })
map({ "i" }, "<esc><D-v>", '"+p', { desc = "Next " })

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
vim.g.gui_font_default_size = 12
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "JetBrainsMono Nerd Font"

RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function()
  vim.g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

-- Call function on startup to set default value
ResetGuiFont()

-- Keymaps

local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i" }, "<C-=>", function()
  ResizeGuiFont(1)
end, opts)
vim.keymap.set({ "n", "i" }, "<C-->", function()
  ResizeGuiFont(-1)
end, opts)
vim.keymap.set({ "n", "i" }, "<C-BS>", function()
  ResetGuiFont()
end, opts)

local autocmd = vim.api.nvim_create_autocmd

local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

autocmd("LspAttach", {
  callback = function(e)
    local opts = { buffer = e.buf }
    -- vim.keymap.set("n", "gd", function()
    -- vim.lsp.buf.definition()
    -- end, opts)
    vim.keymap.set("n", "K", function()
      vim.lsp.buf.hover()
    end, opts)
    vim.keymap.set("n", "<leader>vd", function()
      vim.diagnostic.open_float()
    end, opts)
    vim.keymap.set("n", "<leader>ca", function()
      vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>cr", function()
      vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("i", "<C-h>", function()
      vim.lsp.buf.signature_help()
    end, opts)
  end,
})
