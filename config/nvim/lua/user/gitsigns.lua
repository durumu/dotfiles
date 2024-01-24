-- document existing key chains
require("which-key").register({
    ["<leader>g"] = { name = "[G]it", _ = "which_key_ignore" },
    ["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },
    ["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
})
-- register which-key VISUAL mode
-- required for visual <leader>hs (hunk stage) to work
require("which-key").register({
    ["<leader>"] = { name = "VISUAL <leader>" },
    ["<leader>h"] = { "Git [H]unk" },
}, { mode = "v" })

require("gitsigns").setup({
    -- See `:help gitsigns.txt`
    signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "≃" },
    },
    on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ "n", "v" }, "]g", function()
            if vim.wo.diff then
                return "]g"
            end
            vim.schedule(function()
                gs.next_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Jump to next hunk" })

        map({ "n", "v" }, "[g", function()
            if vim.wo.diff then
                return "[g"
            end
            vim.schedule(function()
                gs.prev_hunk()
            end)
            return "<Ignore>"
        end, { expr = true, desc = "Jump to previous hunk" })

        -- Hunk Actions
        -- visual mode
        map("v", "<leader>hs", function()
            gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "stage git hunk" })
        map("v", "<leader>hr", function()
            gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "reset git hunk" })
        -- normal mode
        map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })

        -- Git Actions
        map("n", "<leader>gd", gs.diffthis, { desc = "git diff against index" })
        map("n", "<leader>gD", function()
            gs.diffthis("~")
        end, { desc = "git Diff against last commit" })
        map("n", "<leader>gm", function()
            gs.blame_line({ full = false })
        end, { desc = "git blame line" })
        map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })

        -- Toggles
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })

        -- Text object
        map({ "o", "x" }, "ih", function()
            vim.cmd.Gitsigns("select hunk")
        end, { desc = "select git hunk" })
    end,
})
