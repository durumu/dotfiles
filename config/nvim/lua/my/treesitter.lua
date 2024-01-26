require("nvim-treesitter.configs").setup({
    modules = {},
    sync_install = false,
    ensure_installed = "all",
    auto_install = true,
    ignore_install = {},
    highlight = { enable = true },
    indent = { enable = true },
    textobjects = {
        select = {
            enable = true,
            keymaps = {
                ["i,"] = "@parameter.inner",
                ["a,"] = "@parameter.outer",
                ["ia"] = "@attribute.inner",
                ["aa"] = "@attribute.outer",
                ["ic"] = "@comment.inner",
                ["ac"] = "@comment.outer",
                ["if"] = "@function.inner",
                ["af"] = "@function.outer",
                ["il"] = "@class.inner",
                ["al"] = "@class.outer",
                ["ix"] = "@call.inner",
                ["ax"] = "@call.outer",
            },
        },
    },
})
