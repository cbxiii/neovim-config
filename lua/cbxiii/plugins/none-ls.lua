return {
	"nvimtools/none-ls.nvim",
    dependencies = {
        "nvimtools/none-ls-extras.nvim",
    },
	config = function()
		local null_ls = require("null-ls")

        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        local sources = {
            formatting.stylua,
            formatting.prettier,
            formatting.black,
            formatting.isort,
            diagnostics.pylint.with({
                diagnostic_config = { underline = false, virtual_text = false, signs = false },
                method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
            }),
        }

		null_ls.setup({
			sources = sources
		})

		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
