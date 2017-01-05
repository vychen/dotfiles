" ------ start of Vundle configuration -------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Installs these plugins.
Plugin 'desert-warm-256'                 " Dark background
Plugin 'scrooloose/syntastic'            " Syntax highlighting
Plugin 'derekwyatt/vim-scala'            " Scala syntax
Plugin 'tpope/vim-fugitive'              " Github
Plugin 'airblade/vim-gitgutter'          " Git diff
Plugin 'ctrlpvim/ctrlp.vim'              " Current fork of ctrlp
Plugin 'mileszs/ack.vim'                 " Light wrapper around Ack
Plugin 'dyng/ctrlsf.vim'                 " Wrapper around Ack
Plugin 'christoomey/vim-tmux-navigator'  " <ctrl-hjkl> for splits and panes
Plugin 'epeli/slimux'                    " Sends lines to tmux panes.
Plugin 'Valloric/YouCompleteMe'          " Mostly for C/C++
Plugin 'vim-airline/vim-airline'         " Status line

call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" ------- end of Vundle configuration -------------

" Background
set bg=dark
set t_Co=256
colorscheme desert-warm-256

" Tabs
let _curfile = expand("%:t")
if _curfile =~ "Makefile" || _curfile =~ "makefile" || _curfile =~ ".*\.mk"
  set noexpandtab
else  " for non-makefile files
  if _curfile =~ "py"
    set ts=4
    set sw=4
  else
    set ts=2
    set sw=2
  endif
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
set textwidth=120
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
let g:syntastic_python_checkers = ['pep8','python']
let g:syntastic_scala_checkers = ['scalac','scalastyle']
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
let g:ctrlp_map = '<leader>f'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
nnoremap <leader>fo :CtrlPBuffer <CR>
nnoremap <leader>fu :CtrlPMRU <CR>
let g:ctrlp_buffer = '<leader>b'
" Ignore these directories
set wildignore+=*/build/**
" disable caching
let g:ctrlp_use_caching=0
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_regexp=1

" CtrlSFPrompt
nmap <leader>s <Plug>CtrlSFPrompt -R -I 
nmap <leader>sw <Plug>CtrlSFCwordPath<CR>
nnoremap <leader>ss :CtrlSFToggle<CR>

" Slimux shortcuts.
map <leader>t :SlimuxREPLSendLine<CR>
vmap <leader>t :SlimuxREPLSendSelection<CR>

" Highlight characters beyong 120 columns.
highlight ColorColumn ctermbg=magenta guibg=Magenta
call matchadd('ColorColumn', '\%120v', 100)

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
