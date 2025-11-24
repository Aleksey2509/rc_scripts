-----------------------------------------------------------
--  Neovim configuration (init.lua)
--  Modern setup with lazy.nvim, LSP, Treesitter, and theme
-----------------------------------------------------------

-- Bootstrap lazy.nvim if not installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- Plugin setup
-----------------------------------------------------------
require("lazy").setup({
    -- LSP and autocompletion
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim",          config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },

    -- Syntax highlighting
    { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },

    { "tpope/vim-surround" },
    -- UI
    { "nvim-lualine/lualine.nvim" },
    { "Aleksey2509/vim-code-dark-fork" },
})

-----------------------------------------------------------
-- General options
-----------------------------------------------------------

-- Disable Vi compatibility
vim.opt.compatible = false

-- Enable filetype detection, plugin, and indent files
vim.cmd("filetype plugin indent on")

-- Syntax highlighting
vim.cmd("syntax on")

-- termdebug (if available)
vim.cmd("packadd termdebug")

-----------------------------------------------------------
-- Encoding
-----------------------------------------------------------
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
-- vim.opt.termencoding = "utf-8"

-----------------------------------------------------------
-- Indentation and formatting
-----------------------------------------------------------
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.foldmethod = "syntax"

-- Tabs and spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-----------------------------------------------------------
-- General editing behavior
-----------------------------------------------------------
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true
vim.opt.signcolumn = "number"
vim.opt.wildmenu = true
vim.opt.scrolloff = 5
vim.opt.showmatch = true

-- Comments style
vim.opt.comments = { "sl:/*", "mb:*", "elx:*/" }

-- Colors and UI
vim.opt.termguicolors = true -- replaces 'set t_Co=256'
vim.opt.guicursor = ""
vim.opt.cursorline = false

-----------------------------------------------------------
-- Key mappings
-----------------------------------------------------------
-- Map jj to <Esc> in insert mode
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

-----------------------------------------------------------
-- Highlight trailing whitespace (like match + highlight)
-----------------------------------------------------------
vim.cmd([[
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
]])

-----------------------------------------------------------
-- Optional: Reapply whitespace match automatically
-----------------------------------------------------------
vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave" }, {
    pattern = "*",
    command = "match ExtraWhitespace /\\s\\+$/"
})

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    command = "match none"
})


-----------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------
vim.cmd([[colorscheme codedark]])

-----------------------------------------------------------
-- LSP setup
-----------------------------------------------------------

---------------------------------------------------------------
-- LSP keybindings (YouCompleteMe style)
-----------------------------------------------------------

-- Setup keybindings on LSP attach
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        -- Keybindings
        local opts = { buffer = bufnr }

        -- Navigation
        vim.keymap.set('n', '\\d', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '\\D', function()
            vim.cmd("tab split")
            vim.lsp.buf.definition()
        end, opts
        )
        vim.keymap.set('n', '\\h', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '\\r', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '\\t', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '\\g', vim.lsp.buf.document_symbol, opts)
        vim.keymap.set('n', '\\G', function()
            vim.ui.input({ prompt = "Symbol: " }, function(query)
                if query then vim.lsp.buf.workspace_symbol(query) end
            end)
        end, opts)

        -- Code actions
        vim.keymap.set('n', '\\f', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '\\R', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '\\S', function()
            local enabled = vim.lsp.inlay_hint.is_enabled()
            vim.lsp.inlay_hint.enable(not enabled)
        end, { noremap = true, silent = true, desc = "Toggle inlay hints" })

        -- Formatting
        vim.keymap.set('n', '\\c', function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        function GetSemanticTokenUnderCursor()
            local semantic_tokens = vim.lsp.semantic_tokens.get_at_pos()
            if semantic_tokens then
                -- 'semantic_tokens' will be a table containing information about the token(s)
                -- under the cursor, such as type, modifiers, etc.
                -- You can then process this table to extract the desired information.
                print(vim.inspect(semantic_tokens)) -- Print the token information for inspection
            else
                print("No semantic token found under the cursor.")
            end
        end

        -- You can map this function to a keybinding for easy access
        vim.keymap.set('n', '\\st', GetSemanticTokenUnderCursor, { desc = "Get Semantic Token under cursor" })

        -- Diagnostics
        vim.keymap.set('n', '\\H', vim.diagnostic.open_float, opts)
    end,
})

---------------------------------------------------------------
-- LSP setup
-----------------------------------------------------------


require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "clangd", "hls", "rust_analyzer" },
    handlers = {
        function(server_name)
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local opts = { capabilities = capabilities }

            -- Custom settings for Lua
            if server_name == "lua_ls" then
                opts.settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } },
                        workspace = { checkThirdParty = false },
                    },
                }
            end

            if server_name == "hls" then
                opts.unknown_shit = 123
                opts.settings = {
                    haskell = {
                        semanticTokens = {
                            plugin = {
                                config = {
                                    classMethodToken = "method",
                                    classToken = "class",
                                    dataConstructorToken = "enumMember",
                                    functionToken = "function",
                                    moduleToken = "namespace",
                                    operatorToken = "operator",
                                    patternSynonymToken = "macro",
                                    recordFieldToken = "property",
                                    typeConstructorToken = "enum",
                                    typeFamilyToken = "interface",
                                    typeSynonymToken = "type",
                                    typeVariableToken = "typeParameter",
                                    variableToken = "variable",
                                },
                                globalOn = true,
                            },
                        },
                    },
                }
            end

            -- New Neovim 0.11+ API
            -- vim.lsp.start(vim.lsp.config[server_name].make_config(vim.tbl_extend("keep", opts, { on_attach = on_attach_non_existent_wtd })))
            -- vim.lsp.start(vim.lsp.config[server_name].make_config(opts))
            vim.lsp.start({
                name = server_name,
                cmd = require("mason-lspconfig").get_server_cmd(server_name),
                capabilities = opts.capabilities,
                settings = opts.settings,
            })
        end
    },
})

---------------------------------------------------------------
-- LSP colors
-----------------------------------------------------------
----- Define custom highlight groups (your colors)
vim.api.nvim_set_hl(0, "darkModernGreen", { ctermfg = 43, fg = "#00AF5F" })
vim.api.nvim_set_hl(0, "yellowOrange", { ctermfg = 179, fg = "#D7AF5F" })

-- Link LSP semantic token types to highlight groups
vim.api.nvim_set_hl(0, "@keyword", { link = "Macro" })
vim.api.nvim_set_hl(0, "@keyword.modifier.cpp", { link = "Type" })
vim.api.nvim_set_hl(0, "@keyword.type", { link = "Type" })
vim.api.nvim_set_hl(0, "@keyword.operator.cpp", { link = "Macro" })
vim.api.nvim_set_hl(0, "@lsp.type.concept", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.class", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.namespace", { link = "@type" })
vim.api.nvim_set_hl(0, "@lsp.type.function", { link = "Function" })
vim.api.nvim_set_hl(0, "@lsp.type.label", { link = "Macro" })
vim.api.nvim_set_hl(0, "@lsp.type.operator", { link = "Function" })

-----------------------------------------------------------
-- nvim-cmp setup
-----------------------------------------------------------
local cmp = require("cmp")
cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    }),
    sources = {
        { name = "nvim_lsp" },
    },
})

-----------------------------------------------------------
-- Treesitter setup
-----------------------------------------------------------
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "python", "cpp", "bash", "json" },
    highlight = { enable = true },
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    inderline = true,
    update_in_insert = false,
    severity_sort = true,
})

local ns = vim.api.nvim_create_namespace("CurrentLineDiagnostics")

local function show_line_diagnostics()
    vim.diagnostic.hide(ns)

    local bufnr = vim.api.nvim_get_current_buf()
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
    if #diagnostics == 0 then
        return
    end

    vim.diagnostic.show(ns, bufnr, diagnostics, {
        virtual_text = {
            prefix = "⚠",
            spacing = 4,
        },
    })
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorMoved" }, {
    callback = show_line_diagnostics,
})

-----------------------------------------------------------
-- Lualine setup
-----------------------------------------------------------
require("lualine").setup({
    options = { theme = "codedark", section_separators = "", component_separators = "" },
})
