-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.api.nvim_set_option("clipboard", "unnamed")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      { "echasnovski/mini.surround", version = "*" },

      {
        "linux-cultist/venv-selector.nvim",
        dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
        opts = {
          -- Your options go here
          -- name = "venv",
          auto_refresh = true,
        },
        event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
        keys = {
          -- Keymap to open VenvSelector to pick a venv.
          { "<leader>vs", "<cmd>VenvSelect<cr>" },
          -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
          { "<leader>vc", "<cmd>VenvSelectCached<cr>" },
        },
      },
      { "echasnovski/mini.files", version = "*" },
      { "jalvesaq/zotcite" },
      { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
      {
        "neovim/nvim-lspconfig",
        dependencies = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/cmp-cmdline",
          "hrsh7th/nvim-cmp",
          "L3MON4D3/LuaSnip",
          "saadparwaiz1/cmp_luasnip",
          "j-hui/fidget.nvim",
        },

        config = function()
          local cmp = require("cmp")
          local cmp_lsp = require("cmp_nvim_lsp")
          local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
          )

          require("fidget").setup({})
          require("mason").setup()
          require("mason-lspconfig").setup({
            handlers = {
              function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup({
                  capabilities = capabilities,
                })
              end,
            },
          })

          local cmp_select = { behavior = cmp.SelectBehavior.Select }

          cmp.setup({
            mapping = cmp.mapping.preset.insert({
              ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
              ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
              ["<CR>"] = cmp.mapping.confirm({ select = true }),
              ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
            }, {
              { name = "buffer" },
            }),
          })

          vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
              focusable = false,
              style = "minimal",
              border = "rounded",
              source = "always",
              header = "",
              prefix = "",
            },
          })
        end,
      },
      {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
          require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = {
              "vimdoc",
              "python",
              "c",
              "lua",
              "bash",
            },

            -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
              enable = true,
            },

            highlight = {
              -- `false` will disable the whole extension
              enable = true,

              -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
              -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
              -- Using this option may slow down your editor, and you may see some duplicate highlights.
              -- Instead of true it can also be a list of languages
              additional_vim_regex_highlighting = { "markdown" },
            },
          })

          local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
          treesitter_parser_config.templ = {
            install_info = {
              url = "https://github.com/vrischmann/tree-sitter-templ.git",
              files = { "src/parser.c", "src/scanner.c" },
              branch = "master",
            },
          }

          vim.treesitter.language.register("templ", "templ")
        end,
      },
      {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          -- calling `setup` is optional for customization
          require("fzf-lua").setup({})
        end,
      },
      {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewFileHistory", "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
        keys = {
          {
            "<leader>gd",
            "<cmd>DiffviewOpen<cr>",
            desc = "DiffView",
          },
          {
            "<leader>gl",
            "<cmd>DiffviewFileHistory %<cr>",
            desc = "DiffView",
          },
        },
      },
      {
        "gbprod/substitute.nvim",
        config = function()
          require("substitute").setup({})
        end,
      },
      { "tpope/vim-unimpaired" },
      -- { "Glench/Vim-Jinja2-Syntax" },
      -- { "rose-pine/neovim", name = "rose-pine" },
      {
        "neovim/nvim-lspconfig",
        opts = {
          diagnostics = {
            virtual_text = false,
          },
          format = { timeout_ms = 5000 },
          servers = {
            -- Ensure mason installs the server
            clangd = {
              keys = {
                { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
              },
              root_dir = function(fname)
                return require("lspconfig.util").root_pattern(
                  "Makefile",
                  "configure.ac",
                  "configure.in",
                  "config.h.in",
                  "meson.build",
                  "meson_options.txt",
                  "build.ninja"
                )(fname) or require("lspconfig.util").root_pattern(
                  "compile_commands.json",
                  "compile_flags.txt"
                )(fname) or require("lspconfig.util").find_git_ancestor(fname)
              end,
              capabilities = {
                offsetEncoding = { "utf-16" },
              },
              cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
              },
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
              },
            },
          },
          setup = {
            clangd = function(_, opts)
              local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
              require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
              return false
            end,
          },
        },
      },
      { "msprev/fzf-bibtex" },
      { "ferdinandyb/bibtexcite.vim" },
      -- { "projekt0n/github-nvim-theme" },
      {
        "nvim-telescope/telescope.nvim",
        dependencies = {
          {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            config = function()
              require("telescope").load_extension("fzf")
            end,
          },
          {
            "nvim-telescope/telescope-bibtex.nvim",
            ft = { "tex", "markdown" },
            config = function()
              require("telescope").load_extension("bibtex")
            end,
          },
        },
        keys = {
          { "<leader>gc", false },
          { "<leader>fp", false },
          { "<leader><space>", false },
          {
            "<leader>fP",
            function()
              require("telescope.builtin").find_files({
                cwd = require("lazy.core.config").options.root,
              })
            end,
            desc = "Find Plugin File",
          },
        },

        opts = {

          defaults = {
            load_extensions = { "yank_history", "bibtex" },
            extensions = {
              bibtex = {
                depth = 1,
                -- Depth for the *.bib file
                global_files = { "/Users/morzusman/projects/bib3.bib" },
                -- Path to global bibliographies (placed outside of the project)
                search_keys = { "author", "year", "title" },
                -- Define the search keys to use in the picker
                citation_format = "{{author}} ({{year}}), {{title}}.",
                -- Template for the formatted citation
                -- citation_trim_firstname = true,
                -- Only use initials for the authors first name
                citation_max_auth = 1,
                -- Format to use for citation label.
                -- Try to match the filetype by default, or use 'plain'
                context = false,
                -- Context awareness disabled by default
                format = "latex",
                context_fallback = true,
                -- Fallback to global/directory .bib files if context not found
                -- This setting has no effect if context = false
                wrap = false,
                -- Wrapping in the preview window is disabled by default
              },

              file_ignore_patterns = { "tags" },
              -- layout_strategy = "vertical",
              dynamic_preview_title = true,

              layout_config = {
                horizontal = {
                  height = 0.95,
                  width = 0.95,
                  -- preview_width = 0.35,
                },
                -- prompt_position = "top",
              },
              path_display = { "smart" },
              sorting_strategy = "ascending",
              winblend = 0,
            },
          },
        },
      },
      {
        "RRethy/vim-illuminate",
        opts = {
          delay = 200,
          large_file_cutoff = 2000,
          large_file_overrides = {
            providers = { "lsp" },
          },
        },
        config = function(_, opts)
          require("illuminate").configure(opts)

          local function map(key, dir, buffer)
            vim.keymap.set("n", key, function()
              require("illuminate")["goto_" .. dir .. "_reference"](false)
            end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
          end

          map("]]", "next")
          map("[[", "prev")

          -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
          vim.api.nvim_create_autocmd("FileType", {
            callback = function()
              local buffer = vim.api.nvim_get_current_buf()
              map("]]", "next", buffer)
              map("[[", "prev", buffer)
            end,
          })
        end,
        keys = {
          { "]]", desc = "Next Reference" },
          { "[[", desc = "Prev Reference" },
        },
      },
      {
        "lewis6991/gitsigns.nvim",
        opts = {
          signs = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
          },
          signs_staged = {
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
          },
          on_attach = function(buffer)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, desc)
              vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

      -- stylua: ignore start
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Next Hunk")
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Prev Hunk")
      map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
      map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
      map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
      map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
          end,
        },
      },
      {
        "echasnovski/mini.move",
        version = false,
        config = function()
          require("mini.move").setup()
        end,
      },
      },
      { "tpope/vim-repeat" },
      { "tpope/vim-fugitive" },
      { "nvim-neo-tree/neo-tree.nvim", enabled = false },
      {
        "Wansmer/treesj",
        keys = { "<leader>m", "<leader>j", "<leader>s" },
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
          require("treesj").setup({--[[ your config ]]
          })
        end,
      },
    },
  },
  change_detection = { notify = false },
})
