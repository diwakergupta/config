" cecscope.vim:
"  Author: Charles E. Campbell, Jr.
"  Date:   Nov 12, 2008
"  Version: 4
"  Usage:  :CS[!]  [cdefgist]
"          :CSL[!] [cdefgist]
"          :CSS[!] [cdefgist]
"          :CSH     (gives help)
"          :CSR
" =====================================================================
" Load Once: {{{1
if !has("cscope") || &cp || exists("g:loaded_cecscope")
 finish
endif
let g:loaded_cecscope= "v4"
if v:version < 702
 echohl WarningMsg
 echo "***warning*** this version of cecscope needs vim 7.2"
 echohl Normal
 finish
endif
"DechoTabOn

" =====================================================================
" Public Interface: {{{1
com!       -nargs=* CS  call s:Cscope(<bang>0,<f-args>) 
com!       -nargs=? CSH call s:CscopeHelp(<q-args>)
com! -bang -nargs=* CSL call s:Cscope(4+<bang>0,<f-args>) 
com! -bang -nargs=* CSS call s:Cscope(2+<bang>0,<f-args>) 
com!       -nargs=0 CSR call s:CscopeReset()

" =====================================================================
"  Options: {{{1
if !exists("g:cecscope_dboptions")
 let g:cecscope_dboptions=""
endif

" =====================================================================
"  Functions: {{{1

" ---------------------------------------------------------------------
" Cscope: {{{2
"   Usage: :CS[ls][!]  [sgctefid]
" !: use vertical split
"
" -----
" style
" -----
"  s    (symbol)   find all references to the token under cursor
"  g    (global)   find global definition(s) of the token under cursor
"  c    (calls)    find all calls to the function name under cursor
"  t    (text)     find all instances of the text under cursor
"  e    (egrep)    egrep search for the word under cursor
"  f    (file)     open the filename under cursor
"  i    (includes) find files that include the filename under cursor
"  d    (called)   find functions that function under cursor calls
fun! s:Cscope(mode,...)
"  call Dfunc("Cscope(mode=".a:mode.") a:0=".a:0." cscopetag=".&cscopetag)
  if a:0 >= 1
   let style= a:1
"   call Decho("style=".style)
  else
   let style= "c"
  endif

  if !&cscopetag
   " use cscope and ctags for ctrl-], :ta, etc
   " check cscope for symbol definitions before using ctags
   " csto=0: cscope database searched first, then the <tags> file
"   call Decho("setting cscopetag, cscopetagorder (csto), csqf")
   set cscopetag csto=0
   if has("quickfix")
	let s:csqfkeep = &csqf
"    set csqf=c-,d-,e-,g-,i-,s-,t-
    set csqf=""
   endif

   if !executable("cscope")
	if has("quickfix")
	 let &csqf = s:csqfkeep
	endif
    echohl Error | echoerr "can't execute cscope!" | echohl None
"    call Dret("Cscope : can't execute cscope")
    return
   endif

   " add/build cscope database
   call s:CscopeAdd()

   " show message whenver any cscope database added
   set cscopeverbose
  endif

  " decide if cs/scs and vertical/horizontal
  if a:mode == 0         " CS  :  Cscope(0,...)
   let mode= "cs"       
  elseif a:mode == 1     " CS! :  Cscope(1,...)
   let mode= "vert cs"  
  elseif a:mode == 2     " CSS :  Cscope(2,...)
   let mode= "scs"
  elseif a:mode == 3     " CSS!:  Cscope(3,...)
   let mode= "vert scs"
  elseif a:mode == 4     " CSL :  Cscope(4,...)
   let mode= "silent cs"
"   call Decho("redir! > cscope.qf")
   redir! > cscope.qf
  elseif a:mode == 5     " CSL!:  Cscope(5,...)
   " restore previous efm
   if exists("b:cscope_efm")
    let &efm= b:cscope_efm
    unlet b:cscope_efm
   endif
   if has("quickfix")
    let &csqf= s:csqfkeep
   endif
"   call Dret("Cscope")
   return
  else
   if has("quickfix")
    let &csqf= s:csqfkeep
   endif
   echohl Error | echoerr "(Cscope) mode=".a:mode." not supported" | echohl None
"   call Dret("Cscope")
   return
  endif

  if a:0 == 2
   let word= a:2
  elseif style =~ '[fi]'
   let word= expand("<cfile>")
  else
   let word= fnameescape(expand("<cword>"))
  endif
"  call Decho("a:mode=".a:mode." yields mode<".mode.">  word<".word.">  style=".style)

  if style == 'f'
"   call Decho("exe ".mode." find f ".fnameescape(word))
   exe mode." find f ".word
  elseif style == 'i'
"   call Decho("exe ".mode." find i ^".fnameescape(word)."$")
   exe mode." find i ^".fnameescape(word)."$"
  else
"   call Decho("exe ".mode." find ".style." ".fnameescape(word))
   try
   	redraw!
	exe mode." find ".style." ".fnameescape(word)
   catch /^Vim\%((\a\+)\)\=:E/
	echohl WarningMsg | echomsg "***warning**** unable to find <".fnameescape(word).">" | echohl None
   endtry
  endif

  if a:mode == 4	" CSL :  Cscope(4,...)
   redir END
"   call Decho("redir END")
   if !exists("b:cscope_efm")
"	call Decho("setting up efm")
    let b:cscope_efm= &efm
    setlocal efm=%C\ \ \ \ \ \ \ \ \ \ \ \ \ %m
    setlocal efm+=%I\ %#%\\d%\\+\ %#%l\ %#%f\ %m
    setlocal efm+=%-GChoice\ number\ %.%#
    setlocal efm+=%-G%.%#line\ \ filename\ /\ context\ /\ line
    setlocal efm+=%-G%.%#Cscope\ tag:\ %.%#
    setlocal efm+=%-G
   endif
"   call Decho("case a:mode=".a:mode.": lg cscope.qf")
   lg cscope.qf
   silent! lope 5
   if has("menu") && has("gui_running") && &go =~ 'm'
"	call Decho("set up menu: restore error format :CSL!")
    exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format'
    exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format	:CSL!'."<cr>"
   endif
  endif

  if has("quickfix")
   let &csqf= s:csqfkeep
  endif
  if has("folding")
   silent! norm! zMzxz.
  else
   norm! z.
  endif

"  call Dret("Cscope")
endfun

" ---------------------------------------------------------------------
" s:CscopeAdd: {{{2
fun! s:CscopeAdd()
"  call Dfunc("s:CscopeAdd()")
  let s:cscopedatabase="undefined"

  " specify cscope database in current directory
  " or use whatever the CSCOPE_DB environment variable says to
  if filereadable("cscope.out")
"   call Decho("adding <cscope.out>")
   let s:cscopedatabase= "cscope.out"
   cs add cscope.out
  elseif $CSCOPE_DB != "" && filereadable($CSCOPE_DB)
"   call Decho("adding $CSCOPE_DB<".expand("$CSCOPE_DB").">")
   let s:cscopedatabase= expand("$CSCOPE_DB")
   cs add $CSCOPE_DB
  else
   let cscopeout_list= findfile('cscope.out',getcwd().';'.expand("$HOME"),-1)
   for cscopeout in cscopeout_list
"	call Decho("cs add ".cscopeout)
	exe "cs add ".cscopeout
   endfor
   if empty(cscopeout_list) && executable("cscope")
"    call Decho("using cscope ".expand("%"))
    let s:cscopedatabase= expand("%")
    call system("cscope -b ".g:cecscope_dboptions." ".s:cscopedatabase)
    cs add cscope.out
    if !filereadable("cscope.out")
     echohl WarningMsg | echoerr "(Cscope) can't find cscope database" | echohl None
    endif
   endif
  endif
"  call Dret("s:CscopeAdd : added <".s:cscopedatabase.">")
endfun

" ---------------------------------------------------------------------
" CscopeHelp: {{{2
fun! s:CscopeHelp(...)
"  call Dfunc("CscopeHelp() a:0=".a:0)
  if a:0 == 0 || a:1 == ""
   echo "CS     [cdefgist]   : cscope"
   echo "CSL[!] [cdefgist]   : locallist style (! restores efm)"
   echo "CSS[!] [cdefgist]   : split window and use cscope (!=vertical split)"
   echo "CSR                 : reset/rebuild cscope database"
   let styles="!cdefgist"
   while styles != ""
"   	call Decho("styles<".styles.">")
   	call s:CscopeHelp(strpart(styles,0,1))
	let styles= strpart(styles,1)
   endwhile
"   call Dret("CscopeHelp : all")
   return
  elseif a:1 == '!' | echo "!            split vertically"
  elseif a:1 == 'c' | echo "c (calls)    find functions    calling  function under cursor"
  elseif a:1 == 'd' | echo "d (called)   find function(s) called by function under cursor"
  elseif a:1 == 'e' | echo "e (egrep)    egrep search for the word under cursor"
  elseif a:1 == 'f' | echo "f (file)     open the file named under cursor"
  elseif a:1 == 'g' | echo "g (global)   find global definition(s) of word under cursor"
  elseif a:1 == 'i' | echo "i (includes) find files that #include file named under cursor"
  elseif a:1 == 's' | echo "s (symbol)   find all references to the word under cursor"
  elseif a:1 == 't' | echo "t (text)     find all instances  of the word under cursor"
  else              | echo a:1." not supported"
  endif

"  call Dret("CscopeHelp : on <".a:1.">")
endfun

" ---------------------------------------------------------------------
" CscopeMenu: {{{2
fun! CscopeMenu(type)
"  call Dfunc("CscopeMenu(type=".a:type.")")
  if !exists("g:DrChipTopLvlMenu")
   let g:DrChipTopLvlMenu= "DrChip."
  endif
  if !exists("s:installed_menus")
   exe "menu ".g:DrChipTopLvlMenu."Cscope.Help	:CSH\<cr>"
  endif
  if exists("s:installed_menus")
"   silent! unmenu DrChipCscope
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display'
  endif
  if a:type == 1
   let cmd= "CS"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display	:call CscopeMenu(2)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display 	:call CscopeMenu(3)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display	:call CscopeMenu(4)'."<cr>"
  elseif a:type == 2
   let cmd= 'CSL'
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display	:call CscopeMenu(1)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display	:call CscopeMenu(3)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display	:call CscopeMenu(4)'."<cr>"
  elseif a:type == 3
   let cmd= 'CSS'
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display	:call CscopeMenu(1)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display	:call CscopeMenu(2)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Vert\ Split\ Display	:call CscopeMenu(4)'."<cr>"
  elseif a:type == 4
   let cmd= 'CSS!'
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Messages\ Display	:call CscopeMenu(1)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Quickfix\ Display	:call CscopeMenu(2)'."<cr>"
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Use\ Horiz\ Split\ Display	:call CscopeMenu(3)'."<cr>"
  endif

  if exists("s:installed_menus")
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ which\ call\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ called\ by\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Egrep\ search\ for\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Open\ file\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ globally\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ files\ that\ include\ word\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ references\ to\ symbol\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ instances\ of\ text\ under\ cursor'
   exe 'unmenu '.g:DrChipTopLvlMenu.'Cscope.Reset'
   exe 'silent! unmenu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format'
  endif

  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ which\ call\ word\ under\ cursor<tab>:'.cmd.'\ c	:'.cmd.'\ c'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ functions\ called\ by\ word\ under\ cursor<tab>:'.cmd.'\ d	:'.cmd.'\ d'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Egrep\ search\ for\ word\ under\ cursor<tab>:'.cmd.'\ e	:'.cmd.'\ e'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Open\ file\ under\ cursor<tab>:'.cmd.'\ f	:'.cmd.'\ f'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ globally\ word\ under\ cursor<tab>:'.cmd.'\ g	:'.cmd.'\ g'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ files\ that\ include\ word\ under\ cursor<tab>:'.cmd.'\ i	:'.cmd.'\ i'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ references\ to\ symbol\ under\ cursor<tab>:'.cmd.'\ s	:'.cmd.'\ s'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Find\ all\ instances\ of\ text\ under\ cursor<tab>:'.cmd.'\ t	:'.cmd.'\ t'."<cr>"
  exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Reset<tab>:CSr	:CSr'."<cr>"
  if exists("b:cscope_efm")
   exe 'menu '.g:DrChipTopLvlMenu.'Cscope.Restore\ Error\ Format	:CSL!'."<cr>"
  endif

  let s:installed_menus= 1
"  call Dret("CscopeMenu")
endfun

" ---------------------------------------------------------------------
" CscopeReset: {{{2
fun! s:CscopeReset()
"  call Dfunc("CscopeReset()")
  if has("win32") || has("win95") || has("win64") || has("win16")
   if &shell =~ '\%(\<bash\>\|\<zsh\>\)\%(\.exe\)\=$'
	" cygwin or similar shell being used under windows
	call system("cscope -b ".g:cecscope_dboptions." *.[ch]")
   else
	call system("cscope -b ".g:cecscope_dboptions." *.c *.h")
   endif
  else
   " linux/unix/macos/...
   call system("cscope -b ".g:cecscope_dboptions." *.[ch]")
  endif
  cscope reset
"  call Dret("CscopeReset")
endfun

" =====================================================================
"  Install Menus: {{{1
if !exists("s:installed_menus") && has("menu") && has("gui_running") && &go =~ 'm'
 call CscopeMenu(1)
endif

" =====================================================================
" Modelines: {{{1
" vim: fdm=marker
