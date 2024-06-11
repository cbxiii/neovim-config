return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()

        vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", {})
        vim.keymap.set("n", "<leader>gi", ":Gitsigns preview_hunk_inline<cr>", {})
        vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<cr>", {})
    end
}
