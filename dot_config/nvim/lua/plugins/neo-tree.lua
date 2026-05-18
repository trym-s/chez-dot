local palette = require("core.palette")

local icon_color = {
  code = palette.info,
  config = palette.accent,
  data = palette.cyan,
  docs = palette.success,
  media = palette.secondary,
  package = palette.warning,
  secret = palette.warning,
  system = palette.subtle,
  danger = palette.danger,
}

local function icon_spec(icon, color, name)
  return { icon = icon, color = color, name = name }
end

local function set_tree_highlights()
  local hi = vim.api.nvim_set_hl

  hi(0, "NeoTreeNormal",             { fg = palette.fg, bg = "NONE" })
  hi(0, "NeoTreeNormalNC",           { fg = palette.fg, bg = "NONE" })
  hi(0, "NeoTreeCursorLine",         { bg = palette.surface })
  hi(0, "NeoTreeWinSeparator",       { fg = palette.surface_alt, bg = "NONE" })
  hi(0, "NeoTreeEndOfBuffer",        { fg = palette.bg, bg = "NONE" })
  hi(0, "NeoTreeRootName",           { fg = palette.info, bold = true })
  hi(0, "NeoTreeDirectoryName",      { fg = palette.fg, bold = true })
  hi(0, "NeoTreeDirectoryIcon",      { fg = palette.accent })
  hi(0, "NeoTreeFileName",           { fg = palette.fg })
  hi(0, "NeoTreeFileNameOpened",     { fg = palette.fg, bold = true })
  hi(0, "NeoTreeFileIcon",           { fg = icon_color.system })
  hi(0, "NeoTreeDotfile",            { fg = palette.muted, italic = true })
  hi(0, "NeoTreeHiddenByName",       { fg = palette.muted, italic = true })
  hi(0, "NeoTreeIndentMarker",       { fg = palette.surface_alt })
  hi(0, "NeoTreeExpander",           { fg = palette.accent })
  hi(0, "NeoTreeModified",           { fg = palette.warning, bold = true })
  hi(0, "NeoTreeGitAdded",           { fg = palette.success })
  hi(0, "NeoTreeGitModified",        { fg = palette.warning })
  hi(0, "NeoTreeGitDeleted",         { fg = palette.danger })
  hi(0, "NeoTreeGitUntracked",       { fg = palette.info })
  hi(0, "NeoTreeGitIgnored",         { fg = palette.muted, italic = true })
  hi(0, "NeoTreeGitConflict",        { fg = palette.danger, bold = true })
  hi(0, "NeoTreeDiagnosticError",    { fg = palette.danger })
  hi(0, "NeoTreeDiagnosticWarn",     { fg = palette.warning })
  hi(0, "NeoTreeDiagnosticInfo",     { fg = palette.info })
  hi(0, "NeoTreeDiagnosticHint",     { fg = palette.cyan })

  hi(0, "DevIconDefault",            { fg = icon_color.system })
  hi(0, "DevIconLua",                { fg = icon_color.code })
  hi(0, "DevIconRs",                 { fg = icon_color.danger })
  hi(0, "DevIconGo",                 { fg = icon_color.data })
  hi(0, "DevIconPy",                 { fg = icon_color.package })
  hi(0, "DevIconJs",                 { fg = icon_color.package })
  hi(0, "DevIconTs",                 { fg = icon_color.code })
  hi(0, "DevIconTsx",                { fg = icon_color.code })
  hi(0, "DevIconJson",               { fg = icon_color.data })
  hi(0, "DevIconToml",               { fg = icon_color.config })
  hi(0, "DevIconYaml",               { fg = icon_color.config })
  hi(0, "DevIconMd",                 { fg = icon_color.docs })
  hi(0, "DevIconDockerfile",         { fg = icon_color.code })
  hi(0, "DevIconEnv",                { fg = icon_color.secret })
  hi(0, "DevIconNix",                { fg = icon_color.data })
  hi(0, "DevIconLock",               { fg = icon_color.package })
  hi(0, "DevIconGitIgnore",          { fg = icon_color.system })
  hi(0, "DevIconGitConfig",          { fg = icon_color.config })
  hi(0, "DevIconLicense",            { fg = icon_color.docs })
  hi(0, "DevIconPng",                { fg = icon_color.media })
  hi(0, "DevIconJpg",                { fg = icon_color.media })
  hi(0, "DevIconZip",                { fg = icon_color.package })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle left reveal<cr>", desc = "Toggle file tree" },
  },
  opts = {
    close_if_last_window  = true,
    popup_border_style    = "single",
    enable_git_status     = true,
    enable_diagnostics    = true,
    default_component_configs = {
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
        highlight = "NeoTreeFileIcon",
        folder_empty_open = "",
      },
      indent = { with_expanders = true, expander_collapsed = ">", expander_expanded = "v" },
      git_status = {
        symbols = {
          added = "+", modified = "~", deleted = "-", renamed = "r",
          untracked = "?", ignored = "i", unstaged = "!", staged = "+", conflict = "x",
        },
      },
    },
    window = {
      position = "left",
      width    = 32,
      mappings = {
        ["<space>"] = "none", ["<cr>"] = "open",  ["l"] = "open",
        ["h"] = "close_node", ["a"]   = "add",    ["d"] = "delete",
        ["r"] = "rename",     ["x"]   = "cut_to_clipboard",
        ["y"] = "copy_to_clipboard",  ["p"] = "paste_from_clipboard",
        ["q"] = "close_window",
      },
    },
    filesystem = {
      filtered_items        = { visible = true, hide_dotfiles = false, hide_gitignored = false },
      follow_current_file   = { enabled = true },
      use_libuv_file_watcher = true,
    },
  },
  config = function(_, opts)
    require("nvim-web-devicons").setup({
      color_icons = false,
      default = true,
      override = {
        default_icon = icon_spec("", icon_color.system, "Default"),
      },
      override_by_extension = {
        lua = icon_spec("", icon_color.code, "Lua"),
        rs = icon_spec("", icon_color.danger, "Rs"),
        go = icon_spec("", icon_color.data, "Go"),
        py = icon_spec("", icon_color.package, "Py"),
        js = icon_spec("", icon_color.package, "Js"),
        ts = icon_spec("", icon_color.code, "Ts"),
        tsx = icon_spec("", icon_color.code, "Tsx"),
        json = icon_spec("", icon_color.data, "Json"),
        toml = icon_spec("", icon_color.config, "Toml"),
        yaml = icon_spec("", icon_color.config, "Yaml"),
        yml = icon_spec("", icon_color.config, "Yaml"),
        md = icon_spec("", icon_color.docs, "Md"),
        png = icon_spec("󰸭", icon_color.media, "Png"),
        jpg = icon_spec("󰈥", icon_color.media, "Jpg"),
        jpeg = icon_spec("󰈥", icon_color.media, "Jpeg"),
        webp = icon_spec("󰈟", icon_color.media, "Webp"),
        svg = icon_spec("󰜡", icon_color.media, "Svg"),
        zip = icon_spec("", icon_color.package, "Zip"),
        lock = icon_spec("", icon_color.package, "Lock"),
      },
      override_by_filename = {
        [".env"] = icon_spec("󱁿", icon_color.secret, "Env"),
        [".gitignore"] = icon_spec("", icon_color.system, "GitIgnore"),
        [".gitconfig"] = icon_spec("", icon_color.config, "GitConfig"),
        ["README.md"] = icon_spec("󰂺", icon_color.docs, "Readme"),
        ["LICENSE"] = icon_spec("", icon_color.docs, "License"),
        ["Dockerfile"] = icon_spec("󰡨", icon_color.code, "Dockerfile"),
      },
    })
    require("neo-tree").setup(opts)
    set_tree_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = set_tree_highlights,
    })
  end,
}
