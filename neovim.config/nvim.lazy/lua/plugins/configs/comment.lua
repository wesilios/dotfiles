-- Commenting uses Neovim's built-in `gc` (0.10+): treesitter-aware, so JSX/TSX/Vue/Razor
-- injections pick the right commentstring. Comment.nvim (archived) failed with
-- "[Comment.nvim] nil" on the nvim-treesitter `main` branch, so it was removed.
--   gcc        toggle line        gc{motion} / {Visual}gc  toggle range
-- The built-in has no gco/gcO/gcA, so keep those from the old setup:
local map = vim.keymap.set

-- Append a comment (using 'commentstring') to the current line and start typing inside it
local function append_comment()
  local left, right = vim.bo.commentstring:match('^(.-)%s*%%s%s*(.-)$')
  if not left or left == '' then
    vim.notify('No commentstring for filetype ' .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end
  local line = vim.api.nvim_get_current_line()
  local sep = line:match('%S') and ' ' or ''
  local suffix = right ~= '' and (' ' .. right) or ''
  vim.api.nvim_set_current_line(line .. sep .. left .. ' ' .. suffix)
  vim.cmd('startinsert!')
  if suffix ~= '' then
    vim.api.nvim_feedkeys(vim.keycode(('<Left>'):rep(#suffix)), 'n', false)
  end
end

map('n', 'gco', function()
  vim.cmd('normal! o')
  append_comment()
end, { desc = 'Comment line below' })

map('n', 'gcO', function()
  vim.cmd('normal! O')
  append_comment()
end, { desc = 'Comment line above' })

map('n', 'gcA', append_comment, { desc = 'Comment end of line' })
