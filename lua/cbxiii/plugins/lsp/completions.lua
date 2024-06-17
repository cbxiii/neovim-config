return {
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    {
        'L3MON4D3/LuaSnip',
        dependencies = {
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets'
        },
    },
    {
        "hrsh7th/nvim-cmp",
        config = function()

            -- setting up autocompletions
            require("luasnip.loaders.from_vscode").lazy_load()
            local cmp = require("cmp")

            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = "buffer" },
                }),
            })

            -- setting up snippets
            local ls = require('luasnip')
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node

            ls.setup({})

            ls.add_snippets("lua", {
                s("hello", {
                    t('print("hello world!")')
                })
            })

            ls.add_snippets("htmldjango", {
                s("fblock", {
                    t('{% block '),
                    i(1, "content"),
                    t(' %}{% endblock %}')
                }),
                s("fextends", {
                    t('{% extends '),
                    i(1),
                    t(' %}')
                }),
                s("fmacro", {
                    t('{% macro '), i(1, "expression"), t(' -%}'),
                    t({ '', '\t' }), i(2, "blockofcode"),
                    t({ '', '{%- endmacro %}' })
                }),
                s("fexp", {
                    t('{{ '), i(1, "foo.bar"), t(' }}'),
                }),
                s("fimport", {
                    t('{% import '), i(1, "template"),
                    t(' as '), i(2, "alias"), t(' %}')
                }),
            })
            ls.add_snippets("html", {
                s("fblock", {
                    t('{% block '),
                    i(1, "content"),
                    t(' %}{% endblock %}')
                }),
                s("fextends", {
                    t('{% extends '),
                    i(1, "template"),
                    t(' %}')
                }),
                s("fmacro", {
                    t('{% macro '), i(1, "expression"), t(' -%}'),
                    t({ '', '\t' }), i(2, "blockofcode"),
                    t({ '', '{%- endmacro %}' })
                }),
                s("fexp", {
                    t('{{ '), i(1, "foo.bar"), t(' }}'),
                }),
                s("fimport", {
                    t('{% import '), i(1, "template"),
                    t(' as '), i(2, "alias"), t(' %}')
                }),
            })

            vim.diagnostic.config({
                update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end,
    },
}
