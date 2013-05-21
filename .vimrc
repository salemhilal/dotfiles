" Use a custom color scheme. 
colorscheme euler 
" colorscheme vividchalk

" Basic config
set hidden
set nocompatible
set backspace=indent,eol,start

" Numbers and rulers in helpful places
set ruler
set number

" Smart indenting
set smartindent

" Lets see what we're commanding
set showcmd

set tabstop=4
set shiftwidth=4
" set mouse=nv " or, alternatively, mouse=a
set mouse=a

" F11 to toggle paste mode
map <F5> :set invpaste<CR>
set pastetoggle=<F5>

" Make tab/shift+tab change selection tabbing
vmap <Tab> >gv
vmap <S-Tab> <gv

" Scroll 3 lines at a time, not one
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" 'Some stuff yourOS should do, but doesn't.'
syntax on
filetype on
filetype plugin on
filetype indent on

" Search highlighting (dynamically)
set hlsearch
set incsearch

" NO MORE BEEPS! Instead, scary screen flashes!
set visualbell

" Put swapfiles all in the same place.
" Comment out if working with multiple vim people,
" as their instances of vim won't see our swapfiles.
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

set ttymouse=xterm  " so vim doesn't hang inside screen and tmux
