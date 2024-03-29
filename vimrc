let mapleader="\<space>"
set nocompatible   " Enable modern Vim features not compatible with Vi spec

"""""" START OF PLUG CONFIGURATION """"""""""""""""""""""""
" Loads vim-plug.
if empty(glob("~/.vim/autoload/plug.vim"))
  execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" :PlugInstall, :PlugClean
call plug#begin()
Plug 'christoomey/vim-tmux-navigator'  " <ctrl-hjkl> for splits and panes
Plug 'derekwyatt/vim-scala'            " Scala syntax
Plug 'dyng/ctrlsf.vim'                 " Wrapper around Ack
Plug 'elubow/cql-vim'                  " CQL syntax
Plug 'elzr/vim-json'                   " JSON synax
Plug 'epeli/slimux'                    " Sends lines to tmux panes
Plug 'farmergreg/vim-lastplace'        " Restores last cursor position
Plug 'fatih/vim-go'                    " Golang
Plug 'flazz/vim-colorschemes'          " Additional colorschemes
Plug 'JCLiang/vim-cscope-utils'        " Reloads ctags/cscope using <leader>ca
Plug 'junegunn/fzf.vim'                " Integration with fzf.
Plug 'lervag/vimtex'                   " Latex, <leader>l mappings
Plug 'majutsushi/tagbar'               " Tags for code summary
Plug 'mhinz/vim-signify'               " Diff signs.
Plug 'motus/pig.vim'                   " Pig syntax
Plug 'NLKNguyen/papercolor-theme'      " PaperColor colorscheme
Plug 'nvie/vim-flake8'                 " Static checker for python
Plug 'prabirshrestha/async.vim'        " Normalize async jobs
Plug 'prabirshrestha/vim-lsp'          " Language server protocl
Plug 'tpope/vim-fugitive'              " Github
Plug 'vim-airline/vim-airline'         " Status line
Plug 'vim-airline/vim-airline-themes'  " Status line theme
Plug 'vim-scripts/indentpython.vim'    " Auto-indent for python
Plug 'vim-scripts/LargeFile'           " Disables features for large files
Plug 'vim-scripts/vim-gradle'          " Gradle syntax
call plug#end()
"""""" END OF PLUG CONFIGURATION """""""""""""""
filetype plugin indent on
syntax on

" Background
set bg=light
set t_Co=256
colorscheme PaperColor
if &term =~ '256color'
  " Disable Background Color Erase (BCE) so that color schemes
  " work properly when Vim is used inside tmux and GNU screen.
  set t_ut=
endif

set encoding=utf-8        " YouCompleteMe requires utf-8.

set ts=2
set sw=2
set expandtab
set autoindent
augroup style
  au FileType make setlocal noexpandtab
  au FileType go setlocal noexpandtab ts=2 sw=2
  au FileType py setlocal sts=2 ff=unix
  au FileType text setlocal syntax=conf
augroup END

" Highlight long lines.
augroup highlight_max_length
  au FileType scala call matchadd('ColorColumn', '\%120v', 120)
  au FileType cpp,h call matchadd('ColorColumn', '\%80v', 80)
  au FileType python call matchadd('ColorColumn', '\%80v', 80)
augroup END

" Searching
set ignorecase
set smartcase
set incsearch
set hlsearch

" Display
set number
set ruler
set textwidth=80

" Enable copying
set mouse+=a
if &term =~ '^screen'
    " tmux knows the extended mouse mode
    set ttymouse=xterm2
endif

" Sets backspace functionalty.
set backspace=indent,eol,start

" Sync file if modified outside of vim.
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

"""""""" START OF CUSTOM SHORTCUTS """"""""""""""""""""""
" Shortcuts for copy and paste to system clipboard.
vmap <leader>y "+y
vmap <leader>d "+d
nmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>p "+p
vmap <leader>P "+P

" Adds new file in the same directory as current file.
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Window diff
nnoremap <leader>d :windo diffthis<CR>
nnoremap <leader>dw :set diffopt+=iwhite<CR>
nnoremap <leader>du :diffupdate<CR>

" Allows code navigation when { appears at the end of a line.
nnoremap ]] :call search("^\\(\\w.*\\)\\?{")<CR>
nnoremap [[ :call search("^\\(\\w.*\\)\\?{", "b")<CR>
nnoremap ][ :call search("^}")<CR>
nnoremap [] :call search("^}", "b")<CR>

" Cscope binding.
au FileType cpp,h map <buffer> ,gs :cs find s <C-R>=expand("<cword>")<CR><CR>
" Finds all calls to text under cursor.
au FileType cpp,h map <buffer> ,gc :cs find c <C-R>=expand("<cword>")<CR><CR>
" Finds global definition of text under cursor.
au FileType cpp,h map <buffer> ,gg :cs find g <C-R>=expand("<cword>")<CR><CR>
"""""""" END OF CUSTOM SHORTCUTS """"""""""""""""""""""

"""""""" START OF FUNCTIONS  """""""""""""""""""""""""
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

" Highlights all instances of word under cursor, when idle.
" Type z/ to toggle highlighting on/off.
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=500
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>

" Trims trailing whitespace.
function! TrimWhitespace()
  let l:save_cursor = getpos('.')
  %s/\s\+$//e
  call setpos('.', l:save_cursor)
endfunction

command! TrimWhitespace call TrimWhitespace()
:noremap <Leader>ws :call TrimWhitespace()<CR>

"""""""" START OF PLUGIN SETTINGS """""""""""""""""
" YCM setting.
let g:ycm_autoclose_preview_window_after_completion=1

" Uses ripgrep if available.
if executable('rg')
  " Use rg over grep.
  set grepprg=rg\ --vimgrep\ --no-heading\ smart-case
endif

" FZF.
set rtp+=~/.fzf
if !empty(glob("WORKSPACE"))
  let $FZF_DEFAULT_COMMAND = join(map(copy(g:g3_directories),
        \ '''rg '' . v:val . '' --files'''), ' ; ')
else
  let $FZF_DEFAULT_COMMAND='rg --files'
endif
let $FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
nnoremap <leader>f :Files <CR>
nnoremap <leader>fb :Buffers <CR>
nnoremap <leader>b :Buffers <CR>

" CtrlSF.
nmap <leader>s <Plug>CtrlSFPrompt -R 
nmap <leader>sw <Plug>CtrlSFCwordPath<CR>
nnoremap <leader>ss :CtrlSFToggle<CR>
let g:ctrlsf_indent=2
let g:ctrlsf_ignore_dir = ['blaze-bin', 'blaze-genfiles', 'blaze-google3',
                           \'blaze-out', 'blaze-testlogs']

" Slimux shortcuts.
nnoremap <leader>t :SlimuxREPLSendLine<CR>
vnoremap <leader>t :SlimuxREPLSendSelection<CR>

" Enables airline all the time.
set laststatus=2
let g:airline_theme='papercolor'

" Git gutter shortcuts.
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>

" Eclim.
let g:EclimFileTypeValidate = 0
let g:EclimCompletionMethod = 'omnifunc'
let g:EclimMavenPomClasspathUpdate = 0

au FileType scala nnoremap <buffer> <Leader>fd :ScalaSearch<CR>
au FileType scala nnoremap <buffer> <Leader>fi :ScalaImport<CR>
au FileType scala nnoremap <buffer> <Leader>fv :Validate<CR>

" vim-go.
let g:go_list_autoclose = 0
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1

" Tagbar.
nmap <F8> :TagbarToggle<CR>
let g:tagbar_left=1

" Configures Lsp.
au User lsp_setup call lsp#register_server({
      \ 'name': 'Kythe Language Server',
      \ 'cmd': {server_info->['/google/bin/releases/grok/tools/kythe_languageserver', '--google3']},
      \ 'whitelist': ['python', 'go', 'cpp', 'proto'],
      \})

au FileType cpp,go,proto,python nnoremap <buffer> gd :<C-u>LspDefinition<CR>
au FileType cpp,go,proto,python nnoremap <buffer> gr :<C-u>LspReferences<CR>
""""""""" END OF PLUGIN SETTINGS """"""""""""""""""""""""""""
