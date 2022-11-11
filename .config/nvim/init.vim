" Have pyright and ALE play nice
let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 1
let g:ale_sign_column_always = 1
let g:ale_hover_to_floating_preview = 1
let g:ale_floating_preview = 1 
let g:ale_completion_enabled = 0
" Sets -------------------------------------------------------------------------
" https://github.com/ThePrimeagen/.dotfiles/blob/master/nvim/.config/nvim/init.vim
" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*
" set guicursor=
" Default cursor
set guicursor=n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
" set noshowmode
set signcolumn=yes
set isfname+=@-@
" set ls=0
" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
" set colorcolumn=80
" -------- My Sets/remaps ------------------------------------------------------
set rtp+=/usr/bin/fzf
set clipboard+=unnamedplus
let mapleader=" "
" splits open to right
set splitright
" use ;; for escape
inoremap ;; <Esc>
" nnoremap <silent> <Space> :NERDTreeToggle<CR>
nnoremap <leader>t :NERDTreeToggle<CR>
nnoremap <leader>g :TagbarToggle<CR>
let g:tagbar_position = 'leftabove'
" set cindent
" set cursorline
" highlight clear cursorline
" hi CursorLineNr term=bold cterm=bold gui=bold ctermbg=31
" Move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" Move lines with Alt+Arrow
nnoremap <A-Down> :m .+1<CR>==
nnoremap <A-Up> :m .-2<CR>==
inoremap <A-Down> <Esc>:m .+1<CR>==gi
inoremap <A-Up> <Esc>:m .-2<CR>==gi
vnoremap <A-Down> :m '>+1<CR>gv=gv
vnoremap <A-Up> :m '<-2<CR>gv=gv
nnoremap <leader>v :vsplit<CR>
" split navigation
nnoremap <leader>h <C-w>h
" nnoremap <leader>j <C-w>j
" nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l
nnoremap <leader><Left> <C-w>h
nnoremap <leader><Down> <C-w>j
nnoremap <leader><Up> <C-w>k
nnoremap <leader><Right> <C-w>l
" split resize
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
nnoremap <leader>rp :resize 100<CR>
" Enable telescope theme
let g:gruvbox_baby_telescope_theme = 1

" Enable transparent mode
let g:gruvbox_baby_transparent_mode = 1

" colorscheme gruvbox
" Example config in VimScript
" let g:gruvbox_baby_function_style = "NONE"
" let g:gruvbox_baby_background_color= "dark"
" Start terminal in insert mode
au BufEnter * if &buftype == 'terminal' | :startinsert | endif
nnoremap <silent> <leader>tt :terminal<CR>
nnoremap <silent> <leader>tv :vnew<CR>:terminal<CR>
nnoremap <silent> <leader>th :new<CR>:terminal<CR>
tnoremap <C-x> <C-\><C-n><C-w>q

" If you don't want to turn 'hlsearch' on, but want to highlight all
"	matches while searching, you can turn on and off 'hlsearch' with
"	autocmd.  Example: >
augroup vimrc-incsearch-highlight
    autocmd!
    autocmd CmdlineEnter /,\? :set hlsearch
    autocmd CmdlineLeave /,\? :set nohlsearch
augroup END
" -----------------------------------------------------------------------------


" https://gist.github.com/subfuzion/7d00a6c919eeffaf6d3dbf9a4eb11d64
" let s:hidden_all = 0
" function! ToggleHiddenAll()
"     if s:hidden_all  == 0
"         let s:hidden_all = 1
"         set noshowmode
"         set noruler
"         set laststatus=0
"         set noshowcmd
" 	    TagbarClose
" 	    NERDTreeClose
"         " set foldcolumn=10
"  
"     else
" 	    set foldcolumn=0
"         let s:hidden_all = 0
"         set showmode
"         set ruler
"         set laststatus=2 
"         set showcmd
"         NERDTree
"         " NERDTree takes focus, so move focus back to the right
"         " (note: "l" is lowercase L (mapped to moving right)
"         wincmd l
"         TagbarOpen
" 
"     endif
" endfunction
" 
" nnoremap <silent> <leader>h :call ToggleHiddenAll()<CR>

" =====================================
" Custom find
" =====================================
" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
" command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" Load Plugins----------------------------------------------------------------- 
call plug#begin()
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'neoclide/coc-tabnine'
Plug 'pappasam/coc-jedi', { 'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
" Plug 'fannheyward/coc-pyright'
Plug 'itchyny/lightline.vim'
Plug 'maximbaz/lightline-ale'
Plug 'dense-analysis/ale'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Tagbar
" https://github.com/majutsushi/tagbar
Plug 'majutsushi/tagbar'
" loaded on first invocation of NERDTreeToggle 
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'nvim-lua/plenary.nvim'
" Start Primeagen stuff --------------------------------------------------------
" Plebvim lsp Plugins
" Plug 'onsails/lspkind-nvim'
" Plug 'github/copilot.vim'
" Plug 'nvim-lua/lsp_extensions.nvim'

" Snippets
" Plug 'rafamadriz/friendly-snippets'

" Theme
Plug 'gruvbox-community/gruvbox'
Plug 'luisiacc/gruvbox-baby'
" telescope requirements...
" Plug 'nvim-lua/popup.nvim'
" Plug 'nvim-telescope/telescope.nvim'
" Plug 'nvim-telescope/telescope-fzy-native.nvim'
 
" Plug 'vim-conf-live/vimconflive2021-colorscheme'
Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'

" HARPOON!!
" Plug 'mhinz/vim-rfc'

" prettier
" Plug 'sbdchd/neoformat'
call plug#end()
" ------------------------------------------------------------------------------

" Load the colorscheme
colorscheme gruvbox-baby
" Use autocmd to force lightline update.
" autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" Plugin Settings and Bindings-------------------------------------------------- 
source ~/.config/nvim/coc-settings.vim
source ~/.config/nvim/ll-ale-settings.vim

" Lightline status bar integration with CoC
let g:lightline = {
            \ 'colorscheme': 'wombat',
            \ 'active': {
                \   'left': [ [ 'mode', 'paste' ],
                \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
                \ },
                \ 'component_function': {
                    \   'cocstatus': 'coc#status'
                    \ },
                    \ }
" FZF Binds
nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent> <C-p> :GFiles<CR>

