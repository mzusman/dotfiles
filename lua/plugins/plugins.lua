return {
  -- {
  --   "nvim-neorg/neorg",
  --   ft = "norg",
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-treesitter/nvim-treesitter-textobjects",
  --     "nvim-cmp",
  --     "nvim-lua/plenary.nvim",
  --   },
  --   build = ":Neorg sync-parsers",
  --   cmd = "Neorg",
  --   -- lazy adds:
  --   --   config = function(_, opts)
  --   --     require("<plugin>").setup(opts)
  --   --   end
  --   opts = {
  --     load = {
  --       ["core.defaults"] = {},
  --       ["core.qol.todo_items"] = {},
  --       ["core.completion"] = {
  --         config = {
  --           engine = "nvim-cmp",
  --           name = "[Norg]",
  --         },
  --       },
  --       ["core.integrations.nvim-cmp"] = {},
  --       ["core.concealer"] = {
  --         config = { icon_preset = "diamond" },
  --       },
  --       ["core.export"] = {},
  --       ["core.keybinds"] = {
  --         -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
  --         config = {
  --           default_keybinds = true,
  --           neorg_leader = "<Leader>",
  --         },
  --       },
  --       ["core.promo"] = {},
  --       ["core.itero"] = {},
  --       ["core.esupports.metagen"] = {},
  --
  --       ["core.esupports.indent"] = {},
  --       ["core.qol.todo_items"] = {},
  --       ["core.dirman"] = {
  --         config = {
  --           workspaces = {
  --             personal = "~/projects/notes/personal",
  --             work = "~/projects/notes/work",
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  -- better diffing
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    end,
  },
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewFileHistory", "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },
  -- { "HiPhish/jinja.vim" },
  { "ekalinin/Dockerfile.vim" },
  { "preservim/vim-markdown", ft = "markdown", dependencies = { "godlygeek/tabular" } },

  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  { "rockerBOO/boo-colorscheme-nvim" },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "dasupradyumna/midnight.nvim", lazy = false, priority = 1000 },

  {
    "ethanholz/nvim-lastplace",
    config = function()
      require("nvim-lastplace").setup({})
    end,
  },
  {
    "axkirillov/hbac.nvim",
    config = function()
      require("hbac").setup({
        threshold = 20, -- hbac will start closing unedited buffers once that number is reached
      })
    end,
  },

  { "tpope/vim-unimpaired" },
  { "Glench/Vim-Jinja2-Syntax" },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 0,
      animate = false,
      top_down = true,
      render = "minimal",
      max_height = function()
        return math.floor(vim.o.lines * 0.40)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.40)
      end,
    },
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>cf",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
        desc = "Refactor",
      },
    },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      opts = {
        inlay_hints = { enabled = false },
      },
      diagnostics = { virtual_text = false },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
  -- {
  --   "simrat39/symbols-outline.nvim",
  --   keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
  --   config = true,
  -- },
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {
      { "<leader>gc", false },
      { "<leader>fp", false },
      { "<leader><space>", false },
      {
        "<tab>",
        function()
          require("telescope.builtin").buffers({ sort_mru = true, ignore_current_buffer = true })
        end,
        desc = "last buffers",
      },
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
        file_ignore_patterns = { "tags" },
        preview = false,
        layout_strategy = "vertical",

        layout_config = {
          vertical = {
            width = 0.95,
            height = 0.95,
            preview_height = 0.5,
          },
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  { "junegunn/fzf.vim" },
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    version = false,
    opts = {
      disable_builtin_notifications = false,
      auto_show_console = false,
      integrations = {
        diffview = true,
      },
    },
  },
  { "folke/noice.nvim", enabled = false },
  {
    "echasnovski/mini.align",
    version = false,
    config = function()
      require("mini.align").setup({})
    end,
  },
  {
    "echasnovski/mini.files",
    opts = {
      windows = {
        preview = false,
      },
      options = {
        -- Whether to use for editing directories
        -- Disabled by default in LazyVim because neo-tree is used for that
        use_as_default_explorer = true,
      },
    },
  },

  { "junegunn/fzf" },

  {
    "RRethy/vim-illuminate",
    opts = { delay = 50 },
  },
  { "tpope/vim-fugitive" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    enabled = false,
    keys = {
      {
        "<leader>fE",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            position = "float",
            dir = require("lazyvim.util").get_root(),
          })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>fe",
        function()
          require("neo-tree.command").execute({ toggle = true, reveal = true, position = "float", dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (root dir)", remap = true },
      { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (cwd)", remap = true },
    },
    deactivate = function()
      -- Callback function to deactivate the plugin when necessary.
      vim.cmd([[ Neotree close]])
    end,
    opts = {
      close_if_last_window = true, -- Don't leave the plugin's window open as the last window
      filesystem = {
        filtered_items = {
          visible = true,
          show_hidden_count = true,
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_by_name = {
            -- '.git',
            -- '.DS_Store',
            -- 'thumbs.db',
          },
          never_show = {},
        },
      },
    },
  },
  -- {
  --   "utilyre/barbecue.nvim",
  --   name = "barbecue",
  --   theme = "grubbox",
  --   version = "*",
  --   dependencies = {
  --     "SmiteshP/nvim-navic",
  --     "nvim-tree/nvim-web-devicons", -- optional dependency
  --   },
  --   opts = {
  --     -- configurations go here
  --   },
  -- },

  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard", -- can be "hard", "soft" or empty string
    },
  },

  { "ggandor/leap.nvim", enabled = false },
  { "ggandor/flit.nvim", enabled = false },
  {
    "ahmedkhalf/project.nvim",
    enabled = false,
    opts = {},
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)
      require("telescope").load_extension("projects")
    end,
    keys = {
      { "<leader>fp", false },
    },
  },

  { "kkharji/sqlite.lua" },
  { "EdenEast/nightfox.nvim" }, -- lazy

  { "haystackandroid/rusticated" },
  { "yorik1984/newpaper.nvim" },
  {
    "prochri/telescope-all-recent.nvim",
    config = function()
      require("telescope-all-recent").setup({
        -- your config goes here
      })
    end,
  },
  { "pbrisbin/vim-colors-off" },
  { "luisiacc/gruvbox-baby" },
  { "rebelot/kanagawa.nvim" },
  {
    "Wansmer/treesj",
    keys = { "<leader>m", "<leader>j", "<leader>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({--[[ your config ]]
      })
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
    end,
  },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "newpaper",
    },
  },
}
