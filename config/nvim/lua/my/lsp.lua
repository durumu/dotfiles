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

-- Determine python path: use .venv at git root if it exists, otherwise use python3_host_prog
local venv_root = vim.fs.dirname(vim.fs.dirname(vim.g.python3_host_prog))
local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
local git_venv_path = git_root .. "/.venv"

local python_path = vim.g.python3_host_prog
if vim.fn.isdirectory(git_venv_path) == 1 then
    venv_root = git_venv_path
    python_path = vim.fs.joinpath(git_venv_path, "bin", "python3")
end

vim.lsp.config("ty", {
    cmd = { vim.fs.joinpath(venv_root, "bin", "ty"), "server" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
    on_attach = on_attach,
    settings = {
        ty = {
            -- ty settings can go here if needed
        },
    },
})

vim.lsp.config("ruff", {
    cmd = { vim.fs.joinpath(venv_root, "bin", "ruff"), "server", "--preview" },
    root_markers = { "pyproject.toml", "setup.py", "requirements.txt", ".git" },
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

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml" },
    on_attach = on_attach,
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            trace = { server = "verbose" },
        },
    },
})

vim.lsp.config("clangd", {
    cmd = { "clangd" },
    root_markers = { "compile_commands.json", ".git" },
    on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        vim.api.nvim_buf_create_user_command(
            bufnr,
            "A",
            function() vim.cmd([[ClangdSwitchSourceHeader]]) end,
            { desc = "Switch between source and header" }
        )
    end,
})

vim.lsp.config("gopls", {
    cmd = { "gopls" },
    root_markers = { "go.mod", ".git" },
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
-- It also sort of works for playdate
vim.lsp.config("lua_ls", {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".git" },
    on_attach = on_attach,
    settings = {
        Lua = {
            format = { enable = false }, -- I use stylua
            runtime = {
                version = "LuaJIT", -- Neovim uses LuaJIT
                nonstandardSymbol = { "+=", "-=", "*=", "/=" },
            },
            workspace = {
                library = {
                    "/Users/presley/Developer/PlaydateSDK/CoreLibs", -- playdate
                    vim.api.nvim_get_runtime_file("", true), -- Neovim runtime files
                },
                checkThirdParty = false,
            },
            diagnostics = {
                globals = {
                    "playdate", -- PlaydateSDK
                    "import", -- PlaydateSDK
                    "vim", -- Neovim
                },
            },
            telemetry = { enable = false },
        },
    },
})

vim.lsp.config("zls", {
    cmd = { "zls" },
    root_markers = { "zls.json", "build.zig", ".git" },
    on_attach = on_attach,
})

vim.lsp.config("vtsls", {
    cmd = { "vtsls", "--stdio" },
    root_markers = { "package.json", "tsconfig.json", ".git" },
})

-- Enable LSP servers for their respective filetypes
vim.lsp.enable("ty")
vim.lsp.enable("ruff")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("clangd")
vim.lsp.enable("gopls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("zls")
vim.lsp.enable("vtsls")
