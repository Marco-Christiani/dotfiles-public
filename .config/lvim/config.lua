-- lvim is the global options object

vim.g.colorcolumn = 120
vim.o.cmdheight = 1
vim.o.grepprg = "rg --vimgrep"
vim.o.grepformat = "grepformat=%f:%l:%c:%m"
vim.opt.shell = "/bin/sh" -- from lunarvim docs, might help with lag?
vim.opt.foldmethod = "expr" -- treesitter based folding (or set to manual)

-- Use system clipboard
vim.cmd [[
set clipboard=unnamedplus
]]

-- Remember my marks (buggy and creates :memory files eveywhere?!)
-- vim.cmd [[
-- set viminfo='1000,f1
-- set shada='1000,f1
-- ]]

-- Remember my folds please. Requires a . in the filename (fixes unnamed buffers)
-- vim.cmd[[
-- augroup remember_folds
--   autocmd!
--   autocmd BufWinLeave *.* mkview
--   autocmd BufWinEnter *.* silent! loadview
-- augroup END
-- ]]

vim.cmd [[
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent! loadview
]]

-- Let me do this myself if you're going to suck.
vim.cmd [[
set foldmethod=manual
]]

local opts = { noremap = true, silent = true }
-- Swap j/gj and k/gk
vim.keymap.set({ 'n', 'v' }, "j", "gj", opts)
vim.keymap.set({ 'n', 'v' }, "gj", "j", opts)
vim.keymap.set({ 'n', 'v' }, "k", "gk", opts)
vim.keymap.set({ 'n', 'v' }, "gk", "k", opts)
-- Center cursor on page down/up
vim.keymap.set({ 'n', 'v' }, "<C-d>", "<C-d>zz", opts)
vim.keymap.set({ 'n', 'v' }, "<C-u>", "<C-u>zz", opts)
-- Delete without overwriting clipboard
vim.keymap.set({ 'n', 'v' }, "<leader>D", "\"_D", opts)
vim.keymap.set({ 'n', 'v' }, "<leader>d", "\"_d", opts)
vim.keymap.set({ 'n', 'v' }, "<leader>x", "\"_x", opts)
vim.keymap.set({ 'n', 'v' }, "<leader>X", "\"_X", opts)
-- Something was overwriting these bindings (for window sizing?), reset them
-- vim.keymap.set({ 'n' }, "<Up>", "<Up>", opts)
-- vim.keymap.set({ 'n' }, "<Down>", "<Down>", opts)
-- vim.keymap.set({ 'n' }, "<Left>", "<Left>", opts)
-- vim.keymap.set({ 'n' }, "<Right>", "<Right>", opts)
-- lvim.builtin.which_key.triggers_blacklist
-- lvim.builtins.which_key_ignore
vim.keymap.set({ 'n', 'v' }, "H", "<cmd>BufferLineCyclePrev<cr>", opts)
vim.keymap.set({ 'n', 'v' }, "L", "<cmd>BufferLineCycleNext<cr>", opts)
-- vim.keymap.set({ 'n' }, "gd", "<C-w>v gd", opts)

-- Neovide stuff----------------------------------------------------------------
vim.opt.guifont = "Fira Code"
vim.g.neovide_transparency = 0.8
vim.g.neovide_scale_factor = 0.6
-- Start: This does nothing to neovide
vim.g.gui_font_default_size = 15
vim.g.gui_font_size = vim.g.gui_font_default_size
-- End
vim.g.gui_font_face = "Fira Code"
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_scroll_animation_length = 0.22

RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s", vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function()
  vim.g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

-- Call function on startup to set default value
ResetGuiFont()
opts = { noremap = true, silent = true }
vim.keymap.set({ 'n', 'i' }, "<C-+>", function() ResizeGuiFont(1) end, opts)
vim.keymap.set({ 'n', 'i' }, "<C-->", function() ResizeGuiFont(-1) end, opts)
vim.keymap.set({ 'n', 'i' }, "<C-BS>", function() ResetGuiFont() end, opts)
-------------------------------------------------------------------------------

-- Lvim Core Settings
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.builtin.terminal.insert_mappings = false -- whether or not the open mapping applies in insert mode
-- to disable icons and use a minimalist setup, uncomment the following
lvim.use_icons = true
lvim.builtin.cmp.completion.keyword_length = 2
-- lvim.builtin.cmp.experimental.native_menu = true
-- require("cmp").view = { entries = 'native' }
lvim.builtin.cmp['view'] = { entries = 'native' }

lvim.builtin.alpha.active = false -- disable the welcome screen
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true -- this is getting annoying tho tbh

lvim.transparent_window = false
vim.opt.termguicolors = true

-- Terminal
lvim.builtin.terminal.active = true
lvim.builtin.terminal.size = 10
-- lvim.builtin.terminal.insert_mappings = false -- whether or not the open mapping applies in insert mode

-- Nvimtree
lvim.builtin.nvimtree.active = true -- disable in favor of ranger
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true

-- Comment.nvim Core Plugin
-- lvim.builtin.comment.

-- Treesitter
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  -- "c",
  -- "javascript",
  "json",
  "lua",
  "python",
  -- "typescript",
  -- "tsx",
  -- "css",
  -- "rust",
  -- "java",
  "yaml",
  "toml",
  "markdown"
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.ignore_install = { "c" }
lvim.builtin.treesitter.highlight.enabled = true


-- Lualine
local components = require("lvim.core.lualine.components")

-- lvim.builtin.lualine.sections.lualine_a = { "mode" }
lvim.builtin.lualine.sections.lualine_y = {
  components.spaces,
  components.location
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = { "*.json", "*.jsonc" },
  -- enable wrap mode for json files only
  command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zsh",
  callback = function()
    -- let treesitter use bash highlight for zsh files as well
    require("nvim-treesitter.highlight").attach(0, "bash")
  end,
})

vim.cmd [[command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]]
-- vim.api.nvim_create_user_command("LuaSnipEdit", "lua require('luasnip.loaders').edit_snippet_files()")
-- Core Custom Keymaps
lvim.leader = "space"

-- e maps to insert after word
-- vim.cmd("nnoremap <silent> e ea")

lvim.keys.normal_mode["<A-s>"] = ":w<cr>"
lvim.keys.normal_mode["<A-Enter>"] = "o<Esc>" -- my thing
vim.cmd [[
  " gray
  highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
  " blue
  highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
  highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
  " light blue
  highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
  highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
  " pink
  highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
  highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
  " front
  highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
  highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4
  ]]

lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

-- Trouble keymaps
lvim.builtin.which_key.mappings["i"] = {
  name = "+Trouble",
  t = { "<cmd>TroubleToggle<cr>", "Toggle" },
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
}

-- LSP settings

-- enable/disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = true

-- Manual LSP Config
-- see defaults: `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "c" })
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "sumneko_lua" })
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pylsp" })

-- local pylsp_opts = {
--   plugins = {
--     yapf = {
--       enabled = false
--     },
--     rope_completion = {
--       enabled = true,
--     },
--   }
-- } -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pylsp", pylsp_opts)

opts = {
  init_options = {
    -- token = "user_Ro0e1rU2jjNUeNvkCbKXlEpfKyeF3Z4g1vJ1CvgYWs6UEYiq_Lu3wM9QiOY"
    token = "user_SL2N_vDIw9jjdqOct41ic41Xv_Gr0g1FF8amOxbTAYXJyWGMkS4kNw7h4xo"
  }
}
require("lvim.lsp.manager").setup("sourcery", opts)

-- you can set a custom on_attach function that will be used for all the language servers
-- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- Markdown LSP
-- require'lspconfig'.marksman.setup{}
require("lvim.lsp.manager").setup("marksman", {})

-- Null-ls Formatters: Will override LSP formatting capabilities (if it exists)
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "autopep8", filetypes = { "python" } },
  { command = "reorder-python-imports", filetypes = { "python" } },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "mypy", filetypes = { "python" } },
  {
    command = "flake8",
    filetypes = { "python" },
    extra_args = { "--max-line-length=120" },
  },
  {
    -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
    command = "shellcheck",
    ---@usage arguments to pass to the formatter
    -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
    extra_args = { "--severity", "warning" },
  },
  {
    command = "codespell",
    extra_args = { "--ignore-words", "~/.config/codespell-ignore.txt" },
    ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
    filetypes = { "javascript", "python" },
  },
}


-- Custom Plugins
lvim.plugins = {
  {
    "nvim-treesitter/nvim-treesitter-context"
  },
  -- {
  --   "nvim-treesitter/playground",
  -- },
  {
    "nvim-telescope/telescope-project.nvim",
    event = "BufWinEnter",
    setup = function()
      vim.cmd [[packadd telescope.nvim]]
    end,
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
  },
  -- {
  --   "luisiacc/gruvbox-baby", -- colorscheme
  -- },
  -- {
  --   "sainnhe/gruvbox-material" -- colorscheme
  -- },
  -- {
  --   "savq/melange" -- colorscheme
  -- },
  -- {
  --   "EdenEast/nightfox.nvim" -- colorscheme
  -- },
  -- {
  --   "ful1e5/onedark.nvim" -- colorscheme
  -- },
  -- {
  --   "rafamadriz/neon" -- colorscheme
  -- },
  -- {
  --   "tanvirtin/monokai.nvim" -- colorscheme
  -- },
  -- {
  --   "glepnir/zephyr-nvim" -- colorscheme
  -- },
  -- {
  --   "NTBBloodbath/doom-one.nvim" -- colorscheme
  -- },
  {
    "catppuccin/nvim",
    as = "catppuccin"
  }, --colorscheme
  {
    "mg979/vim-visual-multi" -- multi-cursor
  },
  {
    "tpope/vim-surround" -- surround with symbols
  },
  {
    "folke/trouble.nvim",
    -- cmd = "TroubleToggle",
    requires = {
      "kyazdani42/nvim-web-devicons",
    }
  },
  {
    'dccsillag/magma-nvim',
    run = ':UpdateRemotePlugins'
  },
  {
    "kevinhwang91/nvim-bqf",
    event = { "BufRead", "Bufnew" },
    config = function()
      require("bqf").setup({
        auto_enable = true,
        preview = {
          win_height = 12,
          win_vheight = 12,
          delay_syntax = 80,
          border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
        },
        func_map = {
          vsplit = "",
          ptogglemode = "z,",
          stoggleup = "",
        },
        filter = {
          fzf = {
            action_for = { ["ctrl-s"] = "split" },
            extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
          },
        },
      })
    end,
    requires = {
      {
        'junegunn/fzf',
        run = function()
          vim.fn['fzf#install']()
        end
      }
    }
  },
  {
    'tpope/vim-repeat'
  },
  {
    "preservim/tagbar"
  },
  {
    'Shatur/neovim-session-manager', -- use to reload last session associated with a directory
  },
  {
    'ggandor/lightspeed.nvim', -- jump navigation
    -- event = "BufRead",
  },
  {
    "voldikss/vim-floaterm" -- floating terminal (think this is installed by default?)
  },
  {
    "gfeiyou/command-center.nvim", -- use to bookmark commands that dont need key bindings
    requires = { "nvim-telescope/telescope.nvim" }
  },
  {
    "folke/twilight.nvim", -- highlight current code blocks in focus mode
  },
  {
    "folke/zen-mode.nvim" -- focus mode
  },
  {
    "lukas-reineke/cmp-rg" -- ripgrep completion
  },
  {
    "ellisonleao/glow.nvim", -- preview markdown
    branch = 'main'
  },
  -- {
  --   "jbyuki/nabla.nvim" -- preview latex (not working)
  -- },
  {
    "ThePrimeagen/harpoon"
  },
  -- {
  --   "gyim/vim-boxdraw"
  -- },
  {
    "rmagatti/goto-preview",
    -- config = function()
    -- require('goto-preview').setup {
    --       width = 120; -- Width of the floating window
    --       height = 25; -- Height of the floating window
    --       default_mappings = false; -- Bind default mappings
    --       debug = false; -- Print debug information
    --       opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
    --       post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
    --       -- You can use "default_mappings = true" setup option
    --       -- Or explicitly set keybindings
    --       -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
    --       -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
    --       -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
    --       -- Only set if you have telescope installed
    --       -- vim.cmd("noremap gpr <cmd>lua require('goto-preview').goto_preview_references()<CR>")
    --   }
    -- end
  },
  -- {
  --   "ThePrimeagen/refactoring.nvim",
  --   requires = {
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-treesitter/nvim-treesitter" }
  --   },
  -- },
  -- {
  --    'mnowotnik/noteflow.nvim',
  --     run ='bash build.sh'
  -- }
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "css", "scss", "html", "javascript" }, {
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
    "folke/todo-comments.nvim",
  },
  {
    "mtdl9/vim-log-highlighting",
  },
  {
    'chentoast/marks.nvim'
  },
  { -- Show function signature as you type
    "ray-x/lsp_signature.nvim",
    -- event = "BufRead",
    -- config = function() require "lsp_signature".on_attach() end,
  },
  {
    "artempyanykh/marksman"
  },
  { -- Latex
    'lervag/vimtex'
  },
  { -- Scratchpad with telescope and syntac highlighting
    'm-demare/attempt.nvim'
  },
  { -- ranger file explorer https://github.com/kevinhwang91/rnvimr
    "kevinhwang91/rnvimr",
  },
  -- {
  --   'nkakouros-original/numbers.nvim' -- relative number toggle
  -- },
  {
    "aarondiel/spread.nvim", -- splitting and combinding long delimited lines
    -- after = "nvim-treesitter",
  },
  {
    'mrjones2014/smart-splits.nvim' -- tmux + nvim splits
  },
  {
    "metakirby5/codi.vim", -- interactive python repl scrathpad
    cmd = "Codi",
  },
  {
    "wakatime/vim-wakatime",
  },
  -- {
  --   'beauwilliams/focus.nvim', -- Split size control, auto-max focused split
  --   config = function()
  --     require("focus").setup({
  --       -- enable = false, -- toggle w shortcut instead
  --       -- Force minimum width for the unfocused window
  --       -- Default: Calculated based on golden ratio
  --       minwidth = 120,
  --       -- Force width for the focused window
  --       -- Default: Calculated based on golden ratio
  --       width = 120,
  --       -- Displays line numbers in the focussed window only
  --       -- Not displayed in unfocussed windows
  --       -- number = true,
  --       -- Preserve absolute numbers in the unfocussed windows
  --       -- Works in combination with relativenumber or hybridnumber
  --       -- absolutenumber_unfocussed = true,
  --       -- winhighlight = true,
  --       -- Displays a sign column in the focussed window only
  --       -- signcolumn = false
  --     })
  --   end,
  -- },
}

-- lvim.builtin.which_key.mappings["F"] = { "<cmd>FocusToggle<CR>", "Toggle Autoresize" }

require('smart-splits').setup({
  -- Ignored filetypes (only while resizing)
  ignored_filetypes = {
    'nofile',
    'quickfix',
    'prompt',
  },
  -- Ignored buffer types (only while resizing)
  ignored_buftypes = { 'NvimTree' },
  -- when moving cursor between splits left or right,
  -- place the cursor on the same row of the *screen*
  -- regardless of line numbers. False by default.
  -- Can be overridden via function parameter, see Usage.
  move_cursor_same_row = false,
  -- resize mode options
  resize_mode = {
    -- key to exit persistent resize mode
    quit_key = '<ESC>',
    -- keys to use for moving in resize mode
    -- in order of left, down, up' right
    resize_keys = { 'h', 'j', 'k', 'l' },
    -- set to true to silence the notifications
    -- when entering/exiting persistent resize mode
    silent = false,
    -- must be functions, they will be executed when
    -- entering or exiting the resize mode
    hooks = {
      on_enter = nil,
      on_leave = nil
    }
  },
  -- ignore these autocmd events (via :h eventignore) while processing
  -- smart-splits.nvim computations, which involve visiting different
  -- buffers and windows. These events will be ignored during processing,
  -- and un-ignored on completed. This only applies to resize events,
  -- not cursor movement events.
  ignored_events = {
    'BufEnter',
    'WinEnter',
  },
  -- enable or disable the tmux Integration
  tmux_integration = true,
})
-- resizing splits
-- recommended mappings
-- resizing splits
-- vim.keymap.set('n', '<A-h>', require('smart-splits').resize_left)
-- vim.keymap.set('n', '<A-j>', require('smart-splits').resize_down)
-- vim.keymap.set('n', '<A-k>', require('smart-splits').resize_up)
-- vim.keymap.set('n', '<A-l>', require('smart-splits').resize_right)
-- moving between splits
vim.keymap.set('n', '<C-h>', require('smart-splits').move_cursor_left)
vim.keymap.set('n', '<C-j>', require('smart-splits').move_cursor_down)
vim.keymap.set('n', '<C-k>', require('smart-splits').move_cursor_up)
vim.keymap.set('n', '<C-l>', require('smart-splits').move_cursor_right)
-- local spread = require("spread")
-- local default_options = {
--   silent = true,
--   noremap = true
-- }
-- vim.keymap.set("n", "<LocalLeader>ss", spread.out, default_options)
-- vim.keymap.set("n", "<LocalLeader>sc", spread.combine, default_options)

-- require('which-key').register({
lvim.builtin.which_key.on_config_done = function(wk)
  wk.register({
    ["<LocalLeader>"] = {
      name = "+Spread",
      ss = { "<cmd>lua require('spread').out()<cr>", "Out" },
      sc = { "<cmd>lua require('spread').combine()<cr>", "Combine" },
    },
  })
end

-- lvim.builtin.which_key.mappings["H"] = {
--   name = "+Harpoon",
--   h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Quick Menu" },
-- require('numbers').setup()

-- -- Disable transparency in neovide otherwise black bg bc
-- vim.cmd[[
-- if exists("g:neovide")
--     " Put anything you want to happen only in Neovide here
--     trans_bg = false
-- endif
-- ]]

local trans_bg = true

if vim.g.neovide then
  trans_bg = false
end

-- Catppuccin Colorscheme Config
require("catppuccin").setup({
  transparent_background = trans_bg,
  term_colors = false,
  compile = {
    enabled = false,
    path = vim.fn.stdpath("cache") .. "/catppuccin",
  },
  -- dim_inactive = { -- why does this setting suck and not do light?
  --   enabled = false,
  --   shade = "dark",
  --   percentage = 0.15,
  -- },
  -- styles = {
  --   comments = { "italic" },
  --   conditionals = { "italic" },
  --   loops = {},
  --   functions = {},
  --   keywords = {},
  --   strings = {},
  --   variables = {},
  --   numbers = {},
  --   booleans = {},
  --   properties = {},
  --   types = {},
  --   operators = {},
  -- },
  -- integrations = {
  --   treesitter = true,
  --   cmp = true,
  --   gitsigns = true,
  --   telescope = true,
  --   nvimtree = true,
  --   lsp_trouble = true,
  --   notify = true,
  --   lightspeed = true,
  -- },
  -- color_overrides = {},
  -- highlight_overrides = {},
})
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

-- local bufferlineopts = require("catppuccin.groups.integrations.bufferline").get()
-- lvim.builtin.bufferline.highlights = bufferlineopts
-- lvim.builtin.bufferline.highlights.merge(bufferlineopts)
-- lvim.builtin.bufferline.highlights = require("catppuccin.groups.integrations.bufferline").get()()
-- lvim.builtin.bufferline.options.numbers = "both"
-- lvim.builtin.bufferline.highlights.background.gui = "italic"
-- lvim.builtin.bufferline.highlights.buffer_selected.gui = "bold"
-- lvim.builtin.bufferline.options.show_buffer_close_icons = false
-- lvim.builtin.bufferline.options.mode = "buffers"
-- lvim.builtin.bufferline.options.separator_style = "padded_slant"
lvim.builtin.bufferline.options.themable = true
-- separator_style = "slant" | "padded_slant" | "thick" | "thin" | { "any", "any" },

-- lvim.builtin.bufferline.setup({})
-- vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha


-- Ranger plugin config
vim.g.rnvimr_enable_ex = 1 -- replace netrw or whatever
vim.g.rnvimr_draw_border = 0 -- no border
vim.g.rnvimr_pick_enable = 1 -- hide after selecting file
vim.g.rnvimr_bw_enable = 1 -- wipe the buffers corresponding to the files deleted by Ranger
vim.g.rnvimr_shadow_winblend = 100

-- Map Rnvimr action
vim.cmd [[
" Map Rnvimr action
let g:rnvimr_action = {
            \ '<C-t>': 'NvimEdit tabedit',
            \ '<C-x>': 'NvimEdit split',
            \ '<C-v>': 'NvimEdit vsplit',
            \ 'gw': 'JumpNvimCwd',
            \ 'yw': 'EmitRangerCwd'
            \ }
]]
-- let g:rnvimr_action['<C-t>'] = 'NvimEdit tabedit'
-- vim.g.rnvimr_action['<C-x>'] = 'NvimEdit split'
-- vim.g.rnvimr_action['<C-v>'] = 'NvimEdit vsplit'
-- 'gw': 'JumpNvimCwd',
-- 'yw': 'EmitRangerCwd'

-- Attempt Config
require('attempt').setup({
  ext_options = { 'py', 'md', 'txt', '' }
})
-- https://github.com/ray-x/lsp_signature.nvim
require('lsp_signature').setup({
  debug = false, -- set to true to enable debug logging
  -- log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
  -- default is  ~/.cache/nvim/lsp_signature.log
  verbose = false, -- show debug line number

  bind = true, -- This is mandatory, otherwise border config won't get registered.
  -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
  -- set to 0 if you DO NOT want any API comments be shown
  -- This setting only take effect in insert mode, it does not affect signature help in normal
  -- mode, 10 by default

  max_height = 15, -- max height of signature floating_window
  max_width = 100, -- max_width of signature floating_window
  wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long

  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
  -- will set to true when fully tested, set to false will use whichever side has more space
  -- this setting will be helpful if you do not want the PUM and floating win overlap

  floating_window_off_x = 1, -- adjust float windows x position.
  floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines

  close_timeout = 4000, -- close floating window after ms when laster parameter is entered
  fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
  hint_scheme = "String",
  hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
  handler_opts = {
    border = "none" -- double, rounded, single, shadow, none
  },

  always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = '<C-x>', -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'

  select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
  move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
})

-- Marks Config
require('marks').setup {
  -- whether to map keybinds or not. default true
  default_mappings = true,
  -- which builtin marks to show. default {}
  builtin_marks = { ".", "<", ">", "^" },
  -- whether movements cycle back to the beginning/end of buffer. default true
  cyclic = true,
  -- whether the shada file is updated after modifying uppercase marks. default false
  force_write_shada = false,
  -- how often (in ms) to redraw signs/recompute mark positions.
  -- higher values will have better performance but may cause visual lag,
  -- while lower values may cause performance penalties. default 150.
  refresh_interval = 150,
  -- sign priorities for each type of mark - builtin marks, uppercase marks, lowercase
  -- marks, and bookmarks.
  -- can be either a table with all/none of the keys, or a single number, in which case
  -- the priority applies to all marks.
  -- default 10.
  sign_priority = { lower = 10, upper = 15, builtin = 8, bookmark = 20 },
  -- disables mark tracking for specific filetypes. default {}
  excluded_filetypes = {},
  -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own
  -- sign/virttext. Bookmarks can be used to group together positions and quickly move
  -- across multiple buffers. default sign is '!@#$%^&*()' (from 0 to 9), and
  -- default virt_text is "".
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world"
  },
  mappings = {}
}
-- Telescope select marks
lvim.builtin.which_key.mappings['m'] = { "<cmd>lua require('telescope.builtin').marks{}<CR>", "Marks" }
-- Log file highlighting
vim.cmd [[
au BufNewFile,BufRead *.log.* set filetype=log
]]

require("todo-comments").setup()

-- Nabla plugin for latex preview (not working)
-- vim.cmd [[
--   " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`
--   nnoremap <A-c>:lua require("nabla").popup()<CR>
--   ]]

require("nvim-treesitter.configs").setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

-- local tagbar_config = {
--   ctagstype= 'markdown',
--   ctagsbin='~/Documents/markdown2ctags.py',
--   ctagsargs= '-f - --sort=yes --sro=&&&',
--   kinds={'s:sections', 'i:images'},
--   sro='&&&',
--   kind2scope={s='section'},
--   sort=0,
-- }


-- Plugin: command-center (Using this to bookmark commands/wiki dirs)
-- local command_center = require("command_center")
-- local noremap = { noremap = true }
-- local silent_noremap = { noremap = true, silent = false }
-- let g:tagbar_type_markdown = {'ctagstype': 'markdown','ctagsbin' : '~/Documents/markdown2ctags.py','ctagsargs' : '-f - --sort=yes --sro=»','kinds' : ['s:sections','i:images'],'sro' : '»','kind2scope' : {'s' : 'section',},'sort': 0}

-- command_center.add({
--   {
--     description = "Home",
--     cmd = "<CMD>VimwikiIndex 1<CR>",
--     -- keybindings = { "n", "<leader>gd", noremap },
--     category = "notes",
--   },
-- }, command_center.mode.ADD_ONLY)


-- local telescope = require("telescope")
-- telescope.setup {
--   extensions = {
--     command_center = {
--       -- Below are default settings that can be overriden ...

--       -- Specify what components are shown in telescope prompt;
--       -- Order matters, and components may repeat
--       components = {
--         command_center.component.DESCRIPTION,
--         command_center.component.CATEGORY, -- hopefully this is supported someday
--         command_center.component.KEYBINDINGS,
--         command_center.component.COMMAND,
--       },

--       -- Spcify by what components that search results are ordered;
--       -- Order does not matter
--       sort_by = {
--         command_center.component.DESCRIPTION,
--         command_center.component.KEYBINDINGS,
--         command_center.component.COMMAND,
--       },

--       -- Change the separator used to separate each component
--       separator = " ",

--       -- When set to false,
--       -- The description compoenent will be empty if it is not specified
--       auto_replace_desc_with_cmd = true,

--       -- Default title to Telescope prompt
--       prompt_title = "Go to Wiki",
--     }
--   }
-- }

-- telescope.load_extension("command_center")

-- Plugin: Trouble
-- local trouble = require("trouble.providers.telescope")
-- require("telescope").setup({})
-- defaults = {
--   mappings = {
--     i = { ["<c-t>"] = trouble.open_with_trouble },
--     n = { ["<c-t>"] = trouble.open_with_trouble },
--   },
-- },
-- })

-- Plugin: Harpoon
-- require("harpoon").setup({})
-- C-S-h is a kitty keymap for scrolling?
-- vim.api.nvim_set_keymap("n", "<C-A-h>", "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>:lua require('harpoon.mark').add_file()<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-z>", "<cmd>:lua require('harpoon.ui').nav_file(1)<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-x>", "<cmd>:lua require('harpoon.ui').nav_file(2)<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-c>", "<cmd>:lua require('harpoon.ui').nav_file(3)<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-v>", "<cmd>:lua require('harpoon.ui').nav_file(4)<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<leader>H", "<cmd>:lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>",
-- { noremap = true })

lvim.builtin.which_key.mappings["H"] = {
  name = "+Harpoon",
  h = { "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", "Quick Menu" },
  m = { "<cmd>lua require('harpoon.mark').add_file()<cr>", "Mark File" },
  z = { "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", "File 1" },
  x = { "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", "File 2" },
  c = { "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", "File 3" },
  v = { "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", "File 4" },
}

lvim.builtin.which_key.mappings["a"] = {
  name = "+Attempt",
  l = { "<cmd>Telescope attempt<cr>", "List Attempts" },
  n = { "<cmd>lua require('attempt').new_select()<cr>", "New Attempt" },
  R = { "<cmd>lua require('attempt').run()<cr>", "Run Attempt" },
  d = { "<cmd>lua require('attempt').delete()<cr>", "Delete Attempt" },
  r = { "<cmd>lua require('attempt').rename()<cr>", "Rename Attempt" },
}

lvim.builtin.which_key.mappings["r"] = { "<cmd>RnvimrToggle<cr>", "Ranger" }

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "telescope-project")
  pcall(telescope.load_extension, "ui-select")
  pcall(telescope.load_extension, "attempt")
end
-- telescope.load_extension('harpoon')

-- Plugin: goto-preview telescope and keymaps
require('goto-preview').setup {
  width = 80; -- Width of the floating window
  height = 60; -- Height of the floating window
  border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" }; -- Border characters of the floating window
  default_mappings = false; -- Bind default mappings
  debug = false; -- Print debug information
  opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
  resizing_mappings = false; -- Arrow keys resize the floating window. <- This is messing me up bc its a global map, not just for their window
  post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
  -- references = { -- Configure the telescope UI for slowing the references cycling window.
  --   telescope = telescope.themes.get_dropdown({ hide_preview = false }),
  -- },
  -- These two configs can also be passed down to the goto-preview definition and implementation calls for one off "peek" functionality.
  -- focus_on_open = true; -- Focus the floating window when opening it.
  -- dismiss_on_move = true; -- Dismiss the floating window when moving the cursor.
  -- force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  -- bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}

vim.api.nvim_set_keymap("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
  { noremap = true })
vim.api.nvim_set_keymap("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", { noremap = true })
-- Shows references in telescope
vim.api.nvim_set_keymap("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", { noremap = true })

-- Plugin: Twilight
require("twilight").setup({
  dimming = {
    alpha = 0.4, -- amount of dimming
    -- we try to get the foreground from the highlight groups or fallback color
    color = { "Normal", "#ffffff" },
    inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
  },
  context = 10, -- amount of lines we will try to show around the current line
  treesitter = true, -- use treesitter when available for the filetype
  -- treesitter is used to automatically expand the visible text,
  -- but you can further control the types of nodes that should always be fully expanded
  expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
    "function_definition",
    "method_definition",
    "function",
    "method",
    "table_constructor",
    "table",
    -- "if_statement",
  },
  exclude = {}, -- exclude these filetypes
  -- Dont know why this doesnt work
  on_open = function(win)
    -- require('treesitter-context').enable()
    vim.cmd [[TSContextEnable]]
  end,
  -- on_close = function()
  --    require('treesitter-context').disable()
  -- end,
})

-- Plugin: Zen Mode
require("zen-mode").setup({
  window = {
    -- backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
    -- height and width can be:
    -- * an absolute number of cells when > 1
    -- * a percentage of the width / height of the editor when <= 1
    -- * a function that returns the width or the height
    width = 140, -- width of the Zen window
    height = 1, -- height of the Zen window
    -- by default, no options are changed for the Zen window
    -- uncomment any of the options below, or add other vim.wo options you want to apply
    options = {
      signcolumn = "no", -- disable signcolumn
      -- number = false, -- disable number column
      -- relativenumber = false, -- disable relative numbers
      -- cursorline = false, -- disable cursorline
      -- cursorcolumn = false, -- disable cursor column
      -- foldcolumn = "0", -- disable fold column
      -- list = false, -- disable whitespace characters
    },
  },
  plugins = {
    -- disable some global vim options (vim.o...)
    -- comment the lines to not apply the options
    options = {
      enabled = true,
      ruler = false, -- disables the ruler text in the cmd line area
      showcmd = false, -- disables the command in the last line of the screen
    },
    twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
    treesitter_context = { enabled = true },
    gitsigns = { enabled = false }, -- disables git signs
    tmux = { enabled = false }, -- disables the tmux statusline
    -- this will change the font size on kitty when in zen mode
    -- to make this work, you need to set the following kitty options:
    -- - allow_remote_control socket-only
    -- - listen_on unix:/tmp/kitty
    kitty = {
      enabled = false,
      font = "+4", -- font size increment
    },
  },
})
lvim.keys.normal_mode['<leader>z'] = '<cmd>ZenMode<CR>'
-- lvim.builtin.which_key.mappings['z'] = '<cmd>ZenMode<CR>'
-- lvim.builtin.which_key.insert('z', '<cmd>ZenMode<CR>')


-- Plugin: treesitter-context
require('treesitter-context').setup {
  enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
  trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
    -- For all filetypes
    -- Note that setting an entry here replaces all other patterns for this entry.
    -- By setting the 'default' entry below, you can control which nodes you want to
    -- appear in the context window.
    default = {
      'class',
      'function_definition',
      'function',
      'method_definition',
      'method',
      -- 'for', -- These won't appear in the context
      -- 'while',
      -- 'if',
      -- 'switch',
      -- 'case',
    },
    -- Example for a specific filetype.
    -- If a pattern is missing, *open a PR* so everyone can benefit.
    --   rust = {
    --       'impl_item',
    --   },
  },
  exact_patterns = {
    -- Example for a specific filetype with Lua patterns
    -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
    -- exactly match "impl_item" only)
    -- rust = true,
  },

  -- [!] The options below are exposed but shouldn't require your attention,
  --     you can safely ignore them.

  zindex = 20, -- The Z-index of the context window
  mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
}

-- Plugin: Session Manager
local Path = require('plenary.path')
require('session_manager').setup({
  sessions_dir = Path:new(vim.fn.stdpath('data'), 'sessions'), -- The directory where the session files will be saved.
  -- sessions_dir = Path:new('/home/marco/.config/vim-sessions'), -- The directory where the session files will be saved.
  path_replacer = '__', -- The character to which the path separator will be replaced for session files.
  colon_replacer = '++', -- The character to which the colon symbol will be replaced for session files.
  autoload_mode = require('session_manager.config').AutoloadMode.CurrentDir, -- Define what to do when Neovim is started without arguments. Possible values: Disabled, CurrentDir, LastSession
  autosave_last_session = true, -- Automatically save last session on exit and on session switch.
  autosave_ignore_not_normal = true, -- Plugin will not save a session when no buffers are opened, or all of them aren't writable or listed.
  autosave_ignore_filetypes = { -- All buffers of these file types will be closed before the session is saved.
    'gitcommit',
  },
  autosave_only_in_session = false, -- Always autosaves session. If true, only autosaves after a session is active.
  max_path_length = 80, -- Shorten the display path if length exceeds this threshold. Use 0 if don't want to shorten the path at all.
})


-- Plugin: Glow
lvim.keys.normal_mode["<C-g>"] = ":Glow<cr>"

-- Plugin: Magma
-- let g:magma_automatically_open_output = v:true
vim.cmd([[
    nnoremap <expr> <LocalLeader>r nvim_exec('MagmaEvaluateOperator', v:true)
    nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
    xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
    nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
    nnoremap <silent>       <LocalLeader>rd :MagmaDelete<CR>
    nnoremap <silent>       <LocalLeader>ro :MagmaShowOutput<CR>
]])
-- lvim.builtin.which_key.register({
--   ["<LocalLeader>"] = {
--     name = "+Magma",
--     rr = { "<cmd>MagmaEvaluateLine<cr>", "Evaluate Line" },
--     r = { "<cmd>MagmaEvaluateVisual<cr>", "Evaluate Visual" },
--     rc = { "<cmd>MagmaReevaluateCell<cr>", "Revaluate Cell" },
--     rd = { "<cmd>MagmaDelete<cr>", "Magma Delete" },
--     ro = { "<cmd>MagmaShowOutput<cr>", "Magma Show Output" },

--   },
-- })

-- Plugin: ThePrimeagen Refactoring
-- require('refactoring').setup({})
-- load refactoring Telescope extension
-- require("telescope").load_extension("refactoring")
-- local sources = { null_ls.builtins.code_actions.refactoring }
-- local code_actions = require "lvim.lsp.null-ls.code_actions"
-- code_actions.setup(
--   {
--     command = "refactoring",
--     filetypes = { "python" },
--   }
-- )
-- remap to open the Telescope refactoring menu in visual mode
-- vim.api.nvim_set_keymap(
--   "v",
--   "<leader>rr",
--   "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
--   { noremap = true }
-- )

-- Plugin: Tagbar options
vim.g.tagbar_autofocus = 1
vim.g.tagbar_autoclose = 1
vim.g.tagbar_compact = 1 -- Hide help and blank lines
vim.g.tagbar_sort = 0 -- Sort by position in file, not alphabetically
-- vim.g.tagbar_show_data_type = 1
vim.g.tagbar_show_tag_linenumbers = 1 -- 1 for right, 2 for left
-- vim.g.tagbar_show_tag_count = 1
vim.g.tagbar_autoshowtag = 1 -- unfold and show current tag
-- vim.g.tagbar_autopreview = 1 -- show preview window for tag
-- vim.g.tagbar_previewin_pos = "rightbelow vertical"

vim.api.nvim_set_keymap(
  "n",
  "<leader>tt",
  "<cmd>TagbarToggle<CR>",
  { noremap = true }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>tj",
  "<cmd>TagbarJumpNext<CR>",
  { noremap = true }
)
vim.api.nvim_set_keymap(
  "n",
  "<leader>tJ",
  "<cmd>TagbarJumpPrev<CR>",
  { noremap = true }
)

-- Colorschemes
vim.g.onedark_transparent = true

vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_transparent_background = 0

-- lvim.colorscheme = "gruvbox-material"
lvim.colorscheme = "catppuccin"


-- Plugin: Luasnip snippets
local ls = require('luasnip')
-- some shorthands...
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")

-- args is a table, where 1 is the text in Placeholder 1, 2 the text in
-- placeholder 2,...
local function copy(args)
  return args[1]
end

ls.add_snippets("python", {
  -- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
  -- s("fn", {
  --   -- Simple static text.
  --   t("//Parameters: "),
  --   -- function, first parameter is the function, second the Placeholders
  --   -- whose text it gets as input.
  --   f(copy, 2),
  --   t({ "", "function " }),
  --   -- Placeholder/Insert.
  --   i(1),
  --   t("("),
  --   -- Placeholder with initial text.
  --   i(2, "int foo"),
  --   -- Linebreak
  --   t({ ") {", "\t" }),
  --   -- Last Placeholder, exit Point of the snippet.
  --   i(0),
  --   t({ "", "}" }),
  -- }),
  s("typing", {
    t({ "from __future__ import annotations", "from typing import TYPE_CHECKING", "if TYPE_CHECKING:", "\t" }),
    i(0),
  })
  -- Alternative printf-like notation for defining snippets. It uses format
  -- string with placeholders similar to the ones used with Python's .format().
  -- s(
  --   "fmt1",
  --   fmt("To {title} {} {}.", {
  --     i(2, "Name"),
  --     i(3, "Surname"),
  --     title = c(1, { t("Mr."), t("Ms.") }),
  --   })
  -- ),
}
)
