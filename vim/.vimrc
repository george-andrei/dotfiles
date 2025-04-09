syntax on
" use spaces instead of tabs
set expandtab
set tabstop=4
set shiftwidth=4

" define char for tabs
set list
set listchars=tab:\ ┊\ 
set listchars=multispace:\ ┊\ 

" always show line numbers
set number

" highlight current line
set cursorline

" Smart case searching
set ignorecase
set smartcase

" highlight search words
set hlsearch

" set colorscheme
set background=dark
colorscheme PaperColor

highlight SpecialKey ctermfg=darkgray guifg=#808080

" when doing :vs split right
set splitright
" when doing :sp split below
set splitbelow

" Enable the mouse in all modes
set mouse=a

" soft wrap
set textwidth=0
set wrapmargin=0
set wrap
set linebreak

autocmd InsertEnter,InsertLeave * set cul!

""""""""""""""""""""""""""""""""""""""""
" Key Mappings
""""""""""""""""""""""""""""""""""""""""
" change the leader key to comma
let mapleader=","

" clear search highlighting with <space>,
map <space> :noh<CR>

" Quickly save, quit, or save-and-quit
map <leader>w :w<CR>
map <leader>x :x<CR>
map <leader>q :q<CR>

"navigate tabs
map <leader>n :tabn<CR>
map <leader>p :tabp<CR>

" tab for cycling through options
inoremap <expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"

" escape by mashing j and k
inoremap jk <Esc>
inoremap jj <Esc>

" sensible long line navigation
nmap j gj
nmap k gk

" open up netrw
map - :Explore<CR>
" hide the netrw banner
let g:netrw_banner = 0

" don't auto-fold
set foldlevelstart=99

" Escape mappings for terminal mode
:tnoremap <Esc> <C-\><C-n>
:tnoremap jk <C-\><C-n>
:tnoremap jj <C-\><C-n>


" Vim Diff
" https://vim.fandom.com/wiki/Diff_current_buffer_and_the_original_file
function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()
