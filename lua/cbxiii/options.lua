local opt = vim.opt

opt.relativenumber = true
opt.number = true

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true

opt.hlsearch = false
opt.incsearch = true

opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")

opt.splitright = true
opt.splitbelow = true

opt.scrolloff = 8
opt.updatetime = 50
opt.colorcolumn = "100"
