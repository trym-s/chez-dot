return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ui = {
        border = "single",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "lua_ls",
        "bashls",
        "pyright",
        "gopls",
        "rust_analyzer",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "marksman",
      },
      automatic_enable = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              checkThirdParty = false,
            },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local opts = { buffer = event.buf, silent = true }
          local keymap = vim.keymap.set

          keymap("n", "gd", vim.lsp.buf.definition, opts)
          keymap("n", "gr", vim.lsp.buf.references, opts)
          keymap("n", "K", vim.lsp.buf.hover, opts)
          keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)
          keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          keymap("n", "<leader>de", vim.diagnostic.open_float, opts)
          keymap("n", "[d", vim.diagnostic.goto_prev, opts)
          keymap("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })
    end,
  },
}
