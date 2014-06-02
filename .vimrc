" Use pathogen
execute pathogen#infect()

" Use solarized. 
syntax enable
set background=dark
colorscheme solarized

" Basic config
set hidden
set nocompatible
set backspace=indent,eol,start

" Numbers and rulers in helpful places
set ruler
set number

" Lets see what we're commanding
set showcmd

" Tabs
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set sts=2
imap <S-Tab> <C-o><<

" set mouse=nv " or, alternatively, mouse=a
set mouse=a

" F5 to toggle paste mode
map <F5> :set invpaste<CR>
set pastetoggle=<F5>

" When I'm done searching, I'm done searching, alright? 
nnoremap <CR> :noh<CR><CR>

" Make tab/shift+tab change selection tabbing
vmap <Tab> >gv
vmap <S-Tab> <gv

" Scroll 3 lines at a time, not one
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" 'Some stuff yourOS should do, but doesn't.'
" syntax on
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

" CtrlP Config
let g:ctrlp_by_filename = 1
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|node_modules)$'

" golang
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on
