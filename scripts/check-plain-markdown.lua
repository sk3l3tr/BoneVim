-- Run from this repository: nvim --headless -u init.lua README.md "+luafile scripts/check-plain-markdown.lua" +qa
local directory = vim.fn.tempname()
vim.fn.mkdir(directory, "p")

local ok, err = xpcall(function()
  local plugins = require("lazy.core.config").plugins
  assert(not plugins["markdown-preview.nvim"], "Markdown preview is still configured")
  assert(not plugins["render-markdown.nvim"], "Markdown rendering is still configured")

  local function check_plaintext()
    assert(vim.bo.filetype == "text", "Markdown must open as text")
    assert(vim.b.markdown_plaintext and vim.b.autoformat == false)
    assert(vim.b.completion == false and vim.b.minipairs_disable)
    assert(not vim.wo.spell and vim.wo.conceallevel == 0)
    assert(vim.bo.formatoptions == "" and vim.bo.textwidth == 0 and vim.bo.comments == "")
    assert(vim.b.current_syntax == nil, "Syntax highlighting is active")
    assert(not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()])
    assert(#vim.lsp.get_clients({ bufnr = 0 }) == 0, "A language server attached to Markdown")
  end

  -- Check the file passed at startup before testing subsequent buffer openings.
  check_plaintext()
  local content = { "# Heading", "", "- item  ", "  **literal text**", "```lua", "print('hello')", "```" }
  for _, extension in ipairs({ "md", "MD", "markdown", "mdown", "mkd", "mkdn", "mdwn", "mdx" }) do
    local filename = directory .. "/existing." .. extension
    vim.fn.writefile(content, filename)
    vim.cmd.edit(vim.fn.fnameescape(filename))
    check_plaintext()
    assert(vim.fn.synID(1, 1, 1) == 0, "Heading has syntax highlighting")
    vim.cmd.write()
    assert(vim.deep_equal(vim.fn.readfile(filename), content), "Saving changed Markdown content")

    vim.cmd.edit(vim.fn.fnameescape(directory .. "/new." .. extension))
    check_plaintext()
  end

  for extension, filetype in pairs({ lua = "lua", json = "json", txt = "text" }) do
    vim.cmd.edit(vim.fn.fnameescape(directory .. "/unrelated." .. extension))
    assert(vim.bo.filetype == filetype, "Unrelated filetype changed: " .. extension)
    assert(vim.b.markdown_plaintext == nil, "Markdown settings leaked into " .. extension)
    assert(vim.b.autoformat ~= false and vim.b.completion ~= false)
  end
end, debug.traceback)

vim.cmd("enew!")
vim.fn.delete(directory, "rf")
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd("cquit 1")
end
print("Markdown plain-text checks passed")
