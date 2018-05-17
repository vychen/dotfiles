let mapleader="\<space>"

" Loads vim-plug.
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" ------ start of Plug configuration -------------
" :PlugInstall
call plug#begin()
Plug 'airblade/vim-gitgutter'          " Git diff
Plug 'christoomey/vim-tmux-navigator'  " <ctrl-hjkl> for splits and panes
Plug 'ctrlpvim/ctrlp.vim'              " Current fork of ctrlp
Plug 'derekwyatt/vim-scala'            " Scala syntax
Plug 'dyng/ctrlsf.vim'                 " Wrapper around Ack
Plug 'elubow/cql-vim'                  " CQL syntax.
Plug 'epeli/slimux'                    " Sends lines to tmux panes.
Plug 'farmergreg/vim-lastplace'        " Restores last cursor position.
Plug 'fatih/vim-go'                    " Golang.
Plug 'flazz/vim-colorschemes'          " Additional colorschemes.
Plug 'JCLiang/vim-cscope-utils'        " Reloads ctags/cscope using <leader>ca
Plug 'mileszs/ack.vim'                 " Light wrapper around Ack
Plug 'nvie/vim-flake8'                 " Static checker for python.
Plug 'scrooloose/syntastic'            " Syntax highlighting
Plug 'tpope/vim-fugitive'              " Github
Plug 'Valloric/YouCompleteMe'          " Completion engine
Plug 'vim-airline/vim-airline'         " Status line
Plug 'vim-scripts/indentpython.vim'    " Auto-indent for python.
call plug#end()
"""""" END OF PLUG CONFIGURATION """""""""""""""

" Background
set bg=light
set t_Co=256
colorscheme PaperColor

" YouCompleteMe requires utf-8.
set encoding=utf-8

" Tabs
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk"
  set noexpandtab
else  " for non-makefile files
  set ts=2
  set sw=2
  set expandtab
  set ai
  set nocompatible
endif

" Searching
set ignorecase
set smartcase
set incsearch
set hlsearch

" Display
set number
set ruler
set textwidth=100
syntax on

" Enable copying
set mouse+=a
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

" Sets backspace functionalty.
set backspace=indent,eol,start

" Sync between intellij.
set autoread
au CursorHold * checktime

" Dictates where split windows appear.
set splitright
set splitbelow

" Specifies dir for swp files; double slash to avoid name collision.
if empty(glob("~/.vim/backup/"))
  execute '!mkdir ~/.vim/backup'
endif
if empty(glob("~/.vim/swap/"))
  execute '!mkdir ~/.vim/swap'
endif
if empty(glob("~/.vim/undo/"))
  execute '!mkdir ~/.vim/undo'
endif
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//

" Assumes tags generated in the current dir, from "ctags -R --exclude='.git'"
" Searches for tags in the project root dir.
set tags=./tags,tags;$HOME

" Folding
set foldmethod=syntax
set foldnestmax=10
set nofoldenable
set foldlevel=2

" ------- More functionality ------------------------------------
" Shortcuts for copy and paste to system clipboard.
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P

" Adds new file in the same directory as current file.
map <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Window diff
map <leader>d :windo diffthis<CR>
map <leader>dw :set diffopt+=iwhite<CR>
map <leader>du :diffupdate<CR>

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pylint','python']
let g:syntastic_scala_checkers = ['scalac','scalastyle']
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_go_checkers = ['gofmt']
" let g:syntastic_java_checkers=['javac']
let g:syntastic_java_javac_config_file_enabled = 1

" Flake8 settings.
let g:flake8_show_quickfix=1  " don't show

" YCM setting.
let g:ycm_autoclose_preview_window_after_completion=1

" Sets up diff with a wider screen.
function DiffSetup()
  " set nofoldenable foldcolumn=0 number
  set foldcolumn=0 number
  wincmd b
  set foldcolumn=0 number
  let &columns = &columns * 2
  wincmd =
  winpos 0 0
endfunction
if &diff
  autocmd VimEnter * call DiffSetup()
endif

" CtrlP setting.
let g:ctrlp_map = '<leader>g'
" let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
nnoremap <leader>gb :CtrlPBuffer <CR>
nnoremap <leader>go :CtrlPBuffer <CR>
nnoremap <leader>gu :CtrlPMRU <CR>
let g:ctrlp_buffer = '<leader>b'
" Ignore these files or directories.
" set wildignore+=*/bin/*,*.class,*.pyc,*/\.git/*
" disable caching
let g:ctrlp_use_caching=0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_regexp=1
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|bin|lib|docs|vendor)$',
  \ 'file': '\v\.(class|pyc|parquet)$',
  \ }

" CtrlSFPrompt
nmap <leader>s <Plug>CtrlSFPrompt -R -I 
nmap <leader>sw <Plug>CtrlSFCwordPath<CR>
nnoremap <leader>ss :CtrlSFToggle<CR>

" Slimux shortcuts.
map <leader>t :SlimuxREPLSendLine<CR>
vmap <leader>t :SlimuxREPLSendSelection<CR>

" Enables airline all the time.
set laststatus=2

" Git gutter shortcuts.
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>

" Syntastic shortcuts.
nnoremap <leader>st :SyntasticToggleMode<CR>

" Trims trailing whitespace.
fun! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun

command! TrimWhitespace call TrimWhitespace()
:noremap <Leader>ws :call TrimWhitespace()<CR>

" Protect large files from sourcing and other overhead.
" Files become read only
if !exists("my_auto_commands_loaded")
  let my_auto_commands_loaded = 1
  " Large files are > 1M
  " Set options:
  " eventignore+=FileType (no syntax highlighting etc
  " assumes FileType always on)
  " noswapfile (save copy of file)
  " bufhidden=unload (save memory when other file is viewed)
  " buftype=nowrite (file is read-only)
  " undolevels=-1 (no undo possible)
  let g:LargeFile = 1024 * 1024 * 1
  augroup LargeFile
    au BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
  augroup END
endif

if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

" Eclim
let g:EclimFileTypeValidate = 0
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimMavenPomClasspathUpdate = 0

" vim-go
let g:go_list_autoclose = 0
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" Syntax highlighting.
augroup filetypedetect
  au BufNewFile,BufRead *.json set ft=javascript
  au BufNewFile,BufRead *.gradle set ft=groovy
  " requires pig.vim in ~/.vim/syntax/
  au BufNewFile,BufRead *.pig set ft=pig syntax=pig
augroup END

" LaTeX macros for compiling and viewing.
augroup latex_macros
  au!
  au FileType tex :nnoremap <leader>l :w<CR>:!rubber --pdf --warn all %<CR>
  au FileType tex :nnoremap <leader>v :!mupdf %:r.pdf &<CR><CR>
augroup END

augroup scala
  au FileType scala call matchadd('ColorColumn', '\%120v', 120)
  au FileType scala map <buffer> <Leader>fd :ScalaSearch<CR>
  au FileType scala map <buffer> <Leader>fi :ScalaImport<CR>
  au FileType scala map <buffer> <Leader>fv :Validate<CR>
augroup END

augroup cpp
  au FileType cpp call matchadd('ColorColumn', '\%80v', 80)
  au FileType cpp map <buffer> <Leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
  " Finds all calls to text under cursor.
  au FileType cpp map <buffer> <Leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
  " Finds global definition of text under cursor.
  au FileType cpp map <buffer> <Leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
augroup END

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix |

augroup python
    au FileType python map <buffer> <Leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR> |
    " Finds all calls to text under cursor.
    au FileType python map <buffer> <Leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR> |
    " Finds global definition of text under cursor.
    au FileType python map <buffer> <Leader>fg :cs find g <C-R>=expand("<cword>")<CR><CR>
augroup END

augroup xml
  au FileType xml set ts=4
  au FileType xml set sw=4
augroup END

augroup txt
  au FileType text set syntax=conf
augroup END

augroup go
  au FileType go map <buffer> ,gd :GoDef <C-R>=expand("<cword>")<CR><CR>
  au FileType go map <buffer> ,ga :GoAlternate<CR>
augroup END
