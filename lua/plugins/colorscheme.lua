return {
  -- Native colorscheme in ~/.config/nvim/colors/skeletor-cyan.lua
  -- No third-party colorscheme plugin is needed.
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "skeletor-cyan" },
  },

  -- Use the shared BoneVim palette for lualine's mode indicator too.
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      local p = require("skeletor.palette")
      local base = { fg = p.fg, bg = "NONE" }
      local inactive = { fg = p.comment, bg = "NONE" }
      local function mode(color)
        return {
          a = { fg = p.bg, bg = color, gui = "bold" },
          b = { fg = color, bg = p.surface },
          c = base,
        }
      end
      opts.options.theme = {
        normal = mode(p.cyan),
        insert = mode(p.violet),
        visual = mode(p.cyan),
        replace = mode(p.delete),
        command = mode(p.amber),
        terminal = mode(p.blue),
        inactive = { a = inactive, b = inactive, c = inactive },
      }
    end,
  },
}
