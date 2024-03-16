--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        if opts.desc then
            opts.desc = "LSP: " .. opts.desc
        end
        vim.keymap.set(mode, l, r, opts)
    end

    map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "[R]e[n]ame" })

    map("n", "gd", vim.lsp.buf.definition, { desc = "[G]oto [D]efinition" })
    map("n", "gr", vim.lsp.buf.references, { desc = "[G]oto [R]eferences" })
    map("n", "gI", vim.lsp.buf.implementation, { desc = "[G]oto [I]mplementation" })

    map("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
    map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature Documentation" })

    vim.api.nvim_buf_create_user_command(
        bufnr,
        "T",
        function()
            vim.lsp.buf.code_action({
                context = { only = { "source.fixAll" } },
                apply = true,
            })
        end,
        { desc = "Fix all" }
    )
end

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

-- python is installed at venv_root .. "/bin/python3"
local venv_root = vim.fs.dirname(vim.fs.dirname(vim.g.python3_host_prog))

lsp.pyright.setup({
    cmd = { vim.fs.joinpath(venv_root, "bin", "pyright-langserver"), "--stdio" },
    on_attach = on_attach,
    settings = {
        python = {
            pythonPath = vim.g.python3_host_prog,
            analysis = {
                diagnosticMode = "openFilesOnly",
                stubPath = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "python-type-stubs"),
            },
        },
    },
})

lsp.ruff_lsp.setup({
    cmd = { vim.fs.joinpath(venv_root, "bin", "ruff"), "--server" },
    on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false

        local organize_augroup = vim.api.nvim_create_augroup("organize_imports", { clear = true })

        on_attach(client, bufnr)

        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            group = organize_augroup,
            callback = function()
                vim.lsp.buf.code_action({
                    context = { only = { "source.organizeImports" } },
                    apply = true,
                })
            end,
            desc = "Automatically organize imports on save",
        })
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
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "A",
            function() vim.cmd([[ClangdSwitchSourceHeader]]) end,
            { desc = "Switch between source and header" }
        )
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
