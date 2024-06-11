vim.g.mapleader = " "

local map = vim.keymap.set
local options = { noremap = true }
map("i", "jk", "<Esc>", options) 
map("n", "<leader>w", ":update<cr>", options) -- save file :3
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

map("x", "<leader>p", "\"_dP")


