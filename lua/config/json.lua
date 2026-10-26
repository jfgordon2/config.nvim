-- Explicit JSON formatting also works inside buffers of other filetypes.
local M = {}

local function fail(message)
    vim.notify(message, vim.log.levels.ERROR, { title = 'JSON Format Error' })
end

-- Return formatted lines without editing the buffer, for Conform as well as cj.
function M.format_lines(lines, bufnr)
    bufnr = bufnr or 0
    local value = vim.json.decode(table.concat(lines, '\n'))
    local indent = vim.bo[bufnr].expandtab and (' '):rep(vim.api.nvim_buf_call(bufnr, vim.fn.shiftwidth)) or '\t'
    return vim.split(vim.json.encode(value, { indent = indent, sort_keys = false }), '\n', { plain = true })
end

local function format(lines)
    local ok, result = pcall(M.format_lines, lines)
    if not ok then
        fail(tostring(result))
        return
    end
    return result
end

function M.file()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local formatted = format(lines)
    if formatted and not vim.deep_equal(lines, formatted) then
        local view = vim.fn.winsaveview()
        vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted)
        vim.fn.winrestview(view)
    end
end

function M.selection()
    local mode = vim.fn.mode()
    if mode ~= 'v' and mode ~= 'V' then
        fail 'Select JSON using characterwise or linewise Visual mode'
        return
    end
    -- '< and '> still describe the previous selection while Visual mode is active.
    local first, last = vim.fn.getpos 'v', vim.fn.getpos '.'
    local opts = { type = mode, exclusive = vim.o.selection == 'exclusive' }
    local region = vim.fn.getregionpos(first, last, opts)
    local lines = vim.fn.getregion(first, last, opts)
    vim.cmd.normal { '\27', bang = true }

    local formatted = format(lines)
    if not formatted then
        return
    end
    local start_row, end_row = region[1][1][2] - 1, region[#region][2][2] - 1
    local first_line = vim.api.nvim_buf_get_lines(0, start_row, start_row + 1, false)[1]
    local indent = first_line:match '^%s*'
    local start_col = math.max(0, math.min(region[1][1][3] - 1, #first_line))
    for i = 1, #formatted do
        if i > 1 or mode == 'V' then
            formatted[i] = indent .. formatted[i]
        elseif start_col < #indent then
            formatted[i] = indent:sub(start_col + 1) .. formatted[i]
        end
    end
    if vim.deep_equal(lines, formatted) then
        return
    end
    local view = vim.fn.winsaveview()
    if mode == 'V' then
        vim.api.nvim_buf_set_lines(0, start_row, end_row + 1, false, formatted)
    else
        -- getregion accounts for exclusive selections and multibyte characters.
        local end_col = #lines[#lines] + (start_row == end_row and start_col or 0)
        vim.api.nvim_buf_set_text(0, start_row, start_col, end_row, end_col, formatted)
    end
    vim.fn.winrestview(view)
end

return M
