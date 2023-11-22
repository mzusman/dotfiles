return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
        {
          name = "emoji",
        },
        name = "spell",
        option = {
          keep_all_entries = false,
          enable_in_context = function()
            return true
          end,
        },
      }))
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    enabled = false,
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
  { "dhruvasagar/vim-table-mode" },
  { "ThePrimeagen/harpoon" },
  -- { "ekalinin/Dockerfile.vim" },
  {
    "preservim/vim-markdown",
    ft = "markdown",
    dependencies = { "godlygeek/tabular" },
  },
  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({})
    end,
  },
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
        threshold = 30, -- hbac will start closing unedited buffers once that number is reached
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
    "tzachar/highlight-undo.nvim",
  },
  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>cx",
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
  { "sainnhe/gruvbox-material" },
  -- Correctly setup lspconfig for clangd 🚀
  --
  {
    "neovim/nvim-lspconfig",
    opts = {
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
            )(fname) or require("lspconfig.util").root_pattern("compile_commands.json", "compile_flags.txt")(
              fname
            ) or require("lspconfig.util").find_git_ancestor(fname)
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
      { "gr", false },
      -- {
      -- "<tab>",
      -- function()
      -- require("telescope.builtin").buffers({
      -- layout_config = { preview_width = 0 },
      -- sort_mru = true,
      -- ignore_current_buffer = true,
      -- })
      -- end,
      -- desc = "last buffers",
      -- },
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
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  { "folke/flash.nvim", enabled = false },
  { "rebelot/kanagawa.nvim" },
  { "tpope/vim-repeat" },
  { "rose-pine/neovim", name = "rose-pine" },
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    enabled = true,
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
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
      contrast = "hard", -- can be "hard", "soft" or empty string
    },
  },
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup({})
    end,
  },
  {
    "roobert/f-string-toggle.nvim",
    config = function()
      require("f-string-toggle").setup({
        key_binding = "<leader>tf",
      })
    end,
  },
  { "nyoom-engineering/oxocarbon.nvim" },
  { "goolord/alpha-nvim", enabled = false },
  {
    "gnikdroy/projections.nvim",
    config = function()
      require("projections").setup({
        workspaces = { { "~/projects", { ".git" } } },
      })

      -- Bind <leader>fp to Telescope projections
      require("telescope").load_extension("projections")
      vim.keymap.set("n", "<leader>fp", function()
        vim.cmd("Telescope projections")
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
  {
    "NLKNguyen/papercolor-theme",
  },
  {
    "prochri/telescope-all-recent.nvim",
    config = function()
      require("telescope-all-recent").setup({
        -- your config goes here
      })
    end,
  },
  {
    "ThePrimeagen/harpoon",
  },
  { "anuvyklack/middleclass" },
  { "anuvyklack/animation.nvim" },
  {
    "anuvyklack/windows.nvim",
    config = function()
      vim.o.winminwidth = 5
      vim.o.winwidth = 5
      vim.o.equalalways = false
      require("windows").setup({
        autowidth = {
          enable = true,
          winwidth = 5,
          filetype = {
            help = 2,
          },
        },
      })
    end,
  },
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

  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine-moon",
    },
  },
}
