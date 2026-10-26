-- Exercise the actual mappings, including active Visual selections and undo.
local config = vim.env.NVIM_JSON_TEST_CONFIG or vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ':p:h:h')
vim.opt.rtp:prepend(config)
if vim.env.NVIM_JSON_TEST_OVERLAY then
    vim.opt.rtp:prepend(vim.env.NVIM_JSON_TEST_OVERLAY)
end
vim.g.mapleader = ' '
require 'config.keymaps'
if not package.loaded.conform then
    local data = vim.fn.stdpath 'data'
    vim.opt.rtp:append(data .. '/site/pack/core/opt/conform.nvim')
    vim.env.PATH = data .. '/mason/bin:' .. vim.env.PATH
    require 'plugins.lsp.formatting'()
end

local notices, checks = {}, 0
vim.notify = function(message, level)
    notices[#notices + 1] = { message = message, level = level }
end
local function keys(value)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(value, true, false, true), 'xt', false)
end
local function buffer(lines)
    keys '<Esc>'
    vim.cmd 'enew!'
    vim.bo.swapfile = false
    vim.bo.undofile = false
    vim.bo.bufhidden = 'wipe'
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.bo.modified = false
    notices = {}
    vim.o.selection = 'inclusive'
end
local function expect(expected, message)
    checks = checks + 1
    assert(vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), expected), message .. '\n' .. vim.inspect(vim.api.nvim_buf_get_lines(0, 0, -1, false)))
end
local function select(first, last, mode)
    vim.api.nvim_win_set_cursor(0, first)
    keys(mode or 'v')
    vim.api.nvim_win_set_cursor(0, last)
    keys ' cj'
    keys '<Esc>'
end

local function run()
    buffer { '{"items":[true,null,"雪"]}' }
    keys ' cj'
    expect({ '{', '  "items": [', '    true,', '    null,', '    "雪"', '  ]', '}' }, 'normal mapping formats JSON without adding a blank line')
    assert(#notices == 0, 'valid JSON should not report an error')
    keys 'u'
    expect({ '{"items":[true,null,"雪"]}' }, 'formatting is one undo step')
    keys '<C-r>'
    vim.bo.modified = false
    keys ' cj'
    assert(not vim.bo.modified, 'formatting already formatted JSON should be a no-op')
    checks = checks + 2

    buffer { 'unrelated previous selection', '    {"a":1}', 'untouched' }
    select({ 1, 0 }, { 1, 8 }) -- Seed stale visual marks with a different selection.
    notices = {}
    select({ 2, 0 }, { 2, 0 }, 'V')
    expect(
        { 'unrelated previous selection', '    {', '      "a": 1', '    }', 'untouched' },
        'linewise mapping uses the active selection and preserves indentation'
    )
    assert(#notices == 0, 'the previous selection must not be parsed')
    checks = checks + 1

    local embedded = '    const data = {"a":1}; // suffix'
    local first = assert(embedded:find('{', 1, true)) - 1
    local last = assert(embedded:find('}', 1, true)) - 1
    for _, reverse in ipairs { false, true } do
        buffer { 'before', embedded, 'after' }
        vim.fn.setreg('z', 'keep register')
        select({ 2, reverse and last or first }, { 2, reverse and first or last })
        expect(
            { 'before', '    const data = {', '      "a": 1', '    }; // suffix', 'after' },
            'characterwise mapping preserves surrounding text in either direction'
        )
        assert(vim.fn.getreg 'z' == 'keep register', 'formatting should preserve registers')
        checks = checks + 1
    end

    buffer { embedded }
    vim.o.selection = 'exclusive'
    select({ 1, first }, { 1, last + 1 })
    expect({ '    const data = {', '      "a": 1', '    }; // suffix' }, 'exclusive selection stops before the following character')

    local unicode = 'print("é🙂", {"value":"雪"})'
    buffer { unicode }
    select({ 1, assert(unicode:find('{', 1, true)) - 1 }, { 1, assert(unicode:find('}', 1, true)) - 1 })
    expect({ 'print("é🙂", {', '  "value": "雪"', '})' }, 'character ranges use byte positions and preserve Unicode')

    buffer { 'prefix {"a":', '{"b":[2,3]}} suffix' }
    select({ 1, 7 }, { 2, 11 })
    expect({ 'prefix {', '  "a": {', '    "b": [', '      2,', '      3', '    ]', '  }', '} suffix' }, 'multiline characterwise selection preserves both ends')

    for _, value in ipairs { '{"a":}', '  ', '' } do
        buffer { value }
        keys ' cj'
        expect({ value }, 'invalid or empty JSON must not change the buffer')
        assert(#notices == 1 and notices[1].level == vim.log.levels.ERROR, 'invalid JSON reports a useful error')
        checks = checks + 1
    end

    buffer { 'prefix {"a":} suffix' }
    select({ 1, 7 }, { 1, 12 })
    expect({ 'prefix {"a":} suffix' }, 'invalid selected JSON must not change the buffer')
    assert(#notices == 1, 'invalid selection reports an error')
    checks = checks + 1

    buffer { '{"a":1}' }
    local path = vim.env.PATH
    vim.env.PATH = '/nonexistent'
    keys ' cj'
    vim.env.PATH = path
    expect({ '{', '  "a": 1', '}' }, 'native formatting works without external executables')
    assert(#notices == 0, 'native formatting should not require jq')
    checks = checks + 1

    buffer { '{"a":1}' }
    keys ' c4'
    keys ' cj'
    expect({ '{', '    "a": 1', '}' }, 'formatting follows the four-space buffer mapping')
    keys ' ct'
    keys ' cj'
    expect({ '{', '\t"a": 1', '}' }, 'formatting follows the hard-tab buffer mapping')

    local tabbed = '\tconst data = {"a":1};'
    buffer { tabbed }
    keys ' ct'
    select({ 1, assert(tabbed:find('{', 1, true)) - 1 }, { 1, assert(tabbed:find('}', 1, true)) - 1 })
    expect({ '\tconst data = {', '\t\t"a": 1', '\t};' }, 'selected JSON follows tab settings and keeps surrounding indentation')

    buffer { '{"a":1}' }
    vim.bo.shiftwidth = 0
    vim.bo.tabstop = 3
    keys ' cj'
    expect({ '{', '   "a": 1', '}' }, 'zero shiftwidth uses the buffer tabstop')

    buffer { '{"z":{},"a":[null,false,[],{"empty":{}}]}' }
    keys ' cj'
    local decoded = vim.json.decode(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n'))
    assert(
        vim.deep_equal(decoded, { z = vim.empty_dict(), a = { vim.NIL, false, {}, { empty = vim.empty_dict() } } }),
        'native formatting preserves null, booleans, empty arrays and objects'
    )
    checks = checks + 1
    for _, value in ipairs { 'null', 'false', 'true', '[]', '{}', '42', '"雪"' } do
        buffer { value }
        keys ' cj'
        expect({ value }, 'valid JSON scalar or empty container is preserved')
        assert(#notices == 0, 'valid JSON scalar or container should not report an error')
        checks = checks + 1
    end

    buffer { '{"a":1}' }
    select({ 1, 0 }, { 1, 6 }, '<C-v>')
    expect({ '{"a":1}' }, 'blockwise selection must not replace unrelated text')
    assert(#notices == 1, 'blockwise selection asks for a contiguous selection')
    checks = checks + 1

    buffer { '{"a":{"z":2}}' }
    vim.bo.filetype = 'json'
    keys ' c4'
    keys ' cf'
    local expanded = { '{', '    "a": {', '        "z": 2', '    }', '}' }
    assert(
        vim.wait(1000, function()
            return vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), expanded)
        end),
        'cf formats JSON with the native formatter and buffer indentation'
    )
    expect(expanded, 'cf expands JSON consistently with cj')
    keys ' cF'
    assert(notices[#notices].message == 'Formatters to run: json_native', 'formatter inspection reports native JSON')
    checks = checks + 1

    buffer { '{"a":1}' }
    vim.bo.filetype = 'json'
    keys ' ct'
    keys ' cf'
    assert(
        vim.wait(1000, function()
            return vim.api.nvim_buf_get_lines(0, 1, 2, false)[1] == '\t"a": 1'
        end),
        'cf respects hard-tab indentation for JSON'
    )
    expect({ '{', '\t"a": 1', '}' }, 'cf formats JSON with tabs')

    buffer { '{"a":}' }
    vim.bo.filetype = 'json'
    keys ' cf'
    assert(
        vim.wait(1000, function()
            return #notices > 0
        end),
        'invalid JSON from cf reports a formatting error'
    )
    expect({ '{"a":}' }, 'cf leaves invalid JSON unchanged')

    buffer { '{"a":1}' }
    vim.bo.filetype = 'json'
    local save_path = vim.fn.tempname() .. '.json'
    vim.api.nvim_buf_set_name(0, save_path)
    vim.cmd 'write'
    assert(vim.deep_equal(vim.fn.readfile(save_path), { '{', '  "a": 1', '}' }), 'JSON format-on-save uses the native formatter')
    vim.fn.delete(save_path)
    checks = checks + 1

    -- Conform can format a hidden buffer with different indentation settings.
    local target = vim.api.nvim_create_buf(true, false)
    vim.bo[target].filetype = 'json'
    vim.bo[target].expandtab = true
    vim.bo[target].shiftwidth = 6
    vim.api.nvim_buf_set_lines(target, 0, -1, false, { '{"a":1}' })
    vim.bo.shiftwidth = 2
    local format_error
    require('conform').format({ bufnr = target, async = false }, function(err)
        format_error = err
    end)
    assert(not format_error, tostring(format_error))
    assert(vim.deep_equal(vim.api.nvim_buf_get_lines(target, 0, -1, false), { '{', '      "a": 1', '}' }), 'formatting uses the target buffer options')
    vim.api.nvim_buf_delete(target, { force = true })
    checks = checks + 1

    buffer { '// Keep this comment', '{"b":2,"a":1}' }
    vim.bo.filetype = 'jsonc'
    keys ' cf'
    assert(
        vim.wait(3000, function()
            return vim.api.nvim_buf_get_lines(0, 1, 2, false)[1] ~= '{"b":2,"a":1}' or #notices > 0
        end),
        'JSONC formatter completes'
    )
    assert(#notices == 0, vim.inspect(notices))
    assert(vim.api.nvim_buf_get_lines(0, 0, 1, false)[1] == '// Keep this comment', 'cf preserves JSONC comments')
    assert(vim.api.nvim_buf_get_lines(0, 1, 2, false)[1] ~= '{"b":2,"a":1}', 'cf formats JSONC through Biome')
    checks = checks + 2
    print(('PASS: %d JSON mapping checks'):format(checks))
end

local ok, error = xpcall(run, debug.traceback)
if not ok then
    vim.api.nvim_err_writeln(error)
    vim.cmd 'cquit 1'
else
    vim.cmd 'qa!'
end
