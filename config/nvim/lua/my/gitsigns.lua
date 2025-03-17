require("gitsigns").setup({
    -- See `:help gitsigns.txt`
    on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            if opts.desc then
                opts.desc = "GitSigns: " .. opts.desc
            end
            vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map({ "n", "v" }, "]h", function()
            if vim.wo.diff then
                return "]h"
            end
            vim.schedule(function() gs.next_hunk() end)
            return "<Ignore>"
        end, { expr = true, desc = "Jump to next hunk" })

        map({ "n", "v" }, "[h", function()
            if vim.wo.diff then
                return "[h"
            end
            vim.schedule(function() gs.prev_hunk() end)
            return "<Ignore>"
        end, { expr = true, desc = "Jump to previous hunk" })

        -- Hunk Actions
        -- visual mode
        map(
            "v",
            "<leader>hs",
            function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            { desc = "stage git hunk" }
        )
        map(
            "v",
            "<leader>hr",
            function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
            { desc = "reset git hunk" }
        )
        -- normal mode
        map("n", "<leader>hs", gs.stage_hunk, { desc = "git stage hunk" })
        map("n", "<leader>hr", gs.reset_hunk, { desc = "git reset hunk" })
        map("n", "<leader>hS", gs.stage_buffer, { desc = "git Stage buffer" })
        map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
        map("n", "<leader>hp", gs.preview_hunk, { desc = "preview git hunk" })

        -- Git Actions
        map("n", "<leader>gd", gs.diffthis, { desc = "git diff against index" })
        map(
            "n",
            "<leader>gD",
            function() gs.diffthis("~") end,
            { desc = "git Diff against last commit" }
        )
        map(
            "n",
            "<leader>gm",
            function() gs.blame_line({ full = false }) end,
            { desc = "git blame line" }
        )
        map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })

        -- Toggles
        map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
        map("n", "<leader>td", gs.toggle_deleted, { desc = "toggle git show deleted" })
        map("n", "<leader>tw", gs.toggle_word_diff, { desc = "toggle word diff " })

        -- Text object
        map(
            { "o", "x" },
            "ih",
            function() vim.cmd.Gitsigns("select hunk") end,
            { desc = "select git hunk" }
        )
        map(
            { "o", "x" },
            "ah",
            function() vim.cmd.Gitsigns("select hunk") end,
            { desc = "select git hunk" }
        )
    end,
})
