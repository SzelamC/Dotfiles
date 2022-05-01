--[[
lvim is the global options object
Linters should be
filled in as strings with either
a global executable or a path to an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onedark"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<leader>P"] = ":w<cr>:Glow<cr>"
lvim.keys.insert_mode[";;"] = "<Esc>A;"
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }

-- User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = false
lvim.builtin.notify.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 1

local components = require("lvim.core.lualine.components")
-- lvim.builtin.lualine.options.component_separators = { left = '', right = ''}
lvim.builtin.lualine.options.section_separators = { left = "" }
lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_y = {
	components.location,
}
lvim.builtin.lualine.options.theme = "horizon"

lvim.builtin.treesitter.autotag.enable = true
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.treesitter.rainbow.colors = {
	"#ffa6dd",
	"#ffb2a8",
	"#ffc649",
}

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"tsx",
	"css",
	"rust",
	"java",
	"yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

-- generic LSP settings

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "tailwindcss" })
local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("tailwindcss")
require("lspconfig")["tailwindcss"].setup(opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
vim.tbl_map(function(server)
	return server ~= "tailwindcss"
end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

vim.diagnostic.config({
	virtual_text = {
		prefix = "  ",
	},
})

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	--   { command = "black", filetypes = { "python" } },
	--   { command = "isort", filetypes = { "python" } },
	{
		-- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
		command = "prettier",
		---@usage arguments to pass to the formatter
		-- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
		extra_args = { "--print-with", "100" },
		---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
		filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact", "css" },
	},
	{
		command = "stylua",
		filetypes = { "lua" },
	},
})
-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
	{
		"folke/trouble.nvim",
		cmd = "TroubleToggle",
	},
	{
		"ful1e5/onedark.nvim",
		config = require("onedark").setup({
			comment_style = "none",
			keyword_style = "italic",
			function_style = "none",
			transparent = false,
			dev = true,
			transparent_sidebar = false,
			colors = {},
			overrides = function(c)
				--         local c = {
				--   none = 'NONE',
				--   bg0 = '#282c34',
				--   bg1 = '#21252b',
				--   bg_highlight = '#2c313a',
				--   bg_visual = '#393f4a',
				--   black0 = '#20232A',
				--   blue0 = '#61afef',
				--   blue1 = '#528bff',
				--   cyan0 = '#56b6c2',
				--   fg0 = '#abb2bf',
				--   fg_dark = '#798294',
				--   fg_gutter = '#5c6370',
				--   fg_light = '#adbac7',
				--   green0 = '#98c379',
				--   orange0 = '#e59b4e',
				--   orange1 = '#d19a66',
				--   purple0 = '#c678dd',
				--   red0 = '#e06c75',
				--   red1 = '#e86671',
				--   red2 = '#f65866',
				--   yellow0 = '#ebd09c',
				--   yellow1 = '#e5c07b',
				--   dev_icons = {
				--     blue = '#519aba',
				--     green0 = '#8dc149',
				--     yellow = '#cbcb41',
				--     orange = '#e37933',
				--     red = '#cc3e44',
				--     purple = '#a074c4',
				--     pink = '#f55385',
				--     gray = '#4d5a5e',
				--   },
				-- }
				return {
					Visual = { fg = "#F9FFB3", bg = c.bg_visual },
					Conditional = { fg = c.purple0, style = "italic" },
					Exception = { fg = c.purple0, style = "italic" },
					Repeat = { fg = c.purple0, style = "italic" },
					TSInclude = { fg = c.purple0, style = "italic" },
					-- TSParameter = { fg = c. },
					TSTagAttribute = { fg = c.orange1 },
					LspDiagnosticsVirtualTextHint = { style = "bold" },
					javascriptTSFunction = { fg = c.blue0 },
					javascriptTSVariable = { fg = "#E26674" },
					typescriptTSFunction = { fg = c.blue0 },
					typescriptTSVariable = { fg = "#E26674" },
					-- String = { fg = "#70F49C" },
					-- Normal = { bg = "#ff4a5c", fg = c.dev_icons.green0 }
					-- javascriptTSVariable = { fg = c.yellow0 }
				}
			end,
		}),
	},
	{
		"nvim-treesitter/playground",
		event = "BufRead",
	},
	{
		"windwp/nvim-ts-autotag",
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "*" }, {
				RGB = true, -- #RGB hex codes
				RRGGBB = true, -- #RRGGBB hex codes
				RRGGBBAA = true, -- #RRGGBBAA hex codes
				rgb_fn = true, -- CSS rgb() and rgba() functions
				hsl_fn = true, -- CSS hsl() and hsla() functions
				css = true, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
				css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
			})
		end,
	},
	{
		"ggandor/lightspeed.nvim",
		event = "BufRead",
	},
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup({
				colors = {
					hint = { "#98c379", "DiagnosticsHint" },
				},
			})
		end,
	},
	{
		"tpope/vim-surround",
		keys = { "c", "d", "y" },
	},
	{
		"p00f/nvim-ts-rainbow",
	},
	{
		"npxbr/glow.nvim",
		ft = { "markdown" },
		-- run = "yay -S glow"
	},
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
