-- Mode indicators with Nerd Font icon
local function mode_icon()
  local mode = vim.fn.mode()
  local modes = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    t = "TERMINAL",
    ["!"] = "SHELL",
    s = "SELECT",
    S = "SELECT",
    ["\19"] = "S-BLOCK",
    r = "REPLACE",
    R = "REPLACE",
  }
  return (modes[mode] or mode) .. " \u{e0b1} "
end

-- Git branch with caching with Nerd Font icon
local cached_branch = ""
local last_check = 0
local function git_branch()
  local now = vim.loop.now()
  if now - last_check > 5000 then -- check every 5 seconds
    cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
    last_check = now
  end
  if cached_branch ~= "" then
    return ("\u{e725} " .. cached_branch) .. " \u{e0b1} " -- nf-dev-git_branch
  end
  return ""
end

-- File type with Nerd Font icon
local function file_type()
  local ft = vim.bo.filetype
  local icons = {
    lua = "\u{f08b1} ", -- nf-md-language_lua
    typescript = "\u{f06e6} ", -- nf-md-language_typescript
    javascript = "\u{f031e} ", -- nf-md-language_javascript
    typescriptreact = "\u{e7ba} ", -- nf-dev-react
    javascriptreact = "\u{e7ba} ", -- nf-dev-react
    html = "\u{f031d} ", -- nf-md-language_html5
    css = "\u{e749} ", -- nf-dev-css3
    scss = "\u{e749} ", -- nf-dev-css3
    json = "\u{f0626} ", -- nf-md-code_json
    markdown = "\u{f0354} ", -- nf-md-language_markdown
    sql = "\u{f01bc} ", -- nf-md-database
    yaml = "\u{e8eb} ", -- nf-dev-yaml
    toml = "\u{e6b2} ", -- nf-custom-toml
    xml = "\u{f05c0} ", -- nf-md-xml
    dockerfile = "\u{f0868} ", -- nf-md-docker
    svelte = "\u{e8b7} ", -- nf-dev-svelte
    gitcommit = "\u{f417} ", -- nf-oct-git_commit
    gitconfig = "\u{e702} ", -- nf-dev-git
    python = "\u{e73c} ", -- nf-dev-python
    java = "\u{f0b37} ", -- nf-md-language_java
    go = "\u{f07d3} ", -- nf-md-language_go
    rust = "\u{f1617} ", -- nf-md-language_rust
    cpp = "\u{e61d} ", -- nf-custom-cpp
    c = "\u{e61e} ", -- nf-custom-c
    sh = "\u{e691} ", -- nf-seti-shell
    bash = "\u{e760} ", -- nf-dev-bash
    zsh = "\u{f489} ", -- nf-oct-terminal
    powershell = "\u{f0a0a} ", -- nf-md-powershell
  }
  if ft == "" then
    return "\u{ea7b} " -- nf-cod-file
  end
  return (icons[ft] or "\u{ea7b} ")
end

_G.mode_icon = mode_icon
_G.git_branch = git_branch
_G.file_type = file_type

vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

-- Status line build function on window focus
function setup_statusline()
  vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    callback = function()
      vim.opt_local.statusline = table.concat({
        " ",
        "%#StatusLineBold#",
        "%{v:lua.mode_icon()}",
        "%#StatusLine#",
        "%{v:lua.git_branch()}",
        "%{v:lua.file_type()}",
        "%f%h%m%r",
        " %= ", -- right-align starts
        "%l:%c \u{e0b3} %P "
      })
    end
  })
  vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })
  vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    callback = function()
      vim.opt_local.statusline = " %{v:lua.file_type()}%f%h%m%r %= %l:%c \u{e0b3} %P "
    end
  })
end
