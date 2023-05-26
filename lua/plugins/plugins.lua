return {

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
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },
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
        "<leader>r",
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
      { "<leader><space>", "<cmd>Telescope tags<CR>", desc = "tags" },
      { "<leader>gc", "<cmd>Telescope git_bcommits<CR>", desc = "buffer commits" },
      {
        "<tab>",
        function()
          require("telescope.builtin").buffers({ sort_lastused = true, ignore_current_buffer = true })
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
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
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
  { "nyoom-engineering/oxocarbon.nvim" },
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

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      updatetime = 200,
      colorscheme = "tokyonight-night",
      background = "dark",
    },
  },
}
