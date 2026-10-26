-- Buffer actions shared by global mappings and Bufferline.
local M = {}
function M.delete(buffer)
    Snacks.bufdelete(buffer)
end
function M.others()
    Snacks.bufdelete.other()
end
return M
