return {
  {
    "vrslev/cmp-pypi",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "toml",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    opts = function(_, opts) end,
  },
  { "jalvesaq/zotcite" },
  { "nyoom-engineering/oxocarbon.nvim" },
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
  -- { "dhruvasagar/vim-table-mode" },
  -- { "ekalinin/Dockerfile.vim" },
  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({})
    end,
  },
  { "tpope/vim-unimpaired" },
  -- { "Glench/Vim-Jinja2-Syntax" },
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
  { "junegunn/fzf" },
  { "junegunn/fzf.vim" },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end,
  },
  { "folke/flash.nvim", enabled = false },
  { "tpope/vim-repeat" },
  -- { "rose-pine/neovim", name = "rose-pine" },
  { "akinsho/bufferline.nvim", enabled = false },
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        python = { "black", "isort" },
      },
    },
  },
  {
    "TimUntersberger/neogit",
    dependencies = "nvim-lua/plenary.nvim",
    enabled = true,
    config = true,
    opts = {
      disable_builtin_notifications = false,
      auto_show_console = false,
      integrations = {
        diffview = true,
      },
    },
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
    enabled = false,
  },
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
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "oxocarbon",
    },
  },
}
