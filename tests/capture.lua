_G.buffer_test_notifications = {}
local original = vim.notify
vim.notify = function(message, level, options)
    table.insert(_G.buffer_test_notifications, tostring(message))
    return original(message, level, options)
end
