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
set textwidth=120
syntax on

" Enable copying
set mouse=a
" Set working directory to current file's.
" set autochdir  " disabled because conflict with CtrlP

" Sets backspace functionalty.
set backspace=indent,eol,start

" Sync between intellij.
set autoread

" Dictates where split windows appear.
set splitright
set splitbelow

" Assumes tags generated in the current dir, from "ctags -R --exclude='.git'"
" Searches for tags in the project root dir.
set tags=./tags

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
let g:syntastic_scala_checkers = ['pep8','pylint','python']
let g:syntastic_scala_checkers = ['scalac','scalastyle']
let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
map <leader>st :SyntasticToggleMode<CR>

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

" CtrlSFPrompt
nmap <leader>s <Plug>CtrlSFPrompt -R -I 
nmap <leader>sw <Plug>CtrlSFCwordPath<CR>

" Slimux shortcuts.
map <leader>t :SlimuxREPLSendLine<CR>
vmap <leader>t :SlimuxREPLSendSelection<CR>

" Highlight characters beyong 120 columns.
highlight ColorColumn ctermbg=magenta guibg=Magenta
call matchadd('ColorColumn', '\%120v', 100)

" Enables airline all the time.
set laststatus=2
