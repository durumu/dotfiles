-- [[ Configure LSP ]]
-- from https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    -- Function that lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    local nmap = function(keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end

        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", vim.lsp.buf.references, "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")

    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
end

-- document existing key chains
require("which-key").register({
    ["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
    ["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
})

local sign_gutter_character = {
    DiagnosticSignError = "",
    DiagnosticSignWarn = "",
    DiagnosticSignHint = "",
    DiagnosticSignInfo = "",
}
for sign, char in pairs(sign_gutter_character) do
    vim.fn.sign_define(sign, { text = char, texthl = sign, linehl = "", numhl = "" })
end

local lsp = require("lspconfig")

lsp.pyright.setup({
    cmd = { "/Users/presley/tools/venvs/main/bin/pyright-langserver", "--stdio" },
    on_attach = on_attach,
    settings = {
        python = {
            pythonPath = vim.g.python3_host_prog,
            analysis = {
                diagnosticMode = "openFilesOnly",
                stubPath = vim.fs.joinpath(
                    tostring(vim.fn.stdpath("data")),
                    "lazy",
                    "python-type-stubs"
                ),
            },
        },
    },
})

local organize_augroup = "organize_imports"
lsp.ruff_lsp.setup({
    cmd = { "/Users/presley/tools/venvs/main/bin/ruff-lsp" },
    on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false

        vim.api.nvim_clear_autocmds({ group = organize_augroup, buffer = bufnr })

        on_attach(client, bufnr)

        local perform_code_action_titled = function(title)
            vim.lsp.buf.code_action({
                filter = function(code_action)
                    return code_action.title == title
                end,
                apply = true,
            })
        end

        vim.api.nvim_create_autocmd("BufWritePre", {
            desc = "Automatically organize imports on save",
            group = organize_augroup,
            buffer = bufnr,
            callback = function()
                perform_code_action_titled("Ruff: Organize Imports")
            end,
        })

        vim.api.nvim_buf_create_user_command(bufnr, "T", function()
            perform_code_action_titled("Ruff: Fix All")
        end, { desc = "Fix all" })
    end,
})

lsp.rust_analyzer.setup({
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            trace = { server = "verbose" },
        },
    },
})

lsp.clangd.setup({
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "A", function()
            vim.cmd([[ClangdSwitchSourceHeader]])
        end, { desc = "Switch between source and header" })
    end,
    settings = { clangd = { fallbackFlags = { "-std=c++2a" } } },
})

lsp.gopls.setup({
    on_attach = on_attach,
    settings = {
        gopls = {
            analyses = { unusedparams = true },
            staticcheck = true,
            gofumpt = true,
        },
    },
})

-- This setup is intended for neovim plugins
lsp.lua_ls.setup({
    on_attach = on_attach,
    settings = {
        Lua = {
            format = { enable = false }, -- I use stylua
            runtime = { version = "LuaJIT" }, -- Neovim uses LuaJIT
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
        },
    },
})

lsp.zls.setup({ on_attach = on_attach })
