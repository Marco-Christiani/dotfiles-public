vim.g.colorcolumn = 120
vim.o.cmdheight = 1
vim.o.grepprg = "rg --vimgrep"
vim.o.grepformat = "grepformat=%f:%l:%c:%m"

set viminfo='1000,f1

vim.cmd[[
    augroup remember_folds
    autocmd!
    autocmd BufWinLeave *.* mkview
    autocmd BufWinEnter *.* silent! loadview
    augroup END
]]

vim.cmd[[set foldmethod=manual]]

local opts = { noremap = true, silent = true }
vim.keymap.set({'n'}, "<Up>", "<Up>", opts)
vim.keymap.set({'n'}, "<Down>", "<Down>", opts)
vim.keymap.set({'n'}, "<Left>", "<Left>", opts)
vim.keymap.set({'n'}, "<Right>", "<Right>", opts)

vim.g.neovide_transparency=0.8
vim.o.guifont = "Fira Code Regular"
vim.g.gui_font_default_size = 12
vim.g.gui_font_size = vim.g.gui_font_default_size
vim.g.gui_font_face = "Fira Code Retina"

RefreshGuiFont = function()
  vim.opt.guifont = string.format("%s:h%s",vim.g.gui_font_face, vim.g.gui_font_size)
end

ResizeGuiFont = function(delta)
  vim.g.gui_font_size = vim.g.gui_font_size + delta
  RefreshGuiFont()
end

ResetGuiFont = function ()
  vim.g.gui_font_size = vim.g.gui_font_default_size
  RefreshGuiFont()
end

-- Call function on startup to set default value
ResetGuiFont()
opts = { noremap = true, silent = true }
vim.keymap.set({'n', 'i'}, "<C-+>", function() ResizeGuiFont(1)  end, opts)
vim.keymap.set({'n', 'i'}, "<C-->", function() ResizeGuiFont(-1) end, opts)
vim.keymap.set({'n', 'i'}, "<C-BS>", function() ResetGuiFont() end, opts)

lvim.log.level = "warn"
lvim.format_on_save = true
lvim.builtin.terminal.insert_mappings = false -- whether or not the open mapping applies in insert mode
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true

lvim.transparent_window = false
vim.opt.termguicolors = true
lvim.builtin.cmp.completion.keyword_length = 2
-- To change the completion menu appearance
-- lvim.builtin.cmp.experimental.native_menu = true
-- require("cmp").view = {entries='native'}

lvim.leader = "space"
-- e maps to insert after word
-- vim.cmd("nnoremap <silent> e ea")

lvim.keys.normal_mode["<A-s>"] = ":w<cr>"
lvim.keys.normal_mode["<A-Enter>"] = "o<Esc>" -- my thing
vim.cmd[[
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

lvim.builtin.terminal.active = true
lvim.builtin.terminal.size = 10
-- lvim.builtin.terminal.insert_mappings = false -- whether or not the open mapping applies in insert mode

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.actions.open_file.quit_on_open = true

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  -- "c",
  -- "javascript",
  "json",
  "lua",
  -- "python",
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
lvim.builtin.treesitter.highlight.enabled = true

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
-- require 'telescope'.load_extension('project')
-- vim.api.nvim_set_keymap(
--   'n',
--   '<C-p>',
--   ":lua require'telescope'.extensions.project.project{}<CR>",
--   { noremap = true, silent = true }
-- )
-- require('telescope').setup({
--   extensions = {
--     project = {
--       base_dirs = {
--         { '~/Github', max_depth = 4 },
--       },
--       hidden_files = true, -- default: false
--       theme = "dropdown",
--       display_type = 'full'
--     }
--   }
-- })
-- Lua
-- require("trouble").setup {
--   -- your configuration comes here
--   -- or leave it empty to use the default settings
--   -- refer to the configuration section below
-- }
-- local actions = require("telescope.actions")

lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }

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

lvim.lsp.automatic_servers_installation = true

vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "sumneko_lua" })
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pylsp" })

local opts = {} -- check the lspconfig documentation for a list of all possible options
require("lvim.lsp.manager").setup("pylsp", opts)

opts = {
  init_options = {
    token = "user_Ro0e1rU2jjNUeNvkCbKXlEpfKyeF3Z4g1vJ1CvgYWs6UEYiq_Lu3wM9QiOY"
  }
}

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

lvim.plugins = {
  {
    "nvim-treesitter/nvim-treesitter-context"
  },
  {
    "nvim-treesitter/playground",
  },
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
  {
    "luisiacc/gruvbox-baby", -- colorscheme
  },
  {
    "sainnhe/gruvbox-material" -- colorscheme
  },
  {
    "savq/melange" -- colorscheme
  },
  {
    "EdenEast/nightfox.nvim" -- colorscheme
  },
  {
    "ful1e5/onedark.nvim" -- colorscheme
  },
  {
    "rafamadriz/neon" -- colorscheme
  },
  {
    "tanvirtin/monokai.nvim" -- colorscheme
  },
  {
    "glepnir/zephyr-nvim" -- colorscheme
  },
  {
    "NTBBloodbath/doom-one.nvim" -- colorscheme
  },
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
    event = { "BufRead", "BufNew" },
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
    'Shatur/neovim-session-manager',  -- use to reload last session associated with a directory
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
  {
    "jbyuki/nabla.nvim" -- preview latex (not working)
  },
  {
    "vimwiki/vimwiki" -- note taking
  },
  {
    "tools-life/taskwiki" -- vimwiki/taskwarrior integration
  },
  {
    "ThePrimeagen/harpoon"
  },
  {
    "gyim/vim-boxdraw"
  },
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
  -- {
  --   "python-mode/python-mode" -- LSP stuff
  -- },

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
}

vim.cmd[[
au BufNewFile,BufRead *.log.* set filetype=log
]]

require("todo-comments").setup()
-- Nabla plugin for latex preview (not working)
vim.cmd[[
  " Customize with popup({border = ...})  : `single` (default), `double`, `rounded`
  nnoremap <A-c>:lua require("nabla").popup()<CR>
  ]]

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

vim.g.tagbar_autofocus = 1
vim.g.tagbar_autoclose = 1

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

local tagbar_config = {
  ctagstype= 'markdown',
  ctagsbin='~/Documents/markdown2ctags.py',
  ctagsargs= '-f - --sort=yes --sro=&&&',
  kinds={'s:sections', 'i:images'},
  sro='&&&',
  kind2scope={s='section'},
  sort=0,
}

vim.g.tagbar_type_markdown = tagbar_config
vim.g.tagbar_type_vimwiki = tagbar_config
vim.cmd([[
  let g:tagbar_type_markdown = {
      \ 'ctagstype': 'markdown',
      \ 'ctagsbin' : '~/Documents/markdown2ctags.py',
      \ 'ctagsargs' : '-f - --sort=yes --sro=»',
      \ 'kinds' : [
          \ 's:sections',
          \ 'i:images'
      \ ],
      \ 'sro' : '»',
      \ 'kind2scope' : {
          \ 's' : 'section',
      \ },
      \ 'sort': 0,
  \ }
  ]])

local trouble = require("trouble.providers.telescope")
require("telescope").setup({
  defaults = {
    mappings = {
      i = { ["<c-t>"] = trouble.open_with_trouble },
      n = { ["<c-t>"] = trouble.open_with_trouble },
    },
  },
})

vim.api.nvim_set_keymap("n", "<C-e>", "<cmd>:lua require('harpoon.ui').toggle_quick_menu()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>a", "<cmd>:lua require('harpoon.mark').add_file()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-z>", "<cmd>:lua require('harpoon.ui').nav_file(1)<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-x>", "<cmd>:lua require('harpoon.ui').nav_file(2)<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<C-c>", "<cmd>:lua require('harpoon.ui').nav_file(3)<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<C-v>", "<cmd>:lua require('harpoon.ui').nav_file(4)<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>H", "<cmd>:lua require('harpoon.cmd-ui').toggle_quick_menu()<CR>",{ noremap = true })

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "telescope-project")
  pcall(telescope.load_extension, "ui-select")
end

require('goto-preview').setup {
  width = 80; -- Width of the floating window
  height = 60; -- Height of the floating window
  border = {"↖", "─" ,"┐", "│", "┘", "─", "└", "│"}; -- Border characters of the floating window
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

vim.api.nvim_set_keymap("n", "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", {noremap=true})
-- Shows references in telescope
vim.api.nvim_set_keymap("n", "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", {noremap=true})

require("twilight").setup({
  dimming = {
    alpha = 0.3, -- amount of dimming
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
    vim.cmd[[TSContextEnable]]
  end,
  -- on_close = function()
  --    require('treesitter-context').disable()
  -- end,
})

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

require('treesitter-context').setup{
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
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
}

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

lvim.keys.normal_mode["<C-g>"] = ":Glow<cr>"

vim.cmd([[
    nnoremap <expr> <LocalLeader>r nvim_exec('MagmaEvaluateOperator', v:true)
    nnoremap <silent>       <LocalLeader>rr :MagmaEvaluateLine<CR>
    xnoremap <silent>       <LocalLeader>r  :<C-u>MagmaEvaluateVisual<CR>
    nnoremap <silent>       <LocalLeader>rc :MagmaReevaluateCell<CR>
    nnoremap <silent>       <LocalLeader>rd :MagmaDelete<CR>
    nnoremap <silent>       <LocalLeader>ro :MagmaShowOutput<CR>
]])

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

ls.add_snippets("all", {
  -- trigger is `fn`, second argument to snippet-constructor are the nodes to insert into the buffer on expansion.
  s("fn", {
    -- Simple static text.
    t("//Parameters: "),
    -- function, first parameter is the function, second the Placeholders
    -- whose text it gets as input.
    f(copy, 2),
    t({ "", "function " }),
    -- Placeholder/Insert.
    i(1),
    t("("),
    -- Placeholder with initial text.
    i(2, "int foo"),
    -- Linebreak
    t({ ") {", "\t" }),
    -- Last Placeholder, exit Point of the snippet.
    i(0),
    t({ "", "}" }),
  }),
  s("typing", {
    t({ "from __future__ import annotations", "from typing import TYPE_CHECKING", "if TYPE_CHECKING:", "" }),
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

vim.g.onedark_transparent = true

vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_transparent_background = 0
lvim.colorscheme = "gruvbox-material"
