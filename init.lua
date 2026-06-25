local opt = vim.opt

opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- ==================
-- OPTIONS
-- ==================
opt.relativenumber = true
opt.number = true

vim.g.netrw_banner = 0

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.ignorecase = true -- case insensitive search
opt.smartcase = true -- case sensitive if uppercase in string

opt.cursorline = true -- highlight current line

opt.hlsearch = true
opt.incsearch = true

opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus") -- use system clipboard

opt.splitright = true
opt.splitbelow = false

opt.scrolloff = 8
opt.sidescrolloff = 10 -- 10 lines to left/right of cursor
opt.updatetime = 300 -- faster time completion
opt.timeoutlen = 500 -- timeout duration
opt.ttimeoutlen = 0 -- key code timeout
opt.autoread = true -- auto-reload changes if outside of nvim
opt.autowrite = false -- don't autosave 
opt.encoding = "UTF-8"

opt.colorcolumn = "100"

-- ==================
-- KEYMAPS
-- ==================
vim.g.mapleader = " "

local map = vim.keymap.set
local options = { noremap = true }
map("i", "jk", "<Esc>", options)
map("n", "<leader>w", ":update<cr>", options) -- save file :3
map("n", "<leader>q", ":q<cr>", options) -- close vim :3
map("n", "<leader>n", ":nohl<cr>", options) -- clear highlight

map("n", "<leader>pv", vim.cmd.Ex) -- goto file explorer

-- buffer split
map("n", "<leader>v", ":vsplit<cr>", options)
map("n", "<leader>s", ":split<cr>", options)
map("n", "<leader>x", "<cmd>close<cr>", options)

-- paging up & down
map("n", "<C-d>", "<C-d>zz", options)
map("n", "<C-u>", "<C-u>zz", options)

-- center cursor for search
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- group & move tings up and down
map("v", "J", ":m '>+1<cr>gv=gv")
map("v", "K", ":m '<-2<cr>gv=gv")

-- tabs
map("n", "<leader>t", "<cmd>tabnew<CR>") -- open new tab
map("n", "<S-l>", "<cmd>tabn<CR>") --  go to next tab
map("n", "<S-h>", "<cmd>tabp<CR>") --  go to previous tab
map("n", "<C-t>", "<cmd>tabnew %<CR>") --  move current buffer to new tab

map("x", "<leader>p", '"_dP') -- paste without yanking
map({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete without yanking" })

map("v", "<", "<gv", { desc = "indent left and reselect" })
map("v", ">", ">gv", { desc = "indent right and reselect" })

map("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "toggle diagnostics" })

-- git binds
map("n", "<leader>gc", ":Git commit<cr>")

-- ==============
-- AUTOCMDS
-- ===============
--

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.hl.on_yank()
    end
})

-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    desc = "Restore last cursor position",
    callback = function()
        if vim.o.diff then 
            return
        end

        local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
        local last_line = vim.api.nvim_buf_line_count(0)

        local row = last_pos[1]
        if row < 1 or row > last_line then
            return
        end

        pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
    end,
})

-- wrap, linebreak, spellcheck on .md and .txt files
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "markdown", "text", "gitcommit" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.spell = true
    end,
})

-- ===========================================
-- PLUGINS
-- ===========================================
vim.pack.add({
    "https://www.github.com/nvim-tree/nvim-tree.lua",
})

local function packadd(name)
    vim.cmd("packadd " .. name)
end

packadd("nvim-tree.lua")

-- ============================================
-- PLUGIN CONFIGS
-- ============================================

require("nvim-tree").setup({
    view = {
        width = 35,
    },
    filters = {
        dotfiles = false,
    },
    renderer = {
        group_empty = true,
    },
})
vim.keymap.set("n", "<leader>e", function()
    require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })
