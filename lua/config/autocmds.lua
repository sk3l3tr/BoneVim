-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("bonevim_markdown_plaintext", { clear = true }),
  pattern = "text",
  callback = function(event)
    if not vim.b[event.buf].markdown_plaintext then
      return
    end
    vim.opt_local.spell = false
    vim.opt_local.conceallevel = 0
    vim.bo[event.buf].syntax = ""
    vim.bo[event.buf].formatoptions = ""
    vim.bo[event.buf].textwidth = 0
    vim.bo[event.buf].comments = ""
  end,
})
