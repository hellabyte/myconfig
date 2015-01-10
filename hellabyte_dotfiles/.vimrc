" .vimrc
" 2014 - 09 - 26  
" ---------------------------------------------------------------------
" Note that all options can be defined and researched by using builtin 
"   docs.
"       :help <setting>
" will bring up the settings help text.
" ---------------------------------------------------------------------
" Some of the commands and settings on this page were adapted from this 
"   site
"       http://items.sjbach.com/319/configuring-vim-right
" Others were found on stackoverflow and various blogs.
" EMACS keybinding section was all me though.
" ---------------------------------------------------------------------
" AUTHOR: Nathaniel Hellabyte
" SOURCE: https://github.com/hellabyte/myconfig
" =====================================================================

" Turns off vi-compatability
set nocompatible
" 
" Changes mapleader from default of / 
" mapleader is useful for setting custom modified commands.
let mapleader=" "

" Sets automatic carriage return at column number <textwidth>. 
"   0/78 off/defl. 
set textwidth=72
set formatoptions=c,q,r,t    " c    auto-wrap comments w/ text-width
" q    Allow formatting of comments with <gq>
" r    Auto insert current comment leader after
"      <enter>
" t    Auto wrapping of non-comment text

" Color 72nd and 80+ columns a different color to indicate width limit.
" Comment out these lines if the columns are unsettling.
if exists('+colorcolumn')
  execute "set colorcolumn=72," . join(range(80,300),",")
endif
" Allows ViM to manage multiple buffers 
"   ( independent buffers and marks )
set hidden 

" Shows info on current command in status line
set showcmd 

" Swap mark goto commands s.t. ' := goto exact mark & ` 
"   := goto line of mark
nnoremap ' `
nnoremap ` '

" Self-evident, but default is 20.
set history=1000

" Allows for more robust behavior of <%> matching.
" NOTE -- runtime vs. source -- runtime is relative to vim directory; 
"   while source needs an absolute path.
runtime macros/matchit.vim

" Shows list for <tab> complete in : (command) mode
set wildmenu
" Shows all of the options in wild menu.
set wildmode=list:longest

" Makes quick search case insensitive if and only if Capital unused.
set ignorecase
set smartcase

" Sets title of terminal to /path/file - vim
set title

" Sets context minimum around the cursor.
set scrolloff=0

" Sets central temp file location, to prevent local default behavior.
if isdirectory($HOME . '/.vim/.tmp') == 0
  :silent !mkdir  -p ~/.vim/.tmp > /dev/null 2>&1
  :silent !chmod 700 ~/.vim/.tmp > /dev/null 2>&1
endif

set backupdir=~/.vim/.tmp ",~/.local/tmp/vim,/var/tmp,/tmp,
set directory=~/.vim/.tmp ",~/.local/tmp/vim,/var/tmp,/tmp,

if exists("+viminfo")
  " viminfo -- Saves Vim state information such as marks, command line
  "            history, search string history, buffers, global vars, 
  "            registers, search/sub patterns, and input-line history.
  "            :help viminfo
  "            Allegedly default permissions are sufficient for privacy.
  "
  if isdirectory( $HOME . '/.vim/.state') == 0
    :silent !mkdir  -p ~/.vim/.state > /dev/null 2>&1
    :silent !chmod 700 ~/.vim/.state > /dev/null 2>&1
  endif
  set viminfo+=n~/.vim/.state/viminfo
endif

if exists("+undofile")
  " undofile -- This allows you to use undos after exiting and 
  "             restarting. This, like swaps and backups, uses
  "             .vim-undo first, then ~/.vim/undo.
  "             :help undo-persistence
  "             NOTE: only present in 7.3+
  if isdirectory( $HOME . '/.vim/.undo' ) == 0
    :silent !mkdir  -p ~/.vim/.undo > /dev/null 2>&1
    :silent !chmod 700 ~/.vim/.undo > /dev/null 2>&1
  endif
  set undodir=~/.vim/.undo
  set undofile
endif

if isdirectory( $HOME . '/.vim/doc' ) == 1
  set runtimepath+=$HOME/.vim/doc
  helptags $HOME/.vim/doc
endif

" For code folding: saves code folding for next session
"   Also saves the view, and thus the place of the cursor.
"   ISSUE : doesn't necessarily update with the .vimrc, requires 
"           cleaning.
if isdirectory( $HOME . '/.vim/.state/view') == 0
  :silent !mkdir  -p ~/.vim/.state/view > /dev/null 2>&1
  :silent !chmod 700 ~/.vim/.state/view > /dev/null 2>&1
endif
set viewdir=~/.vim/.state/view
autocmd BufWrite * mkview
autocmd BufRead  * silent loadview

" Line Numbers, nu = number
set nu 

set backspace=indent,eol,start

if has("mouse")
  set mouse=a
  set mousehide
endif

if has("eval")
  let is_bash=1
endif

" Recognizes and Colors syntax 
syntax on
" Recognize syntax based on file extension.
filetype on
filetype plugin on
filetype indent on

" Has filetype associated with various syntax files
if has("autocmd")
  au BufEnter * let &titlestring=expand("%:p")
  au BufRead,BufNewFile *.rkt setfiletype scheme
  au BufRead,BufNewFile *.CR2 setfiletype txt
  au BufRead,BufNewFile *.inc setfiletype fortran
  au BufRead,BufNewFile *.fh  setfiletype fortran
  au Filetype pov set syntax=fortran
  au Filetype gplot,gp set syntax=gnuplot
endif

" TODO: Add cpreproc filetype to c, cpp, f, f90 filetypes with .
"       to improve snippet handling of preprocessing syntax
let s:extfname = expand("%:e")
if s:extfname ==? "f" 
  let fortran_fixed_source=1
  unlet! fortran_free_source
else
  let fortran_free_source=1
  let fortran_have_tabs=1
  let fortran_more_precise=1
  unlet! fortran_fixed_source
endif

" TeX indentexpr function, GetTexIndent() drives me crazy
if s:extfname ==? "tex" 
  filetype plugin indent off
endif

" Window Nav
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Speed up paging
nnoremap <C-e> 5<C-e>
nnoremap <C-y> 5<C-y>

" EMACS keybindings for insert mode
inoremap §     <C-[>
inoremap <C-f> <Right>
inoremap <C-b> <Left>
inoremap <C-n> <C-o>gj
inoremap <C-p> <C-o>gk
inoremap <C-l> <C-p>
inoremap <C-z> <C-n>
inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0
inoremap <C-k> <C-o>D
inoremap <C-q> <C-k>
inoremap <C-u> <C-o>d0
inoremap <C-y> <C-r>
inoremap <C-r> <C-o>F
inoremap <C-d> <delete>
inoremap <C-t> <C-o>x<C-o>p
inoremap <C-s> <C-o>f
inoremap <Return> <C-j>
" EMACS keybindings for command line mode 
cnoremap <C-x> <C-f>
cnoremap <C-f> <right>
cnoremap <C-b> <left>
cnoremap <C-a> <Home>
cnoremap <C-d> <delete>
cnoremap <C-p> <up>
cnoremap <C-n> <down>
cnoremap <C-q> <C-k>
cnoremap <C-k> <C-e><C-u>

" Perform macro for common python calculation
nmap <silent> <leader>q :r!python -c 'print <C-r><C-w> 
nmap <leader>; :
nmap <leader>t :!
nmap <leader>a :!aspell -c %<C-j>
nmap <leader>l :!pdflatex %<C-j>
nmap <leader>z :!xelatex %<C-j>
nmap <leader>p :!python %<C-j>
nmap <leader>o :!open
nmap <leader>f :!open .<C-j>
nmap <leader>w :w<C-j>
nmap <leader>q :q
nmap <leader>x :x
nmap <leader>c :!pwd |
nmap <leader>k :<C-p>
"nmap <leader>c :

" Remap old sourcing
nmap <silent> <leader>r :source ~/.vimrc<C-j>

" Group Closing
inoremap (  ()<Left>
inoremap {  {}<Left>
inoremap [  []<Left>
inoremap <  <><Left>
inoremap '  ''<Left>
inoremap "  ""<Left>
inoremap `  `'<Left>
inoremap `` ``"<Left>

"inoremap {<space> { 
"inoremap [<space> [ 
"inoremap <<space> < 
"inoremap '<space> ' 
"inoremap "<space> " 
"inoremap <expr> )  strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"

" Copy path to clipboard
" nmap <silent> <leader>p :!pwd | pbcopy
" nmap <silent> <leader>p :!pwd | xclip
" Show matches with highlight. Turn off highlight with :noh
set hlsearch
" Highlight matches as search is being typed.
set incsearch
" <mapleader>n :silent :nohlsearch<CR> all turn off highlight like :noh
nmap <silent> <leader>h :silent :nohlsearch<CR>

" Shows tabs and trailing spaces
set listchars=tab:>-,trail:_,eol:$
nmap <silent> <leader>s :set nolist!<CR>

set showmatch
set matchtime=0

set printoptions=paper:letter

set tags=tags;~/

set timeoutlen=200

" Preserves whitespace indentations on newline. On by default
set autoindent
" Inserts specified spaces with <>> <<> commands when autoindent is on. 
"   If on, C-v <Tab> inserts actual tab.
set expandtab
" Inserts shiftwidth spaces for <tab>. If off, <tab> inserts 
"   tabstop spaces.
set smartindent           " Indents instead of tabs
set tabstop=2             " Size of hard tabstop
set shiftwidth=2          " Size of indent
set expandtab             " Spaces instead of tabs
set softtabstop=2         " combination of previous two

autocmd BufEnter *.py set ai sw=2 ts=2 sta et fo=croql

" Allows .tex files to be recognized as tex and not awful plaintex
let g:tex_flavor="latex"

"setlocal spell spelllang=en_us
if $TERM == "dumb"
  colorscheme default
else
  set t_Co=256
  colo lichen
endif

" Adds custom general highlighting to comment keywords
function! HighlightKeywords()
  let v=&ft."Comment"
  exe 'syn keyword myTodo containedin='. v '
     \ TODO XXX BUG NOTE FIXME ADD ISSUE QUEST QUESTION ASK FIX 
     \ GARBAGE TRASH BAD OKAY CITE REF DISCUSS DISC TALK MORE 
     \ LESS CLEAN MARK HERE CHECK CITE EQUATION'
  hi def link myTodo Todo
endfunction

autocmd Syntax * call HighlightKeywords()

" Allows for system clipboard pasted text to not be butchered by
" builtin autoindent.
set pastetoggle=<F2>

" DEPRECATED
" For using vim as a manpager:
"$PAGER=''

" More natural for traversing lines that span more than one vertical space.
" map j gj
" map k gk
"
" Shows info about line, column and positional info in bottom right corner.
" set ruler
