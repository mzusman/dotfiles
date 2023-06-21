return {
  {
    "nvim-neorg/neorg",
    ft = "norg",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "nvim-cmp",
      "nvim-lua/plenary.nvim",
    },
    build = ":Neorg sync-parsers",
    cmd = "Neorg",
    -- lazy adds:
    --   config = function(_, opts)
    --     require("<plugin>").setup(opts)
    --   end
    opts = {
      load = {
        ["core.defaults"] = {},
        ["core.qol.todo_items"] = {},
        ["core.completion"] = {
          config = {
            engine = "nvim-cmp",
            name = "[Norg]",
          },
        },
        ["core.integrations.nvim-cmp"] = {},
        ["core.concealer"] = {
          config = { icon_preset = "diamond" },
        },
        ["core.export"] = {},
        ["core.keybinds"] = {
          -- https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/keybinds/keybinds.lua
          config = {
            default_keybinds = true,
            neorg_leader = "<Leader>",
          },
        },
        ["core.promo"] = {},
        ["core.itero"] = {},
        ["core.esupports.metagen"] = {},

        ["core.esupports.indent"] = {},
        ["core.qol.todo_items"] = {},
        ["core.dirman"] = {
          config = {
            workspaces = {
              personal = "~/projects/notes/personal",
              work = "~/projects/notes/work",
            },
          },
        },
      },
    },
  },
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
  { "HiPhish/jinja.vim" },
  { "ekalinin/Dockerfile.vim" },
  { "preservim/vim-markdown", ft = "markdown", dependencies = { "godlygeek/tabular" } },
  {
    "axkirillov/hbac.nvim",
    config = function()
      require("hbac").setup()
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
      diagnostics = { virtual_text = { prefix = "icons" } },
      setup = {
        clangd = function(_, opts)
          opts.capabilities.offsetEncoding = { "utf-16" }
        end,
      },
    },
  },
  { "ludovicchabant/vim-gutentags" },
  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

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
      -- { "<leader><space>", "<cmd>Telescope tags<CR>", desc = "tags" },
      { "<leader>gc", false },
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
  { "junegunn/fzf" },

  {
    -- Plugin for a better & quicker "Escape" mechanism.
    "max397574/better-escape.nvim",
    event = "InsertLeavePre",
  },
  {
    "RRethy/vim-illuminate",
    opts = { delay = 50 },
  },
  { "tpope/vim-dispatch" },
  { "tpope/vim-fugitive" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
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
  { "catppuccin/nvim", name = "catppuccin" },
  { "dracula/vim" },

  { "nyoom-engineering/oxocarbon.nvim" },
  { "NLKNguyen/papercolor-theme" },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    theme = "tokyonight",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard", -- can be "hard", "soft" or empty string
    },
  },
  { "tpope/vim-surround" },
  { "ggandor/leap.nvim", enabled = false },
  { "ggandor/flit.nvim", enabled = false },
  {
    "echasnovski/mini.surround",
    enabled = false,
    opts = {
      mappings = {
        add = "ta",
        find = "tf",
        find_left = "tF",
        highlight = "th",
        replace = "tr",
        update_n_lines = "tn",
      },
    },
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      updatetime = 200,
      colorscheme = "gruvbox",
    },
  },
}
