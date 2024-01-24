return {
  { "jalvesaq/zotcite" },
  { "lervag/vimtex" },
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
  { "ekalinin/Dockerfile.vim" },
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
      format = { timeout_ms = 2000 },
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
  { "msprev/fzf-bibtex" },
  { "shortcuts/no-neck-pain.nvim", version = "*" },
  { "ferdinandyb/bibtexcite.vim" },
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
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
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
      load_extensions = { "yank_history", "bibtex" },
      extensions = {
        bibtex = {
          depth = 1,
          -- Depth for the *.bib file
          global_files = { "/Users/morzusman/projects/bibtex.bib" },
          -- Path to global bibliographies (placed outside of the project)
          search_keys = { "author", "year", "title" },
          -- Define the search keys to use in the picker
          citation_format = "{{author}} ({{year}}), {{title}}.",
          -- Template for the formatted citation
          -- citation_trim_firstname = true,
          -- Only use initials for the authors first name
          citation_max_auth = 2,
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
        layout_strategy = "vertical",

        layout_config = {
          vertical = {
            preview_height = 0.5,
          },
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({ "max-perf" })
    end,
  },
  { "folke/flash.nvim", enabled = false },
  { "rebelot/kanagawa.nvim" },
  { "miikanissi/modus-themes.nvim", priority = 1000 },
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
  { "kevinhwang91/promise-async" },
  { "lifepillar/vim-gruvbox8" },
  {
    "kevinhwang91/nvim-ufo",
    config = function()
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
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
  -- { "ggandor/leap.nvim", enabled = t },
  -- { "ggandor/flit.nvim", enabled = false },
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
  { "NLKNguyen/papercolor-theme" },
  {
    "prochri/telescope-all-recent.nvim",
    config = function()
      require("telescope-all-recent").setup({
        -- your config goes here
      })
    end,
  },
  { "ThePrimeagen/harpoon" },
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
