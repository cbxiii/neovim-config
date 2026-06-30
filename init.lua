local opt = vim.opt

opt.termguicolors = true
-- vim.cmd.colorscheme("habamax")

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

opt.selection = "inclusive" -- include last char in selection

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
map("n", "<C-n>", ":nohl<cr>", options) -- clear highlight

map("n", "<leader>pv", vim.cmd.Ex) -- goto file explorer

-- buffer split
map("n", "<leader>v", ":vsplit<cr>", options)
map("n", "<leader>s", ":split<cr>", options)
map("n", "<leader>x", "<cmd>close<cr>", options)

-- tmux navigation 
map("n", "<C-h>", "<cmd>TmuxNavigateLeft<CR>", { desc = "Move to left window/pane" })
map("n", "<C-j>", "<cmd>TmuxNavigateDown<CR>", { desc = "Move to bottom window/pane" })
map("n", "<C-k>", "<cmd>TmuxNavigateUp<CR>", { desc = "Move to top window/pane" })
map("n", "<C-l>", "<cmd>TmuxNavigateRight<CR>", { desc = "Move to right window/pane" })

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

map("v", "<", "<gv", { desc = "indent left and reselect" })
map("v", ">", ">gv", { desc = "indent right and reselect" })

map("n", "<leader>td", function()
    vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "toggle diagnostics" })

-- git binds
map("n", "<leader>gc", ":Git commit<cr>")

-- format file
map("n", "<leader>of", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

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

-- Set 2-space indentation for HTML, JS, and TS files
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
    end,
})

-- ===========================================
-- PLUGINS
-- ===========================================
vim.pack.add({
    "https://github.com/goolord/alpha-nvim",
    "https://www.github.com/ibhagwan/fzf-lua",
    "https://www.github.com/lewis6991/gitsigns.nvim",
    "https://www.github.com/nvim-tree/nvim-tree.lua",
    {
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
	},
    -- language server protocols
    "https://www.github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/creativenull/efmls-configs-nvim",
	{
		src = "https://github.com/saghen/blink.cmp",
		version = vim.version.range("1.*"),
	},
	"https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/mrcjkb/rustaceanvim",
    "https://www.github.com/echasnovski/mini.nvim",
    "https://www.github.com/ellisonleao/gruvbox.nvim",
    "https://github.com/christoomey/vim-tmux-navigator",
    "https://github.com/nvim-tree/nvim-web-devicons",
    -- claude code 
    "https://github.com/folke/snacks.nvim",
    "https://github.com/coder/claudecode.nvim",
})

-- ============================================
-- PLUGIN CONFIGS
-- ============================================

-- color theme setup
local colors = require("gruvbox").palette
require("gruvbox").setup({
    overrides = {
	    AlphaShortcut = { fg = colors.bright_red },
	    AlphaButtons = { fg = colors.bright_red },
	    AlphaHeader = { fg = colors.bright_yellow },
    },
})
vim.cmd.colorscheme("gruvbox")

require("mini.icons").setup({})

-- alpha setup 
vim.cmd("packadd nvim-web-devicons")

local dashboard = require("alpha.themes.dashboard")

dashboard.section.header.val = {
    [[                                    _             ]],
    [[  _ _      ___     ___    __ __    (_)    _ __   ]],
    [[ | ' \    / -_)   / _ \   \ V /    | |   | '  \  ]],
    [[ |_||_|   \___|   \___/   _\_/_   _|_|_  |_|_|_| ]],
    [[_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|]],
    [["`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-']],
}

-- Define your dashboard menu buttons
dashboard.section.buttons.val = {
    dashboard.button("f", " " .. " Find file",       "<cmd> FzfLua files <cr>"),
    dashboard.button("n", " " .. " New file",        "<cmd> ene <BAR> startinsert <cr>"),
    dashboard.button("p", " "  .. " File Tree",      "<cmd> Ex<cr>"),
    dashboard.button("g", " " .. " Find text",       "<cmd> FzfLua live_grep <cr>"),
    dashboard.button("q", " " .. " Quit",            "<cmd> qa <cr>"),
}

for _, button in ipairs(dashboard.section.buttons.val) do
    button.opts.hl = "AlphaButtons"
    button.opts.hl_shortcut = "AlphaShortcut"
end
dashboard.section.header.opts.hl = "AlphaHeader"
dashboard.section.footer.opts.hl = "AlphaFooter"
dashboard.opts.layout[1].val = 8

require("alpha").setup(dashboard.opts)

local setup_treesitter = function()
    local treesitter = require("nvim-treesitter")
    treesitter.setup({
        auto_install = true,
        ensure_installed = {
            "vim", "vimdoc", "rust", "c", "cpp", "go", "html", 
            "css", "javascript", "json", "lua", "markdown", 
            "python", "typescript", "vue", "svelte", "bash", "text"
        },
        highlight = {
            enable = true,
        },
    })
end

setup_treesitter()

-- nvim-tree setup
require("nvim-tree").setup({
    view = {
        width = 35,
    },
    filters = {
        dotfiles = true,
    },
    renderer = {
        group_empty = true,
        icons = {
            glyphs = {
                folder = {
                    arrow_closed = "⏵",
                    arrow_open = "⏷",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "⌥",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "⊖",
                    ignored = "◌",
                },
            },
        },
    },
})
vim.keymap.set("n", "<leader>e", function()
    require("nvim-tree.api").tree.toggle()
end, { desc = "Toggle NvimTree" })

require("fzf-lua").setup({})
vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function()
	require("fzf-lua").help_tags()
end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function()
	require("fzf-lua").diagnostics_workspace()
end, { desc = "FZF Diagnostics Workspace" })

require("gitsigns").setup({})
vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<cr>", { desc = "preview hunk" })
vim.keymap.set("n", "<leader>gi", ":Gitsigns preview_hunk_inline<cr>", { desc = "preview hunk inline" })
vim.keymap.set("n", "<leader>gt", ":Gitsigns toggle_current_line_blame<cr>", { desc = "toggle current line blame" })

require("mason").setup({})

-- ============================================================================
-- LSP, Linting, Formatting & Completion
-- ============================================================================
local diagnostic_signs = {
	Error = "\u{f057} ",
	Warn = "\u{f071} ",
	Hint = "\u{ea61}",
	Info = "\u{f05a}",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true,
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gd", function()
		require("fzf-lua").lsp_definitions({ jump1 = true })
	end, opts)

	vim.keymap.set("n", "gD", vim.lsp.buf.definition, opts)

	vim.keymap.set("n", "gS", function()
		vim.cmd("vsplit")
		vim.lsp.buf.definition()
	end, opts)

	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

	vim.keymap.set("n", "<leader>D", function()
		vim.diagnostic.open_float({ scope = "line" })
	end, opts)
	vim.keymap.set("n", "<leader>d", function()
		vim.diagnostic.open_float({ scope = "cursor" })
	end, opts)
	vim.keymap.set("n", "<leader>nd", function()
		vim.diagnostic.jump({ count = 1 })
	end, opts)
	vim.keymap.set("n", "<leader>pd", function()
		vim.diagnostic.jump({ count = -1 })
	end, opts)

	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

	vim.keymap.set("n", "<leader>fr", function()
		require("fzf-lua").lsp_references()
	end, opts)
	vim.keymap.set("n", "<leader>ft", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>fs", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fw", function()
		require("fzf-lua").lsp_workspace_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>fi", function()
		require("fzf-lua").lsp_implementations()
	end, opts)

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { group = augroup, callback = lsp_on_attach })

vim.keymap.set("n", "<leader>q", function()
	vim.diagnostic.setloclist({ open = true })
end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

require("blink.cmp").setup({
	keymap = {
		preset = "none",
		["<C-Space>"] = { "show", "hide" },
		["<CR>"] = { "accept", "fallback" },
		["<C-j>"] = { "select_next", "fallback" },
		["<C-k>"] = { "select_prev", "fallback" },
		["<Tab>"] = { "snippet_forward", "fallback" },
		["<S-Tab>"] = { "snippet_backward", "fallback" },
	},
	appearance = { nerd_font_variant = "mono" },
	completion = {
		menu = {
			auto_show = function()
				return vim.bo.filetype ~= "markdown"
			end,
		},
	},
	sources = { default = { "lsp", "path", "buffer", "snippets" } },
	snippets = {
		expand = function(snippet)
			require("luasnip").lsp_expand(snippet)
		end,
	},
	fuzzy = {
		implementation = "prefer_rust",
		prebuilt_binaries = { download = true },
	},
})

vim.lsp.config["*"] = {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			telemetry = { enable = false },
		},
	},
})
vim.lsp.config("pyright", {})
vim.lsp.config("bashls", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("gopls", {})
vim.lsp.config("clangd", {})

vim.g.rustaceanvim = {
	server = {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
	},
}

do
	local luacheck = require("efmls-configs.linters.luacheck")
	local stylua = require("efmls-configs.formatters.stylua")

	local flake8 = require("efmls-configs.linters.flake8")
	local black = require("efmls-configs.formatters.black")

	local prettier_d = require("efmls-configs.formatters.prettier_d")
	local eslint_d = require("efmls-configs.linters.eslint_d")

	local fixjson = require("efmls-configs.formatters.fixjson")

	local shellcheck = require("efmls-configs.linters.shellcheck")
	local shfmt = require("efmls-configs.formatters.shfmt")

	local cpplint = require("efmls-configs.linters.cpplint")
	local clangfmt = require("efmls-configs.formatters.clang_format")

	local go_revive = require("efmls-configs.linters.go_revive")
	local gofumpt = require("efmls-configs.formatters.gofumpt")

	vim.lsp.config("efm", {
		filetypes = {
			"c",
			"cpp",
			"css",
			"go",
			"html",
			"javascript",
			"javascriptreact",
			"json",
			"jsonc",
			"lua",
			"markdown",
			"python",
			"sh",
			"typescript",
			"typescriptreact",
			"vue",
			"svelte",
		},
		init_options = { documentFormatting = true },
		settings = {
			languages = {
				c = { clangfmt, cpplint },
				go = { gofumpt, go_revive },
				cpp = { clangfmt, cpplint },
				css = { prettier_d },
				html = { prettier_d },
				javascript = { eslint_d, prettier_d },
				javascriptreact = { eslint_d, prettier_d },
				json = { eslint_d, fixjson },
				jsonc = { eslint_d, fixjson },
				lua = { luacheck, stylua },
				markdown = { prettier_d },
				python = { flake8, black },
				sh = { shellcheck, shfmt },
				typescript = { eslint_d, prettier_d },
				typescriptreact = { eslint_d, prettier_d },
				vue = { eslint_d, prettier_d },
				svelte = { eslint_d, prettier_d },
			},
		},
	})
end

vim.lsp.enable({
	"lua_ls",
	"pyright",
	"bashls",
	"ts_ls",
	"gopls",
	"clangd",
	"efm",
})

-- =========================== STATUS LINE ===========================
opt.showmode = false -- hide default -- INSERT -- text at the bottom
opt.laststatus = 3 -- global statusline

local modes = {
  ['n']   = '',
  ['no']  = '-- N-PENDING --',
  ['v']   = '-- VISUAL --',
  ['V']   = '-- V-LINE --',
  ['\22'] = '-- V-BLOCK --',
  ['s']   = '-- SELECT --',
  ['S']   = '-- S-LINE --',
  ['\19'] = '-- S-BLOCK --',
  ['i']   = '-- INSERT --',
  ['R']   = '-- REPLACE --',
  ['c']   = '-- COMMAND --',
  ['r']   = '-- PROMPT --',
  ['!']   = '-- SHELL --',
  ['t']   = '-- TERMINAL --',
}

local function get_mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode] or current_mode)
end

-- get git branch from gitsigns
local function get_git_branch()
    -- check if gitsigns data is available for current buffer
    local b = vim.b.gitsigns_status_dict
    if not b or not b.head or b.head == "" then
        return ""
    end
    return string.format("  %s ", b.head)
end

-- get relative file path and modification status
local function get_filepath()
    return " %f%m "
end

-- lsp diagnostics count
local function get_diagnostics()
    if #vim.lsp.get_clients({ bufnr = 0 }) == 0 then
        return ""
    end

    local count = vim.diagnostic.count(0)
    local errors = count[vim.diagnostic.severity.ERROR] or 0
    local warnings = count[vim.diagnostic.severity.WARN] or 0
    local hints = count[vim.diagnostic.severity.HINT] or 0 

    local result = ""
    if errors > 0 then
        result = result .. string.format(" %s:%d", diagnostic_signs.Error, errors)
    end
    if warnings > 0 then
        result = result .. string.format(" %s:%d", diagnostic_signs.Warn, warnings)
    end
    if hints > 0 then
        result = result .. string.format(" %s:%d", diagnostic_signs.Hint, hints)
    end

    return result ~= "" and result .. " " or ""
end

-- 5. Get file percentage and cursor line/col location
local function get_location()
  -- %l = line, %c = column, %p%% = file percentage
  return " %l,%c   %p%% "
end

-- final statusline
function MyStatusLine()
    local parts = {
        get_git_branch(),
        get_filepath(),
        get_mode(),
        "%=",
        get_diagnostics(),
        get_location()
    }
    return table.concat(parts)
end

opt.statusline = "%{%v:lua.MyStatusLine()%}"

-- ==============================================
-- CLAUDE CODE SETUP 
-- ==============================================
require("snacks").setup({})
require("claudecode").setup({})

vim.keymap.set("n", "<leader>a", "<Nop>", { desc = "AI/Claude Code" })
vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
-- focus claude in both normal & terminal mode
vim.keymap.set({ "n", "t" }, "<C-q>", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus Claude" })

-- Get back to normal mode from inside the Claude terminal, then move
-- with standard window commands. <C-\><C-n> is the universal terminal-mode escape.
vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l")
vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j")
vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k")

vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue Claude" })
vim.keymap.set("n", "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", { desc = "Select Claude model" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", { desc = "Accept diff" })
vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", { desc = "Deny diff" })

