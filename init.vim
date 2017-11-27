" Load vim-plug
if empty(glob("~/.local/share/nvim/site/autoload/plug.vim"))
  execute '!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" :PlugInstall
call plug#begin()
Plug 'rainux/desert-warm-256'          " Dark background
Plug 'scrooloose/syntastic'            " Syntax highlighting
Plug 'derekwyatt/vim-scala'            " Scala syntax
Plug 'fatih/vim-go'                    " Golang.
Plug 'sebdah/vim-delve'                " Golang debugger.
Plug 'tpope/vim-fugitive'              " Github
Plug 'airblade/vim-gitgutter'          " Git diff
Plug 'ctrlpvim/ctrlp.vim'              " Current fork of ctrlp
Plug 'mileszs/ack.vim'                 " Light wrapper around Ack
Plug 'dyng/ctrlsf.vim'                 " Wrapper around Ack
Plug 'christoomey/vim-tmux-navigator'  " <ctrl-hjkl> for splits and panes
Plug 'epeli/slimux'                    " Sends lines to tmux panes.
Plug 'Valloric/YouCompleteMe'          " Mostly for C/C++
Plug 'vim-airline/vim-airline'         " Status line
Plug 'JCLiang/vim-cscope-utils'        " Reloads ctags/cscope using <leader>ca
Plug 'elubow/cql-vim'                  " CQL syntax.
Plug 'flazz/vim-colorschemes'          " Additional colorschemes.
call plug#end()

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
" set mouse=a
set mouse+=a
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif
" Set working directory to current file's.
" set autochdir  " disabled because conflict with CtrlP

" Sets backspace functionalty.
set backspace=indent,eol,start

" Sync between intellij.
set autoread
au CursorHold * checktime

" Dictates where split windows appear.
set splitright
set splitbelow

" Specifies dir for swp files; double slash to avoid name collision.
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
let mapleader="\<space>"

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

" Syntax highlighting for JSON to emulate Javascript.
autocmd BufNewFile,BufRead *.json set ft=javascript

" Recognizes gradle file as groovy syntax.
au BufNewFile,BufRead *.gradle setf groovy

" Syntax highlighting for PIG (requires pig.vim in ~/.vim/syntax/
augroup filetypedetect
  au BufNewFile,BufRead *.pig set filetype=pig syntax=pig
augroup END

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers = ['pep8','pylint','python']
let g:syntastic_scala_checkers = ['scalac','scalastyle']
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_go_checkers = ['gofmt']
" let g:syntastic_java_checkers=['javac']
let g:syntastic_java_javac_config_file_enabled = 1

" LaTeX macros for compiling and viewing.
augroup latex_macros " {
    autocmd!
    autocmd FileType tex :nnoremap <leader>l :w<CR>:!rubber --pdf --warn all %<CR>
    autocmd FileType tex :nnoremap <leader>v :!mupdf %:r.pdf &<CR><CR>
augroup END " }

" Restores cursor position to previous edit.
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction
augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

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
  \ 'dir':  '\v[\/](\.git|bin|lib|docs)$',
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
    autocmd BufReadPre * let f=expand("<afile>") | if getfsize(f) > g:LargeFile | set eventignore+=FileType | setlocal noswapfile bufhidden=unload buftype=nowrite undolevels=-1 | else | set eventignore-=FileType | endif
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

let g:delve_backend="native"

augroup scala
  au FileType scala call matchadd('ColorColumn', '\%120v', 120)
  au FileType scala map <buffer> <Leader>fd :ScalaSearch<CR>
  au FileType scala map <buffer> <Leader>fi :ScalaImport<CR>
  au FileType scala map <buffer> <Leader>fv :Validate<CR>
augroup END

augroup python
  au FileType python set ts=4
  au FileType python set sw=4
  au FileType python call matchadd('ColorColumn', '\%80v', 80)

  au FileType python map <buffer> <Leader>fs :cs find s <C-R>=expand("<cword>")<CR><CR>
  " Finds all calls to text under cursor.
  au FileType python map <buffer> <Leader>fc :cs find c <C-R>=expand("<cword>")<CR><CR>
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
