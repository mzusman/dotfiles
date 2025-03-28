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
      {
        -- {
        -- "hinell/lsp-timeout.nvim",
        -- dependencies = { "neovim/nvim-lspconfig" },
        -- },
        {
          "kawre/leetcode.nvim",
          build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
          dependencies = {
            "nvim-telescope/telescope.nvim",
            -- "ibhagwan/fzf-lua",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
          },
          opts = {
            -- configuration goes here
          },
        },
        {
          "nvim-lualine/lualine.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("lualine").setup({})
          end,
        },
        {
          "nvim-treesitter/nvim-treesitter-context",
          dependencies = { "nvim-treesitter/nvim-treesitter" },
          config = function()
            require("treesitter-context").setup({
              enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
              multiwindow = false, -- Enable multiwindow support.
              max_lines = 2, -- How many lines the window should span. Values <= 0 mean no limit.
              min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
              line_numbers = true,
              multiline_threshold = 2, -- Maximum number of lines to show for a single context
              trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
              mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
              -- Separator between context and content. Should be a single character string, like '-'.
              -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
              separator = nil,
              zindex = 20, -- The Z-index of the context window
              on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attachin
            })
          end,
        },
        {
          "linrongbin16/gitlinker.nvim",
          cmd = "GitLink",
          opts = {},
          keys = {
            {
              "<leader>gy",
              "<cmd>GitLink<cr>",
              mode = { "n", "v" },
              desc = "Yank git link",
            },
            {
              "<leader>gY",
              "<cmd>GitLink!<cr>",
              mode = { "n", "v" },
              desc = "Open git link",
            },
          },
        },
      },
      {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
          "neovim/nvim-lspconfig",
          {
            "nvim-telescope/telescope.nvim",
            branch = "0.1.x",
            dependencies = { "nvim-lua/plenary.nvim" },
          },
        },
        lazy = false,
        branch = "regexp", -- This is the regexp branch, use this for the new version
        config = function()
          require("venv-selector").setup({
            settings = {
              options = { notify_user_on_venv_activation = true },
            },
          })
        end,
        keys = {
          { "<leader>vs", "<cmd>VenvSelect<cr>" },
        },
      },
      {
        "neovim/nvim-lspconfig",
        dependencies = {
          "williamboman/mason.nvim",
          "williamboman/mason-lspconfig.nvim",
          "hrsh7th/cmp-nvim-lsp",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-path",
          "hrsh7th/nvim-cmp",
          "j-hui/fidget.nvim",
        },
        opts = {
          diagnostics = {
            virtual_text = false,
          },
          format = { timeout_ms = 5000 },
          servers = {
            -- Ensure mason installs the servers

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
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = {},
      },
      {
        "Hajime-Suzuki/vuffers.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          require("vuffers").setup({
            debug = {
              enabled = true,
              level = "error", -- "error" | "warn" | "info" | "debug" | "trace"
            },
            exclude = {
              -- do not show them on the vuffers list
              filenames = { "term://" },
              filetypes = { "lazygit", "NvimTree", "qf" },
            },
            handlers = {
              -- when deleting a buffer via vuffers list (by default triggered by "d" key)
              on_delete_buffer = function(bufnr)
                vim.api.nvim_command(":bwipeout " .. bufnr)
              end,
            },
            keymaps = {
              -- if false, no bindings will be provided at all
              -- thus you will have to bind on your own
              use_default = true,
              -- key maps on the vuffers list
              -- - may map multiple keys for the same action
              --    open = { "<CR>", "<C-l>" }
              -- - disable a specific binding using "false"
              --    open = false
              view = {
                open = "<CR>",
                delete = "d",
                pin = "p",
                unpin = "P",
                rename = "r",
                reset_custom_display_name = "R",
                reset_custom_display_names = "<leader>R",
                move_up = "U",
                move_down = "D",
                move_to = "i",
              },
            },
            sort = {
              type = "none", -- "none" | "filename"
              direction = "asc", -- "asc" | "desc"
            },
            view = {
              modified_icon = "󰛿", -- when a buffer is modified, this icon will be shown
              pinned_icon = "󰐾",
              window = {
                auto_resize = false,
                width = 35,
                focus_on_open = false,
              },
            },
          })
        end,
      },
      {
        "gnikdroy/projections.nvim",
        dependencies = {
          "ibhagwan/fzf-lua", -- Customize the menu UI yourself from fzf-lua's setup.
          "nyngwang/fzf-lua-projections.nvim",
        },
        branch = "pre_release",
        config = function()
          require("projections").setup({
            workspaces = { -- Default workspaces to search for
              { "~/projects", { ".git" } }, -- Documents/dev is a workspace. patterns = { ".git" }
            },
          })

          -- Bind <leader>fp to Telescope projections
          vim.keymap.set("n", "<leader>fp", function()
            vim.cmd("wa")
            require("fzf-lua-p").projects()
          end)

          -- Autostore session on VimExit
          local Session = require("projections.session")
          vim.api.nvim_create_autocmd({ "VimLeavePre" }, {
            callback = function()
              Session.store(vim.loop.cwd())
            end,
          })

          -- Switch to project if vim was started in a project dir
          local switcher = require("projections.switcher")
          vim.api.nvim_create_autocmd({ "VimEnter" }, {
            callback = function()
              if vim.fn.argc() == 0 then
                switcher.switch(vim.loop.cwd())
              end
            end,
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
      { "echasnovski/mini.files", version = "*" },
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
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
          -- calling `setup` is optional for customization
          require("fzf-lua").setup({
            "max-perf",
            winopts = {
              fullscreen = true,
              preview = {
                -- default = "cat",
                horizontal = "right:50%",
                layout = "horizontal",
              },
            },
            {
              files = {
                formatter = "path.filename_first",
              },
              buffers = {
                cwd_only = true,
              },
            },
          })
        end,
      },
      {
        "sindrets/diffview.nvim",
        cmd = { "DiffviewFileHistory", "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
        config = true,
      },
      {
        "gbprod/substitute.nvim",
        config = function()
          require("substitute").setup({})
        end,
      },
      { "tpope/vim-unimpaired" },
      { "Glench/Vim-Jinja2-Syntax", ft = { "yaml" } },
      { "msprev/fzf-bibtex" },
      { "machakann/vim-swap", event = "VeryLazy" },
      {
        "lervag/vimtex",
        lazy = false,
        ft = { "tex" },
      },
      {
        "rbong/vim-flog",
        lazy = true,
        cmd = { "Flog", "Flogsplit", "Floggit" },
        dependencies = {
          "tpope/vim-fugitive",
        },
      },
      { "ferdinandyb/bibtexcite.vim" },
      {
        "mvllow/modes.nvim",
        tag = "v0.2.0",
        config = function()
          require("modes").setup()
        end,
      },
      {
        "lewis6991/gitsigns.nvim",
        opts = {
          numhl = true, -- Toggle with `:Gitsigns toggle_linehl`
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
        "echasnovski/mini.surround",
        version = false,
        config = function()
          require("mini.surround").setup()
        end,
      },
      -- {
      -- "Bekaboo/dropbar.nvim",
      -- },
      {
        "echasnovski/mini.indentscope",
        version = false,
        config = function()
          require("mini.indentscope").setup()
        end,
      },
      {
        "echasnovski/mini.cursorword",
        version = false,
        config = function()
          require("mini.cursorword").setup({ delay = 10 })
        end,
      },
      { "tpope/vim-repeat" },
      { "tpope/vim-fugitive" },
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
  change_detection = { notify = true },
})
