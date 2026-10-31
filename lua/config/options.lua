-- Options are automatically loaded before lazy.nvim startup.

local has = vim.fn.has
local executable = vim.fn.executable

if has("macunix") == 1 and executable("pbcopy") == 1 and executable("pbpaste") == 1 then
  vim.g.clipboard = "pbcopy"
elseif vim.env.WAYLAND_DISPLAY and executable("wl-copy") == 1 and executable("wl-paste") == 1 then
  vim.g.clipboard = "wl-copy"
else
  vim.g.clipboard = "osc52"
end

vim.opt.clipboard = "unnamedplus"

local function markdown_as_text()
  return "text",
    function(buf)
      vim.b[buf].markdown_plaintext = true
      vim.b[buf].autoformat = false
      vim.b[buf].completion = false
      vim.b[buf].minipairs_disable = true
    end
end

local markdown_extensions = {}
for _, extension in ipairs({ "md", "MD", "markdown", "mdown", "mkd", "mkdn", "mdwn", "mdx" }) do
  markdown_extensions[extension] = markdown_as_text
end
vim.filetype.add({ extension = markdown_extensions })
