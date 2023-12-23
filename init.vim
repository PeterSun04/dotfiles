set nocompatible

set hidden

set wildmenu

set showcmd

set hlsearch

set autoindent

set nostartofline

set ruler

set laststatus=2

set visualbell

set number

set cmdheight=2

set clipboard+=unnamedplus

set notimeout ttimeout ttimeoutlen=200

set pastetoggle=<F11>

set shiftwidth=4
set softtabstop=4
set expandtab

if exists("g:neovide")
    let g:neovide_cursor_trail_size = 0.5
    let g:neovide_refresh_rate_idle = 5
    let g:neovide_confirm_quit = v:true
    let g:neovide_cursor_vfx_mode = ""
    let g:neovide_cursor_animation_length=0.10
    let g:neovide_cursor_vfx_opacity = 200
    let g:neovide_cursor_vfx_particle_density = 200
    let g:neovide_cursor_vfx_particle_speed = 10.0
    let g:neovide_cursor_vfx_particle_phase = 1.5
    let g:neovide_cursor_vfx_particle_curl = 1.0
endif

setlocal spell
set spelllang=nl,en_gb
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

if has('filetype')
  filetype indent plugin on
endif

" Enable syntax highlighting
if has('syntax')
  syntax on
endif

if has('mouse')
  set mouse=a
endif

inoremap <C-BS> <C-w>
inoremap <M-Del> <cmd>norm! dw<CR>

set number

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'dracula/vim', { 'as': 'dracula' }

Plug 'tpope/vim-fugitive'

Plug 'lervag/vimtex'
let g:tex_flavor='latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0
"set conceallevel=1
let g:vimtex_view_general_options
    \ = '-reuse-instance -forward-search @tex @line @pdf'
let g:vimtex_quickfix_mode=0
"let g:vimtex_compiler_method = 'latexrun'
let g:vimtex_view_forward_search_on_start=1

"let g:netrw_banner = 0
"let g:netrw_liststyle = 3
"let g:netrw_browse_split = 4
"let g:netrw_altv = 1
"let g:netrw_winsize = 5
"augroup ProjectDrawer
"  autocmd!
"  autocmd VimEnter * :Vexplore
"augroup END

Plug 'sirver/ultisnips'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'

Plug 'honza/vim-snippets'

Plug 'nvim-lua/plenary.nvim'

Plug 'nvim-telescope/telescope.nvim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'tpope/vim-repeat'

Plug 'ggandor/lightspeed.nvim'

Plug 'junegunn/goyo.vim'

Plug 'junegunn/limelight.vim'

" tabular plugin is used to format tables
Plug 'godlygeek/tabular'
" JSON front matter highlight plugin
Plug 'elzr/vim-json'

Plug 'plasticboy/vim-markdown'

" disable header folding
let g:vim_markdown_folding_disabled = 1

" do not use conceal feature, the implementation is not so good
let g:vim_markdown_conceal = 0

" disable math tex conceal feature
let g:tex_conceal = ""
let g:vim_markdown_math = 1

" support front matter of various format
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

" do not close the preview tab when switching to other buffers
let g:mkdp_auto_close = 0

let g:mkdp_browser = 'firefox'
call plug#end()

colorscheme dracula

map Y y$
