local fzf = require("fzf-lua")

vim.api.nvim_create_user_command("Fzf", fzf.resume, { desc = "Resume previous fzf session" })

vim.keymap.set(
    { "n" },
    "<leader>fa",
    function() fzf.lsp_code_actions() end,
    { desc = "[F]zf: Code [A]ction" }
)
vim.keymap.set(
    { "n" },
    "<leader>fb",
    function() fzf.lsp_document_symbols() end,
    { desc = "[F]zf: [B]uffers" }
)
vim.keymap.set(
    { "n" },
    "<leader>fd",
    function() fzf.lsp_document_symbols() end,
    { desc = "[F]zf: [D]ocument Symbols" }
)
vim.keymap.set(
    { "n" },
    "<leader>fw",
    function() fzf.lsp_workspace_symbols() end,
    { desc = "[F]zf: [W]orkspace Symbols" }
)

vim.keymap.set(
    { "n" },
    "<leader>rg",
    fzf.live_grep_native,
    { desc = "[R]ip[g]rep codebase", silent = true }
)

-- like s.strip() in python
local function strip(s) return (s:gsub("^%s*(.-)%s*$", "%1")) end

vim.keymap.set(
    { "v" },
    "<leader>rg",
    function()
        fzf.live_grep_native({
            search = strip(fzf.utils.get_visual_selection()),
        })
    end,
    { silent = true }
)

local function get_store_name()
    -- We hash the current directory to come up with a store name.
    return vim.fn.system("pwd | md5sum | awk '{print $1}'")
end

local function fzf_mru(opts)
    opts = fzf.config.normalize_opts(opts, fzf.config.globals.files)

    local fre = "fre --store_name " .. get_store_name()
    local no_dups = [[awk '!x[$0]++']] -- remove dups, but keep order
    -- todo: not sure why i need the zsh call here?
    opts.cmd = [[zsh -c "cat <(]] .. fre .. [[ --sorted) <(fd -t f)" | ]] .. no_dups

    opts.fzf_opts = vim.tbl_extend("force", opts.fzf_opts, {
        ["--tiebreak"] = "index", -- make sure that items towards top are from history
    })
    opts.actions = vim.tbl_extend("force", opts.actions or {}, {
        ["ctrl-d"] = {
            -- Ctrl-d to remove from history
            function(sel)
                if #sel < 1 then
                    return
                end
                vim.fn.system(fre .. " --delete " .. sel[1])
            end,
            -- This will refresh the list
            fzf.actions.resume,
        },
    })

    -- this returns a coroutine, not sure what to do with it
    fzf.core.fzf_wrap(opts, opts.cmd, function(selected)
        if not selected or #selected < 2 then
            return
        end
        vim.fn.system(fre .. " --add " .. selected[2])
        fzf.actions.act(selected, opts)
    end)
end

vim.keymap.set("n", "<C-p>", fzf_mru, { desc = "Open Files" })

-- also, need to install: rg, fre, fzf, fd
fzf.setup({})
