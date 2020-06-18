" ---------------------------------
" 
" INITIALIZE VIM PLUG
" This is a package manager that'll autoinstall itself
"
" ---------------------------------
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" Sensible default config
Plug 'tpope/vim-sensible'

" Ale for linting
Plug 'dense-analysis/ale'

" GIT. GIT. GIT. GIT.
Plug 'tpope/vim-fugitive'

" Surround stuff with quotes and whatever
Plug 'tpope/vim-surround'

" Better support for comments
Plug 'tpope/vim-commentary'

" Paired keymappings that are p chill
Plug 'tpope/vim-unimpaired'

" Repeat commands with . if plugins support it
Plug 'tpope/vim-repeat'

" I like this color scheme
Plug 'plainfingers/black_is_the_color'

" Vim airline and airline themes
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Way better JS support
Plug 'pangloss/vim-javascript'

" Automatically identify tab width
Plug 'tpope/vim-sleuth'

" Fuzzy finding
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }


call plug#end()


" ---------------------------------
"
" GENERAL CONFIG
"
" I tried to keep these grouped in
" pretty logical sections, and I 
" commented this pretty heavily, 
" since vim settings can kinda be
" opaque sometimes.
"
" ---------------------------------


" The basics
"
" Don't try to be compatable with vi
set nocompatible
" Show where we are in the file (line/char)
set ruler
" Show line numbers
set number
" And make them relative
set relativenumber
" Lets see what we're commanding
set showcmd
" Don't get too close to the top/bottom (within 5 lines)
set so=5
" Visual bell instead of beeps
set visualbell
" Open new splits below / to the right, instead of not that.
set splitbelow
set splitright
" Make splits equal always (except on resize, which isn't 'always' I guess); 
set equalalways
" Remember the buffers I had open.
:exec 'set viminfo=%,' . &viminfo
" Indent lines smartly when they wrap
set breakindent
" And tab any wrapped lines in by two tab's worth of spaces
set breakindentopt=shift:8
" Edit a copy of a file, and overwrite the original on save.
" Having this set to `auto` can mess with things that use
" filesystem watchers (like webpack)
set backupcopy=yes


" Coloring and syntax highlighting
"
" Set support for 256 colors
let &t_Co=256
" colorscheme time
colorscheme black_is_the_color
" Let the theme know we want a dark background
set background=dark
" Disable termguicolors because mosh can't understand them
set notermguicolors 


" Syntax
"
" Treat mustache files like html 
au BufNewFile,BufRead *.mustache set filetype=html
" And treat long files like the scum they are (i.e. don't color them)
au BufReadPost * if getfsize(bufname("%")) > 5*100*1024 | set syntax= | endif


" Indentation
"
" Tab is four columns. This changes how text is displayed.
set tabstop=4
" Reindenting and autoindenting moves things by 4 columns
set shiftwidth=4
" Hitting tab in insert mode inserts spaces
set expandtab
" 'softtabstop' i.e. make spaces feel like tabs (when deleting, etc). 
set sts=4
" shift + tab moves the line to the left
imap <S-Tab> <C-o><<
" stay in visual mode after reindenting forward
vnoremap < <gv
" ...or backward
vnoremap > >gv


" Mouse mode
"
" Enable mouse mode, if the terminal supports it. 
if has('mouse')
  set mouse=a
endif


" Wildmenu
"
" Enable the wildmenu (that menu at the bottom of the editor)
set wildmenu
" When you hit tab in the command line, autocomplete as far as possible on the
" first tab, and then show the wild menu with everything on the second tab.
set wildmode=list:longest,full
" Patterns to ignore in the wildmenu
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*,
" Ignore the case of a filename when autocompleting.
set wildignorecase


" Difftool
"
" Show vertical splits when diffing a file.
set diffopt+=vertical
" Ignore whitespace in a diff because that shit's annoying
set diffopt+=iwhite


" Folding
"
" Inform code folding based on the syntax
set foldmethod=syntax
" and don't fold anything by default (unless you somehow have a file with 99
" levels of indentation). 
set foldlevelstart=99


" Searching
"
" ignore case when searching
set ignorecase
" ...unless we search with an uppercase letter
set smartcase
" auto-open the quickfix menu on :Grep
autocmd QuickFixCmdPost *grep* cwindow


" Cursor line
"
" Highlight the current line in the current pane only.
" This makes it easier to tell which window is active
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  au WinLeave * setlocal nocursorline
augroup END
" Highlight column 90 in the active pane only.
" This makes it easier to tell which window is active
set colorcolumn=90
augroup BgHighlight
    autocmd!
    autocmd WinEnter * set colorcolumn=90
    autocmd WinLeave * set colorcolumn=0
augroup END



" Keyboard shortcuts
"
" Close current buffer with ctrl+c, and then drop the focus on
" the last file that you edited. It should leave panes alone.
nnoremap <C-c> :bp\|bd #<CR>
" In visual mode, // searches whatever you've selected
vnoremap // y/<C-R>"<CR>
" Select whatever you just pasted with gp
" see: http://vim.wikia.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Don't pause when leaving insert mode
" The pause happens because some commands may start with <esc>,
" but I don't want them.
if ! has('gui_running')
	set ttimeoutlen=10
	augroup FastEscape
		autocmd!
		au InsertEnter * set timeoutlen=0
		au InsertLeave * set timeoutlen=1000
	augroup END
endif


" ---------------------------------
"
" PLUGIN CONFIGS
"
" Things below here are specific to
" plugins, so it may or may not be 
" useful to you.
"
" ---------------------------------


" Ale settings
"
" use eslint to find lint errors
let g:ale_linters = {
\    'javascript': ['yarnpkg eslint']
\}
" run eslint --fix on save
let g:ale_fix_on_save = 1
" performance tweak; this means we have to restart vim if we install a new
" executable. See: https://github.com/w0rp/ale/issues/1176
let g:ale_cache_executable_check_failures = 1
" the path to our rulesets (etsy-specific)
let g:ale_php_phpcs_standard = '/home/shilal/development/Etsyweb/tests/standards/stable-ruleset.xml'
let g:ale_php_phpcbf_standard = '/home/shilal/development/Etsyweb/tests/standards/stable-ruleset.xml'
" disable linting on minified JS
let g:ale_pattern_options = {
\     '\.min\.js$': { 'ale_linters': [], 'ale_fixers': [] }
\}
" Make ctrl-j and ctrl-k go to the next and previous lint errors, respectively
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)


" Airline settings
"
" Show buffers like tabs, kinda
let g:airline#extensions#tabline#enabled = 1
" Enable powerline fonts (because you have them, right?)
let g:airline_powerline_fonts = 1
" Make buffers / tabs be separated by straight lines
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = ' '
" Match airline theme to color scheme
let g:airline_theme='minimalist'


" NERDTree
"
" Shortcut to open nerdtree
nmap <leader>ne :NERDTree<cr>
" Shortcut to open nerdtree to current file
nmap <leader>nf :NERDTreeFind<cr>
" Quit nerdtree after opening a file
let NERDTreeQuitOnOpen=1


" FZF
"
" Make sure fzf is in the runtime path
set rtp+=~/.fzf
" This should be set in your .zshrc or .bashrc so it can be used by fzf
" outside of vim, but just in case:
let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git --ignore tmp/  -g ""'
" Use <leader><tab> to search all files in repo
nmap <leader><tab> :FZF<cr>
" and lets override ctrl+p in case I forget
nmap <C-p> :FZF<cr>
" this function lists buffers for fzf
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction
" this function opens a buffer for fzf
function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction
" use <leader>` to search active buffers
nnoremap <silent> <Leader>` :call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'options': '+m',
\   'down':    len(<sid>buflist()) + 2
\ })<CR>


" vim-javascript
"
" enable highlighting for jsdoc
let g:javascript_plugin_jsdoc = 1
