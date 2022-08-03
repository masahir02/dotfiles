" plugins
call plug#begin("$HOME/.local/share/nvim/plugged")
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'natebosch/vim-lsc'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sheerun/vim-polyglot'
Plug 'thinca/vim-quickrun'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
call plug#end()

let g:lsc_auto_map = v:true
let g:fzf_preview_window = []
let g:fzf_layout = { 'window': 'enew' }
let g:quickrun_config = {
\ '_': {
\   'outputter/buffer/opener': 'below 10 new',
\   'outputter/buffer/close_on_empty': 1,
\ },
\}

" chmod +x
autocmd BufWritePost * if getline(1) =~ "^#!" | :silent !chmod +x %
" mkdir -p
autocmd BufWritePre * :silent !mkdir -p %:p:h

" filetypes
augroup filetypedetect
autocmd FileType markdown        setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType sql             setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType css             setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType html            setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType javascript      setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType json            setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType typescript      setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType vim             setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType vue             setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType zsh             setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType go              setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab
autocmd FileType csv             syntax off
augroup END

" mapping keys
let mapleader = "\<Space>"
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
nnoremap <ESC><ESC> :on<CR>
nnoremap <Leader><Space> :set nu!<CR>:set list!<CR>:set wrap!<CR>:echo<CR>
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>f :Files<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>n :enew<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>r :QuickRun<CR>
nnoremap <Tab> :Buffers<CR>
nnoremap c "_c
nnoremap s "_s
nnoremap S "_S
xnoremap <expr> p 'pgv"'.v:register.'y`>'

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

set autoindent
set autoread
set backspace=indent,eol,start
set clipboard=unnamed
set cmdheight=1
set completeopt=menu
set confirm
set encoding=utf8
set expandtab
set fileencoding=utf8
set fileencodings=utf8
set fileformat=unix
set fileformats=
set guicursor=
set hidden
set history=1000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=tab:>.,trail:-,extends:\
set nobackup
set nostartofline
set noswapfile
set notimeout ttimeout ttimeoutlen=200
set nowrap
set number
set ruler
set scrolloff=5
set shiftwidth=4
set showcmd
set showmode
set smartcase
set softtabstop=4
set splitbelow
set splitright
set t_vb=
set tabstop=4
set visualbell
set wildmenu
