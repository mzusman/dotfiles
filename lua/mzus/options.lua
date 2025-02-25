-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options herejk
vim.g.fzf_preview_window = {}
vim.g.fzf_buffers_jump = 1
vim.opt.wrap = true
vim.cmd("let g:fzf_layout = { 'down': '40%'}")
vim.cmd("let g:bibtexcite_bibfile = expand('~/projects/bibtex.bib')")
vim.cmd("let g:python3_host_prog = expand('~/.pyenv/versions/3.8.10-local/bin/python') ")
vim.cmd("set termguicolors")
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }
vim.diagnostic.config({
  underline = {
    severity = { min = vim.diagnostic.severity.ERROR },
  },
})
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
-- vim.opt.guicursor = ""
vim.opt.smartindent = true

vim.cmd("set nofixeol")
vim.cmd("set nofixendofline")

-- vim.g.neovide_cursor_vfx_mode = "sonicboom"
vim.opt.linespace = 0
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_scroll_animation_length = 0.1
vim.g.neovide_position_animation_length = 0.05

-- default list of bibfiles
-- can be overriden by changing vim.b.bibfiles inside buffer
local default_bibfiles = { "/Users/morzusman/projects/bibtex.bib" }

-- default cache directory
-- uses neovim's stdpath to set up a cache - no need to fiddle with this
local cachedir = vim.fn.stdpath("state") .. "/fzf-bibtex/"

-- actions
local pandoc = function(selected, opts)
  local result = vim.fn.system("bibtex-cite", selected)
  vim.api.nvim_put({ result }, "c", false, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local citet = function(selected, opts)
  local result = vim.fn.system('bibtex-cite -prefix="\\cite{" -postfix="}" -separator=","', selected)
  vim.api.nvim_put({ result }, "c", false, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local citep = function(selected, opts)
  local result = vim.fn.system('bibtex-cite -prefix="\\citep{" -postfix="}" -separator=","', selected)
  vim.api.nvim_put({ result }, "c", false, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local markdown_print = function(selected, opts)
  local result =
    vim.fn.system("bibtex-markdown -cache=" .. cachedir .. " " .. table.concat(vim.b.bibfiles, " "), selected)
  local result_lines = {}
  for line in result:gmatch("[^\n]+") do
    table.insert(result_lines, line)
  end
  vim.api.nvim_put(result_lines, "l", true, true)
  if opts.fzf_bibtex.mode == "i" then
    vim.api.nvim_feedkeys("i", "n", true)
  end
end

local fzf_bibtex_menu = function(mode)
  return function()
    -- check cache directory hasn't mysteriously disappeared
    if vim.fn.isdirectory(cachedir) == 0 then
      vim.fn.mkdir(cachedir, "p")
    end

    require("fzf-lua").config.set_action_helpstr(pandoc, "@-pandoc")
    require("fzf-lua").config.set_action_helpstr(citet, "\\citet{}")
    require("fzf-lua").config.set_action_helpstr(citep, "\\citep{}")
    require("fzf-lua").config.set_action_helpstr(markdown_print, "markdown-pretty-print")

    -- header line: the bibtex filenames
    local filenames = {}
    for i, fullpath in ipairs(vim.b.bibfiles) do
      filenames[i] = vim.fn.fnamemodify(fullpath, ":t")
    end
    local header = table.concat(filenames, "\\ ")

    -- set default action
    local default_action = nil
    if vim.bo.ft == "markdown" then
      default_action = pandoc
    elseif vim.bo.ft == "tex" then
      default_action = citet
    end

    -- run fzf
    return require("fzf-lua").fzf_exec(
      "bibtex-ls " .. "-cache=" .. cachedir .. " " .. table.concat(vim.b.bibfiles, " "),
      {
        actions = {
          ["default"] = default_action,
          ["alt-a"] = pandoc,
          ["alt-t"] = citet,
          ["alt-p"] = citep,
          ["alt-m"] = markdown_print,
        },
        fzf_bibtex = { ["mode"] = mode },
        fzf_opts = { ["--prompt"] = "BibTeX> ", ["--header"] = header },
      }
    )
  end
end

-- Only enable mapping in tex or markdown
vim.api.nvim_create_autocmd("Filetype", {
  desc = "Set up keymaps for fzf-bibtex",
  group = vim.api.nvim_create_augroup("fzf-bibtex", { clear = true }),
  pattern = { "markdown", "tex" },
  callback = function()
    vim.b.bibfiles = default_bibfiles
    vim.keymap.set("n", "<leader>fz", fzf_bibtex_menu("n"), { buffer = true, desc = "FZF: BibTeX [C]itations" })
    vim.keymap.set("i", "@@", fzf_bibtex_menu("i"), { buffer = true, desc = "FZF: BibTeX [C]itations" })
  end,
})

vim.opt.sessionoptions:append("localoptions") -- Save localoptions to session file
vim.g.vimtex_compiler_latexmk = {
  options = {
    "-pdf",
    "-shell-escape",
  },
}
-- Example config in Lua
--

-- Load the colorscheme
vim.cmd("let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'relative': v:true, 'yoffset': 1.0 } }")
-- vim.schedule(function()
-- vim.o.background = "dark"
-- vim.cmd("set title")
-- vim.cmd("set titleold=")
-- end)
vim.diagnostic.config({
  virtual_text = false,
})
-- vim.g.newpaper_style = "dark"
-- vim.cmd("NewpaperDark")
vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=200})
augroup END
]])

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yaml" },
  command = "set ft=jinja",
})
vim.cmd("au! FileExplorer *")
