" Sensible defaults
set nocompatible
syntax on
filetype plugin indent on

" UI
set number
set relativenumber
set cursorline
set showcmd
set showmatch
set wildmenu
set wildmode=longest:full,full
set laststatus=2
set ruler

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap <CR> :nohlsearch<CR><CR>

" Indentation
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set smartindent

" Editing
set backspace=indent,eol,start
set clipboard=unnamed
set mouse=a
set scrolloff=8
set sidescrolloff=8

" Files
set hidden
set noswapfile
set nobackup
set undofile
set undodir=~/.vim/undo

" Performance
set lazyredraw
set ttyfast

" Key mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :Ex<CR>

" Move lines up/down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Keep cursor centered
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap n nzzzv
nnoremap N Nzzzv

" Quick split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Create undo directory if needed
if !isdirectory($HOME . "/.vim/undo")
    call mkdir($HOME . "/.vim/undo", "p")
endif
