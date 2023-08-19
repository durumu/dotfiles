local M = {}

function with_saved_cursor(func)
    local current_pos = vim.api.nvim_win_get_cursor(0) -- Save current cursor position

    func()

    vim.api.nvim_win_set_cursor(0, current_pos) -- Restore cursor position
end

M.delete_trailing_whitespace = function()
    with_saved_cursor(function()
        -- Execute the substitution command across the whole buffer to remove trailing whitespace
        vim.api.nvim_command(":%s/\\s\\+$//e")
    end)
end

M.in_git_repo = function()
    local handle = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null")
    local result = handle:read("*a")
    handle:close()

    -- Trim the result
    result = string.gsub(result, "^%s*(.-)%s*$", "%1")

    return result == "true"
end

return M
