-- lua/plugins/typescript.lua - VTSLS-specific commands
-- Ported from LazyVim.lsp.execute() to raw vim.lsp.buf_request()

local M = {}

-- Called from init.lua LspAttach when client.name == 'vtsls'
---@param buf number
---@param client vim.lsp.Client
function M.on_attach(buf, client)
  local map = vim.keymap.set

  -- gD: Go to source definition (bypasses .d.ts)
  map('n', 'gD', function()
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding or 'utf-16')
    client:request('workspace/executeCommand', {
      command = 'typescript.goToSourceDefinition',
      arguments = { params.textDocument.uri, params.position },
    }, function(err, result)
      if result and #result > 0 then
        vim.lsp.util.show_document(result[1], client.offset_encoding or 'utf-16', { focus = true })
      elseif err then
        vim.notify('goToSourceDefinition: ' .. (err.message or 'error'), vim.log.levels.WARN)
      end
    end, buf)
  end, { buffer = buf, desc = 'Goto Source Definition' })

  -- gR: Find all file references
  map('n', 'gR', function()
    client:request('workspace/executeCommand', {
      command = 'typescript.findAllFileReferences',
      arguments = { vim.uri_from_bufnr(buf) },
    }, function(err, result)
      if result then
        vim.fn.setqflist({}, ' ', {
          title = 'File References',
          items = vim.lsp.util.locations_to_items(result, client.offset_encoding or 'utf-16'),
        })
        vim.cmd('copen')
      elseif err then
        vim.notify('findAllFileReferences: ' .. (err.message or 'error'), vim.log.levels.WARN)
      end
    end, buf)
  end, { buffer = buf, desc = 'File References' })

  -- <Leader>cM: Add missing imports
  map('n', '<Leader>cM', function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { 'source.addMissingImports.ts' }, diagnostics = {} },
    })
  end, { buffer = buf, desc = 'Add missing imports' })

  -- <Leader>cD: Fix all diagnostics
  map('n', '<Leader>cD', function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { 'source.fixAll.ts' }, diagnostics = {} },
    })
  end, { buffer = buf, desc = 'Fix all diagnostics' })

  -- <Leader>cV: Select TypeScript version
  map('n', '<Leader>cV', function()
    client:request('workspace/executeCommand', {
      command = 'typescript.selectTypeScriptVersion',
    }, nil, buf)
  end, { buffer = buf, desc = 'Select TS workspace version' })

  -- moveToFile refactoring command handler
  client.commands = client.commands or {}
  client.commands['_typescript.moveToFileRefactoring'] = function(command, ctx)
    ---@type string, string, lsp.Range
    local action, uri, range = unpack(command.arguments)

    local function move(newf)
      client:request('workspace/executeCommand', {
        command = command.command,
        arguments = { action, uri, range, newf },
      })
    end

    local fname = vim.uri_to_fname(uri)
    client:request('workspace/executeCommand', {
      command = 'typescript.tsserverRequest',
      arguments = {
        'getMoveToRefactoringFileSuggestions',
        {
          file = fname,
          startLine = range.start.line + 1,
          startOffset = range.start.character + 1,
          endLine = range['end'].line + 1,
          endOffset = range['end'].character + 1,
        },
      },
    }, function(_, result)
      ---@type string[]
      local files = result.body.files
      table.insert(files, 1, 'Enter new path...')
      vim.ui.select(files, {
        prompt = 'Select move destination:',
        format_item = function(f)
          return vim.fn.fnamemodify(f, ':~:.')
        end,
      }, function(f)
        if f and f:find('^Enter new path') then
          vim.ui.input({
            prompt = 'Enter move destination:',
            default = vim.fn.fnamemodify(fname, ':h') .. '/',
            completion = 'file',
          }, function(newf)
            return newf and move(newf)
          end)
        elseif f then
          move(f)
        end
      end)
    end)
  end
end

return M
