-- lua/float_term.lua - reusable floating terminal for interactive TUIs
-- Usage: require('float_term').toggle('lazygit', { 'lazygit' })
local M = {}

local states = {}

-- Oil skips its own WinLeave auto-close when focus moves to another floating
-- window, so close any open Oil float before layering a terminal float.
local function close_oil_floats()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.w[win].is_oil_win then
      vim.api.nvim_win_close(win, true)
    end
  end
end

function M.toggle(key, cmd)
  local state = states[key]
  if state and state.win and vim.api.nvim_win_is_valid(state.win) then
    vim.api.nvim_win_close(state.win, true)
    state.win = nil
    return
  end

  close_oil_floats()

  local width = math.max(20, math.floor(vim.o.columns * 0.9))
  local height = math.max(5, math.floor(vim.o.lines * 0.85))
  local row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1)
  local col = math.floor((vim.o.columns - width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = row,
    col = col,
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
  })
  states[key] = { win = win, buf = buf }

  vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function()
      vim.schedule(function()
        local s = states[key]
        if not s then
          return
        end
        if s.win and vim.api.nvim_win_is_valid(s.win) then
          vim.api.nvim_win_close(s.win, true)
        end
        if s.buf and vim.api.nvim_buf_is_valid(s.buf) then
          vim.api.nvim_buf_delete(s.buf, { force = true })
        end
        states[key] = nil
      end)
    end,
  })

  vim.cmd.startinsert()
end

return M
