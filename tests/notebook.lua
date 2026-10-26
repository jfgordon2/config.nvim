-- Open a real notebook as the first buffer, edit a cell, and save valid JSON.
local function run()
    local buf = vim.api.nvim_get_current_buf()
    local path = vim.api.nvim_buf_get_name(buf)
    assert(vim.bo.filetype == 'ipynb', 'notebook facade did not open on the first read')
    local state = assert(require('ipynb').get_state(), 'notebook state is missing')
    assert(state.facade_buf == buf and #state.cells == 2, 'notebook cells were not loaded')
    assert(state.cells[1].source == 'value = 1\n', 'code cell source was changed on read')
    assert(state.cells[2].source == '# Notes\n', 'Markdown cell source was changed on read')
    assert(not state.kernel, 'opening a notebook should not start a kernel')
    assert(vim.treesitter.get_parser(buf, 'ipynb'):parse()[1], 'notebook parser is unavailable')
    assert(vim.fn.exists ':NotebookKernelStart' == 2, 'notebook commands are missing')
    assert(vim.fn.maparg('<leader>ks', 'n', false, true).buffer == 1, 'notebook keys must be buffer-local')

    vim.api.nvim_win_set_cursor(0, { 2, 0 })
    require('ipynb.edit').open(state, 'normal')
    local edit = assert(state.edit_state, 'cell editing did not open')
    assert(vim.bo[edit.buf].filetype == 'python', 'code cell editor has the wrong filetype')
    local keys = vim.api.nvim_replace_termcodes('gg0ccvalue = 42<Esc>', true, false, true)
    vim.api.nvim_feedkeys(keys, 'xt', false)
    -- Flush the normal-mode edit event while this headless callback is running.
    vim.api.nvim_exec_autocmds('TextChanged', { buffer = edit.buf, modeline = false })
    assert(
        vim.wait(3000, function()
            return state.cells[1].source == 'value = 42\n'
        end),
        'cell edits did not sync: ' .. vim.inspect { source = state.cells[1].source, lines = vim.api.nvim_buf_get_lines(edit.buf, 0, -1, false) }
    )
    require('ipynb.edit').close(state)
    vim.api.nvim_set_current_buf(buf)
    vim.cmd 'write'

    local saved = vim.json.decode(table.concat(vim.fn.readfile(path), '\n'))
    assert(saved.nbformat == 4 and saved.nbformat_minor >= 5, 'saved notebook format is invalid')
    assert(#saved.cells == 2 and saved.cells[1].id == 'code-cell' and saved.cells[2].id == 'markdown-cell', 'cell IDs changed')
    assert(table.concat(saved.cells[1].source) == 'value = 42\n', 'saved code does not match the edit')
    assert(table.concat(saved.cells[2].source) == '# Notes\n', 'saving changed another cell')
    assert(saved.metadata.custom.retained and saved.cells[1].metadata.tag == 'keep', 'notebook metadata was lost')
    assert(not vim.bo.modified, 'saved notebook remains marked as modified')
    vim.cmd 'enew'
    assert(vim.fn.exists ':NotebookKernelStart' == 0, 'notebook commands leaked to another buffer')
    assert(vim.v.errmsg == '', vim.v.errmsg)
    print 'PASS: notebook first read, parser, cell editing, metadata-preserving save, and buffer-local commands'
end

vim.defer_fn(function()
    local ok, err = xpcall(run, debug.traceback)
    if not ok then
        io.stderr:write(err .. '\n')
        vim.cmd 'cquit 1'
    else
        vim.cmd 'qa!'
    end
end, 500)
