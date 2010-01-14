" Diwaker's Vim Settings

let mapleader=","

" source some files from the runtime
runtime vimrc_example.vim
runtime ftplugin/man.vim

" file encodings
set encoding=utf-8
set fileencoding=utf-8

" show the current mode (usually already set by system config files)
set showmode

" ignore case
set ignorecase
" turn off ignore case if search string contains upper case letters
set smartcase

" set command height to 2
set cmdheight=2

" undo levels
set undolevels=10000

" set hidden
set hidden

" write the contents of the file on every change
set autowriteall

" directory for swap files
set directory=~/.autosaves,/tmp

" set runtime path (needed on fedora systems)
set runtimepath+=/usr/share/vim/addons

" set the default shell
set shell=/bin/bash

" stop annoying bell, use visual bell instead
set visualbell

" show partial commands in status line
set showcmd

" Allow backspacing over everything in insert mode.
set backspace=eol,start,indent

" set autoindent: copy indent from current line. 
set autoindent

" Do smart auto indenting
set smartindent 

" Set textwidth to 80
set textwidth=80

" set coptions

" >s: Normal indent is 1xshiftwidth
" e0: End-of-line braces don't introduce extra indent
" n0: blocks without braces are no different than blocks with braces
" f0: opening brace on new line goes in the first column
" {0: opening braces inside other braces have regular indent
" }0: closing braces are in the same column as the maching opening brace
" ^0: prevailing indent inside braces is standard indent
" :s: case labels are indented by shiftwidth
" =s: statements occuring after a case label are indented by shiftwidth
" l1: align with the case label, not the contained statements
" b0: align the break like regular statements inside a case
" g1: indent C++ scope decalarations by 1 space
" h0.5s: statements after scope are indented by half shiftwidth (rounded up)
" ps: K&R style param declarations are indented by shiftwidth
" t0: return types are not indented
" i2s: base class decaralation is indented by 2xshiftwidth if on new line
" +s: continuation lines have shiftwidth extra indent
" cs: indent comment lines by shiftwidth if there is nothing else to align with
" C0: no additional indent for comment lines
" /0: no additional indent for comment lines
" (0: line up with first white space char after unclosed brace
" u0: same as above, one level deeper
" U1: do not ignore indenting introduced by opening brace
" w0: clean indenting for closing brace
" Ws: do the right thing when arguments start on new line after brace
" m0: line up closing brace correctly
" M0: line up closing brace correctly
" j1: indent anonymous classes in Java correctly
" )40: search 40 lines for unclosed parenthesis
" *40: search 40 lines for unclosed comments
" #1: recogize # comments
set cinoptions=>s,e0,n0,f0,{0,}0,^0,:s,=s,l1,b0,g1,h0.5s,ps,t0,i2s,+s,cs
set cinoptions+=C0,/0,(0,u0,U1,w0,Ws,m0,M0,j1,)40,*40,#1

" Ditto here
set indentkeys+=*<CR>

" sigh
set cinkeys+=*<CR>

" wrap on
set wrap
set wrapmargin=10
set linebreak
set sidescroll=5
set listchars+=precedes:<,extends:>

" Keep 100 lines of command line history.
set history=100

" Do incremental searching.
set incsearch

" Turn off search highlighting
set nohls

" This is our status line
" Buffername, Filename, Mode, Type, Tag, Line, Col, Position
set statusline=[%02n]\ %t\ %(\[%M%R%H]%y%)%=\ [%{Tlist_Get_Tagname_By_Line()}]\ %4l,%02c%2V\ %L,%P%*

" Always display a status line at the bottom of window.
set laststatus=2

" showmatch: Show the matching bracket for the last ')'?
set showmatch

" set folding by syntax by default
set foldmethod=syntax
set foldnestmax=2
set nofoldenable

" set backup dir
set backupdir=~/.backups,/tmp
set nowritebackup
set backup

" right click gives a popup
set mousemodel=popup_setpos

" expand tabs to spaces
set expandtab

" number of spaces for each step of autoindent
set shiftwidth=2

" a tab equals how many spaces?
set tabstop=2

" number of spaces a tab counts for while editing. this differs from 
" tabstop above in the sense that when i press backspace, 4 spaces will
" go back for one tab
set softtabstop=2

" allow positioning cursor in 'empty spaces'
set virtualedit=block

" enable smart tabs
set smarttab

" allows moving to next/prev line with left/right
set whichwrap+=h,l,<,>,[,]

" syntax highlighting
syntax enable

" setup wild mode
set wildmode=list:longest

" dictionary support
" set dictionary+=/usr/share/dict/words
" set dictionary+=/usr/share/dict/american-english
set complete+=k,d

" maintain column when switching buffers etc
set nostartofline

" filetype stuff
filetype on
filetype indent on
filetype plugin on

" session options
set sessionoptions=buffers,curdir,help,resize,tabpages,winsize,folds

set viminfo+=!,%

" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Put these in an autocmd group, so that we can delete them easily.
    augroup vimrcEx
        au!
         " When editing a file, always jump to the last known cursor position.
         " Don't do it when the position is invalid or when inside an event
         " handler (happens when dropping a file on gvim).
         autocmd BufReadPost *
                     \ if line("'\"") > 0 && line("'\"") <= line("$") |
                     \   exe "normal g`\"" |
                     \ endif
    augroup END
    augroup spellgroup
        " reset the group
        au!
        au FileType help,taglist setlocal nospell
    augroup END
    augroup synGroup
       " highlight long lines
       au BufWinEnter * let w:m1=matchadd('ErrorMsg','\%>80v.\+', -1)
       " highlight trailing spaces
       " au BufWinEnter * let w:m2=matchadd('ErrorMsg','\s\+$', -1)
    augroup END
endif " has("autocmd")

let java_highlight_functions="style"

" Plugin related options
runtime plugins.vim

" Other keybindings
runtime keybindings.vim

" Abbreviations
runtime abbreviations.vim

set completeopt=menu,preview,longest

set cursorline
" set term colors to 256
set t_Co=256

" color scheme
set background=dark
colorscheme xoria256
