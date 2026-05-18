local parsers = {
  "lua",
  "bash",
  "python",
  "go",
  "rust",
  "javascript",
  "typescript",
  "tsx",
  "html",
  "css",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
}

local filetypes = {
  "lua",
  "bash",
  "sh",
  "python",
  "go",
  "rust",
  "javascript",
  "typescript",
  "typescriptreact",
  "html",
  "css",
  "json",
  "yaml",
  "markdown",
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    require("nvim-treesitter").install(parsers):wait(300000)
  end,
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter").setup()

    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetypes,
      callback = function()
        if vim.b.treesitter_enabled ~= false then
          local ok = pcall(vim.treesitter.start)
          if ok then
            vim.b.treesitter_enabled = true
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end
      end,
    })
  end,
}
