return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/lazydev.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "stevearc/conform.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
            "onsails/lspkind.nvim",
        },
        config = function()
            local lspkind = require('lspkind')
            require("lazydev").setup({})
            require("conform").setup({
                formatters_by_ft = {
                    python = { "black" },
                    c = { "clang-format" },
                    cpp = { "clang-format" },
                    sh = { "shfmt" },
                    bash = { "shfmt" },
                }
            })

            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )

            require("fidget").setup({})
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls", "rust_analyzer", --"gopls",
                    "vtsls", "tailwindcss", "clangd", "basedpyright",
                    "bashls",
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,

                    ["basedpyright"] = function()
                        require("lspconfig").basedpyright.setup({
                            capabilities = capabilities,
                            settings = {
                                basedpyright = {
                                    analysis = {
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = false,
                                        diagnosticMode = "openFilesOnly",
                                        -- "basic" or "off" will stop it from acting like a strict professor
                                        typeCheckingMode = "basic",
                                        -- No wall of text warning (eg. for pandas library)
                                        reportUnknownMemberType = false,
                                        reportUnknownVariableType = false,
                                        reportUnknownArgumentType = false,
                                        -- kill the "Stub file not found" from earlier too
                                        reportMissingTypeStubs = false,
                                    },
                                },
                            },
                        })
                    end,

                    ["clangd"] = function()
                        require("lspconfig").clangd.setup({
                            capabilities = capabilities,
                            cmd = {
                                "clangd",
                                "--background-index",
                                "--clang-tidy",
                                "--header-insertion=iwyu",
                                "--completion-style=detailed",
                                "--function-arg-placeholders",
                                "--fallback-style=llvm",
                            },
                        })
                    end,

                    ["lua_ls"] = function()
                        require("lspconfig").lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    workspace = { checkThirdParty = false },
                                }
                            }
                        }
                    end,
                },
            })

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },

                -- windows for completition and documentation
                window = {
                    completion = cmp.config.window.bordered({border = "single"}),
                    documentation = cmp.config.window.bordered({border = "single"}),
                },

                mapping = cmp.mapping.preset.insert({
                    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),

                -- icon for lsp
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        maxwidth = 50,
                        ellipsis_char = '...',
                        symbol_map = { Copilot = "" },
                        before = function (entry, vim_item)
                            vim_item.menu = ({
                                nvim_lsp = "[LSP]",
                                luasnip = "[Snippet]",
                                buffer = "[Buffer]",
                                path = "[Path]",
                                copilot = "[Copilot]",
                            })[entry.source.name]
                            return vim_item
                        end
                    }),
                },

                sources = cmp.config.sources({
                    { name = "copilot", group_index = 2 },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })

            -- Autopairs integration
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())

            -- Diagnostic UI
            vim.diagnostic.config({
                virtual_text = { severity = vim.diagnostic.severity.ERROR },
                signs = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "single",
                    source = "always",
                    header = "",
                    prefix = "",
                    severity_sort = true,
                    format = function(diagnostic)
                        if diagnostic.code then
                            return string.format("%s [%s]", diagnostic.message, diagnostic.code)
                        end
                        return diagnostic.message
                    end,
                },
            })


            -- The "Pro" modern way to set global borders for LSP floats
            local _border = "single"

            local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
            function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
                opts = opts or {}
                opts.border = opts.border or _border
                return orig_util_open_floating_preview(contents, syntax, opts, ...)
            end



            vim.api.nvim_create_autocmd("FileType", {
                pattern = "make",
                callback = function()
                    vim.opt_local.expandtab = false
                    vim.opt_local.shiftwidth = 8
                    vim.opt_local.softtabstop = 8
                end
            })
        end
    }
}
