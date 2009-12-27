" vim6:fdm=marker:foldenable:ts=4:sw=4:foldclose=

"           TabLineSet.vim  -- Vim7+ tabline configuration utility  {{{
" ---------------------------------------------------------------------
"
"
" 
" Author:		Eric Arnold ( eric_p_arnold@yahoo.com )
" Last Change:	Sun Apr 16, 04/16/2006 8:06:24 AM
" Requires:		Vim 7
" Version: 		1.2		Sat Apr 01, 04/01/2006 2:53:43 AM
" Version: 		1.3		Sun Apr 02, 04/02/2006 1:36:01 AM
" 						- Added more indicators, and toggle mapping funcs
" 						  for verbose control.
" 						- Changed the name of the script from tabset.vim
" 						- Solidified the non-GUI color scheme.
"						- Started some hooks to customize slack area.
" Version: 		1.4		Mon Apr 03, 04/03/2006 6:47:11 AM
"						- added comma list of buffers contained in tab
"						- changed toggle and rotate mapping functions to
"						  handle multiple option sets to switch through
" Version: 		1.5		Sun Apr 09, 04/09/2006 1:50:28 AM
" 						- added filter lists
" 						- re-arranged the close button, the window counter,
" 						  and the (tab,win,buf) list.
" Version: 		1.55	Sun Apr 16, 04/16/2006 8:04:17 AM
" 						- disable the g:TabLineSetFillerFunc per the problem
" 						  with VIm70d.
" Version: 		1.56	Thu Apr 20, 04/20/2006 5:14:24 AM
" 						- Fixed bug with verbose auto-shutoff causing infinite
" 						  loop
" Version: 		1.6		Mon May 01, 05/01/2006 10:40:15 AM
" 						- Fixed problem where slow-down occurs when the
" 						tabline function is called for every keystroke.  Use
" 						the toggle or rotate mappings/functions to reset the
" 						highlighting, if something clobbers it.
" Version: 		1.61	Mon May 01, 05/01/2006 10:40:15 AM
" 						- Really fix it this time.
" Version: 		1.7		Thu May 04, 05/04/2006 1:04:14 AM
" 						- Added pre- and post-proc function hooks
"
" Acknowledgements:	Well, I started with the doc page example, I guess :-)
"
" Synopsis:
"
"	-	Configurable, intelligent/dynamic tab field sizing.
"
"	-	New colorscheme and general presentation.  The highlighting groups are
"		defined at the end of the script.  Tweak as desired.
"
"	-	The indicator sets are customizable.
"		(It will also turn verbose mode off automatically, as needed.)
"
"		You can add the   g:TabLineSet_.*   vars to your .vimrc, where you can
"		customize tab min/max, etc., and these these indicators:
"			modified		: whether any window in the tab needs saving
"			windows			: window count in the tab
"			buffers_list	: tab label contains comma list of buffers contained
"			closers			: add hot spots ("!") to the tab for click-to-close
"
"			These are mostly for development, but might be useful otherwise:
"			tabnr			: include the tab number for the selected tab/window
"			winnr			: ... window number
"			bufnr			: ... buffer number
"			filler_func		: tell it to use   g:TabLineSetFillerFunc   to
"							  contain the name of a function to be evaluated
"							  at runtime.  It's proof of concept, mostly.
"
"
"	-	You can add these mappings to your .vimrc to control the verbose
"		settings on the fly:
"
"		The first one toggles all indicators off:
"
"			nmap <Leader>tv :call TabLineSet_verbose_toggle()<CR>
"
"		The second rotates through a list of option settings which
"		configurable/extensible via g:TabLineSet_verbose_sets.  See below.
"
"			nmap <Leader>tr :call TabLineSet_verbose_rotate()<CR>
"
"	-	Additional customization can be done via the filter lists.  These are
"		more complex, requiring use of regex's and such, but they allow you to
"		make arbitrary changes to the TabLine string at runtime.  There is
"		also preproc and postproc variables which can call back to your
"		function(s).
"
"	-	You have the choice of editing stuff in place here, but it might be
"		better to copy the vars and highlights of interest into your .vimrc .
"		I think I've isolated it all to be easy to cut and paste, maybe.
"
"	-	Finally, the ultimate customization:  dink around with the script
"		yourself :-)
"
"
" Issues:
"
"	-	There is a  problem where slow-down occurs when the tabline function
"		is called for every keystroke.  Use the toggle or rotate
"		mappings/functions to reset the highlighting, if something clobbers
"		it.
"
" Bugs:
"
" 	-	There is some problem with using the 'filler function' as of Vim70d
" 		performance drags down because a re-eval is called for every
" 		keystroke.
"
" }}}

 


"                     Configuration variables section                   {{{
" -------------------------------------------------------------------------
"
" 

if v:version >= 700
else
	echomsg "Vim 7 or higher is required for TabLineSet.vim"
	finish
endif

let g:TabLineSet_version = 1.56

if exists( 'g:no_load_TabLineSet' )		" Turn it off from .vimrc
	finish
endif


let g:TabLineSet_min = 4			" minimum tab width (space padded)
let g:TabLineSet_min2 = 4			" ... used for 'buffers_list'
let g:TabLineSet_max = 999			" maximum tab width
let g:TabLineSet_verbose_auto = 4	" turn on/off verbose at this tab width


" Masterlist:  do not change.
let s:all_verbose_options = 
	\ [ 
	\	'modified', 'windows', 'buffers_list', 'closers', 
	\	'tabnr', 'winnr', 'bufnr', 'filler_func'
	\ ]


" You can config this in place here, or add() to it (see below):

let g:TabLineSet_verbose_sets = 
	\ [
		\ [ 'modified', 'windows', 'buffers_list', 'closers', 'filler_func' ],
		\ s:all_verbose_options,
		\ [ 'modified', 'windows', 'closers' ],
		\ [ 'buffers_list' ],
		\ [ ]
	\ ]
		" ^^^
		"  |
		"  +-----------    Your option list(s) here:
		"                  or
		"  Here:


call add( g:TabLineSet_verbose_sets, [ 'closers', 'buffers_list' ] )


" As promised, there is still a string variable for the options list
" which can be set like:
"
"		let g:TabLineSet_verbose = 'modified,windows,closers'
"
" even though here it is being set from the lists above:
"
let g:TabLineSet_verbose = join( g:TabLineSet_verbose_sets[0], ',' )
"
" You should then probably add it to the option/verbose-level set, so 
" it doesn't get clobbered if you rotate through the sets:
"
"		call add( g:TabLineSet_verbose_sets, [ g:TabLineSel_verbose ] )
"



" This nested list holds substitution triplets that well be applied to each
" buffer name via  substitute()  before it is added to the tab.   Note that
" this script does a pretty brute force method of shrinking the tabs to fit by
" looping a lot.  If you add bunches of filters, it might affect performance.
"
let g:TabLineSet_bufname_filters = [ 
		\ 	[ '\[No Name\]'		],
		\ 	[ '^--*\(.*\)--*$',		'\1',	'' ]
		\ ]
		" The first example filters out all unnamed buffers.
		" The second example filters out --minibufexplorer-- type lines that
		" show up in all tabs if the minibufexplorer is used.


" The following allows you to define substitutions on each tab as a whole.
" This begins to get tricky, since what you see at the top of your Vim is a
" small part of the format string that is sent to the tabline formatter.
" You're on your own as to whether it messes up the tab's formatting, length,
" etc.
"
let g:TabLineSet_tab_filters = [
		\ 	[ ',',		 ';',	'g' ]
		\ ]
		"\ 	[ '%#TabPunct\w*#,%#Tab\w*#',		 ';',	'g' ]
		" This example removes the commans and their highlighting, and
		" replaces them with semi-colons.


if 0	"  don't execute, example only

" The folowing example replaces the leading "!" to include the current time
" using the substitute special \= evaluation feature.  
"
" First, clean out any copies of our changes because the tab length
" calculation makes multiple passes, each of which would other wise insert
" another timestamp.
call add( g:TabLineSet_tab_filters, 	[ '%X%#DiffChange#\d\d:\d\d:\d\d',		 '',	'g' ] )

" Note also that the new current time string would inherit the color of the
" "!" char, if it didn't include the %X%#..#  format string around the "!" .
call add( g:TabLineSet_tab_filters, 	[ '!%X%#[^#]*#',		 '\=MyFunc()',	'' ] )

function! MyFunc()
	let s = strftime("%H:%M:%S")
	" Since this increases the length of the tab outside of the TabLineSet
	" functions, so incrementing the  g:TabLineSet_out_pos to account for
	" the extra chars will help it, a little, to draw.  
	let g:TabLineSet_out_pos += strlen(s)
	return submatch(0) . '%X%#DiffChange#' . s
endfunction

endif	" end of don't execute



" This performs substitutions at the full tabline level.  The possibility to
" make a mess increases :-)
"
let g:TabLineSet_tabline_filters = [ 
		\ ]
		"\ 	[ '^',		'(-:  ' ],
		"\ 	[ '$',		 ' :-)' ]



" This holds a copy of the final (huge!) string with all the embedded syntax
" and or highlighting.  You can use it to help decide how you want to make
" filters.
"
let g:TabLineSet_output_pre = ''
let g:TabLineSet_output_post = ''




" Use the filler func to doddle in the ending  space in the tabline:
"
"let g:TabLineSetFillerFunc = 'TabLineSetFillerTest'
let g:TabLineSetFillerFunc = ''


" This is called for each evaluation pass and can set the initial
" value of the tabline string.
"
let g:TabLineSet_preproc_func = ''
"let g:TabLineSet_preproc_func = 'Tst_preproc'



" This is passed the final tabline string.  It's a final hook for whatever.
"
let g:TabLineSet_postproc_func = ''
"let g:TabLineSet_postproc_func = 'Tst_postproc_modified'



"  End config vars  
" 
" ----------------------------------------------------------------------}}}





"                          TabLineSet_main()                           {{{
" -------------------------------------------------------------------------
"
" 

let g:TabLineSet_debug_counter = -1

let s:last_reltime = reltime()
" Try to deal with the Vim7 bug where the tagline function starts getting
" called for every key
let s:bug_keycount = 0
let s:last_winnr = winnr() 
let s:last_tabpagenr = tabpagenr()
let s:last_localtime = localtime()


function! TabLineSet_main()

	if !exists('s:called_hl_init')
		let s:called_hl_init = 1
		call TabLineSet_hl_init()
	endif

	if 0 && has( 'reltime' )
		echomsg string( reltime() )
		if s:bug_keycount >= 3
			let s:bug_keycount = 0
			let s:last_reltime = reltime()
			call TabLineSet_verbose_toggle0()
			"return 'Tagline bug detected'
		endif

		if ( reltime()[1] - s:last_reltime[1] ) < 5000000
			if s:last_winnr == winnr() && s:last_tabpagenr == tabpagenr()
				let s:bug_keycount += 1
			endif
		else
			let s:bug_keycount = 0
		endif
		let s:last_reltime = reltime()
		let s:last_winnr = winnr() 
		let s:last_tabpagenr = tabpagenr()

		if g:TabLineSet_debug_counter >= 0
			echomsg "TabLineSet_main called " . g:TabLineSet_debug_counter . " times."
			let g:TabLineSet_debug_counter += 1
		endif
		echomsg 'bugkey ' . s:bug_keycount
	endif

	" Call the highlight init each time, since there is no simple way of
	" telling whether something else has trashed our highlighting, which
	" happens all too often:
	"
	" Don't call the hl function each time, since it can cause the tabline
	" function trigger for every keystroke:
	if ( localtime() - s:last_localtime ) > 5
		call TabLineSet_hl_init()
	endif
	let s:last_localtime = localtime()



	let s:verbose = g:TabLineSet_verbose

	"let avail = winwidth( winnr() )
	" It always goes across whole top of screen:
	let avail = &columns

	let numtabs = tabpagenr('$')

	" account for space padding between tabs, and the "close" button
	let maxlen = ( &columns - ( numtabs * 3 ) 
				\ - ( s:verbose == '' ? 2 : 0 ) ) / numtabs

	if maxlen > g:TabLineSet_max | let maxlen =  g:TabLineSet_max | endif

	if maxlen < g:TabLineSet_verbose_auto 
	   	let s:verbose = '' 
		let maxlen = ( &columns - ( numtabs * 3 ) 
				\ - ( s:verbose == '' ? 2 : 0 ) ) / numtabs
   	endif


	let maxlen_start = maxlen
	let tabline_out = ''	" Don't fall out of below loop with this undefined


	" Loop to extend maxlen, the dynamic length limit assigned to the tabs
	let maxloop = 10
	while ( maxloop > 0 ) && ( avail > 1 ) 
				\ && ( maxlen_start < &columns )
		let maxloop = maxloop - 1

		let maxlen = s:Set_maxlen( maxlen_start )

		let tabline_out = ''
		if g:TabLineSet_preproc_func != ''
			let tabline_out = {g:TabLineSet_preproc_func}( )
		endif


		" g:TabLineSet_out_pos will hold the total number of chars, as they will
		" appear in the tab line.  The actual number of chars is badly
		" highlight formatting information.
		let g:TabLineSet_out_pos = 0


		for tabnum in range( 1, tabpagenr('$') )

			let buflist = []
			let buflist = tabpagebuflist( tabnum )
			if len( buflist ) < 1
				continue
			endif


			let modded = ''
			for bufnum in buflist
				if getbufvar( bufnum,  '&modified' ) != 0
					let modded = '+'
				endif
			endfor

			let is_selected = tabnum == tabpagenr()

			let tabline_out .= is_selected ? '%#TabLineSel#' : '%#TabLine#'

			" set the tab page number (for mouse clicks)
			let tabline_out .= '%' . ( tabnum ) . 'T'





			" ----------------------------------------
			" Add an indicator that some buffer in the tab is modified:
			"
			let tablabel = ''
			if s:verbose =~ 'modified' && modded != ''
				let tablabel .= '%#TabModded#' . modded
				let tablabel .= is_selected ? '%#TabLineSel#' : '%#TabLine#'
				let maxlen = s:Set_maxlen( maxlen - 1 )
			endif

			let winnr = tabpagewinnr( tabnum )
			let numwins = tabpagewinnr( tabnum, ("$") )




			" ----------------------------------------
			" Misc values, i.e. the number of windows in the tab:
			"

			let numwins_out = ''
			if is_selected == 0 && s:verbose =~ 'windows'  && len( buflist ) > 1
				let numwins_out = numwins
				let maxlen = s:Set_maxlen( maxlen - strlen( numwins_out ) )
			endif

			let tabnr_out = ''
			if s:verbose =~ 'tabnr' && is_selected
				let tabnr_out .= 't' . tabnum 
				let maxlen = s:Set_maxlen( maxlen - strlen( tabnr_out ) )
			endif

			let winnr_out = ''
			if s:verbose =~ 'winnr' && is_selected
				let winnr_out .= 'w' . winnr 
				let maxlen = s:Set_maxlen( maxlen - strlen( winnr_out ) )
			endif

			let bufnr_out = ''
			if s:verbose =~ 'bufnr' && is_selected
				let bufnr_out .= 'b' . winbufnr( winnr )
				let maxlen = s:Set_maxlen( maxlen - strlen( bufnr_out ) )
			endif

 
			let r_brac = ''
			let l_brac = ':'
			let out_list = [ numwins_out, tabnr_out, winnr_out, bufnr_out ]
			let out_list = filter( out_list, 'v:val != "" ' )
			let misc_vals = '' 
			if len( out_list ) > 0
				let misc_vals = r_brac
						\ . ( is_selected ? '%#TabWinNumSel#' : '%#TabWinNum#' )
						\ . join( out_list , ',' )
						\ . ( is_selected ? '%#TabLineSel#' : '%#TabLine#' )
						\ . l_brac
				let g:TabLineSet_out_pos = g:TabLineSet_out_pos + 
						\ strlen( r_brac . join( out_list , ',' ) . l_brac )

			endif
			" end misc values

			let tablabel .= misc_vals





			" ----------------------------------------
			"  Add buffer name(s)
			"
			"
			let winnr_start = 1
			let winnr_stop = numwins
			if s:verbose !~ 'buffers_list'
				let winnr_start = winnr
				let winnr_stop = winnr
			endif

			" subtract - numwins   to accound for commas:
			let maxlen1 = ( ( maxlen - numwins + 1 ) / numwins )
			if maxlen1 < g:TabLineSet_min2 
				let winnr_start = winnr
				let winnr_stop = winnr
			endif

			let bufname_list = []
			let adj_maxlen = 0
			for winnr1 in range( winnr_start, winnr_stop )
				let tabbufnr = buflist[ winnr1 - 1]
				let tabbufname = bufname( tabbufnr )
				let tabbufname = fnamemodify( tabbufname, ':t' )
				if tabbufname == ''
					let tabbufname = '[No Name]'
				endif


				if s:verbose =~ '\(tabnr\|winnr\|bufnr\)' 
							\ && tabbufnr == winbufnr( winnr() )
					let tabbufname = '>' . tabbufname
				endif

				for elem in g:TabLineSet_bufname_filters
					while len( elem ) < 3 | call add( elem, '' ) | endwhile
					let tabbufname = substitute( tabbufname, 
							\ elem[0], elem[1], elem[2] )
				endfor

				call add( bufname_list, tabbufname )
			endfor

			" shrink the names in the list a bit/byte at a time, so the space
			" is distributed evenly:
			let tabbufnames = join( bufname_list, ',' )
			while strlen( tabbufnames ) > maxlen
				let longest = 0
				let which = 0
				for i in range( 0, len( bufname_list ) - 1 )
					if strlen( bufname_list[ i ] ) > longest
						let which = i
						let longest = strlen( bufname_list[ i ] )
					endif
				endfor
				let b = bufname_list[ which ]
				let bufname_list[ which ] = strpart( b, 0, strlen( b ) - 1 )
				let tabbufnames = join( bufname_list, ',' )
			endwhile

			call filter( bufname_list, 'v:val != ""')
			call map( bufname_list, 'strpart( v:val, 0,  maxlen1 )' )

			let sep = ''
					\ . ( is_selected ? '%#TabPunctSel#' : '%#TabPunct#' )
					\ . ','
					\ . ( is_selected ? '%#TabLineSel#' : '%#TabLine#' )

			let tabbufnames = join( bufname_list, ',' )

			" Pad to _min
			let len = strlen( tabbufnames )
			while strlen( tabbufnames ) < g:TabLineSet_min 
						\ && strlen( tabbufnames )< maxlen
				let tabbufnames = tabbufnames . ' '
			endwhile

			"let tabbufnames = strpart( tabbufnames, 0,  maxlen )
			let g:TabLineSet_out_pos = g:TabLineSet_out_pos + strlen( tabbufnames )

			let sep = ''
					\ . ( is_selected ? '%#TabPunctSel#' : '%#TabPunct#' )
					\ . ','
					\ . ( is_selected ? '%#TabLineSel#' : '%#TabLine#' )

			let tabbufnames = join( bufname_list, sep )

			let tabbufnames = substitute( tabbufnames, '>',
						\ '%#TabModded#' . '>'
						\ .  ( is_selected ? '%#TabLineSel#' : '%#TabLine#' )
						\ , 'g' )

			" end bufnames section





			" ----------------------------------------
			"  Closers
			"
			"
			let tabexit = ''
			if s:verbose =~ 'closers'
				let tabexit .= ( is_selected ? '%#TabExitSel#' : '%#TabExit#' )
							\ . '%' . tabnum . 'X!%X'
				let maxlen = s:Set_maxlen( maxlen - 1 )
				let g:TabLineSet_out_pos = g:TabLineSet_out_pos + 1
				let tablabel .= ( is_selected ? '%#TabLineSel#' : '%#TabLine#' )
			endif


			" ----------------------------------------
			"  Put the pieces together
			"


			let tablabel = tabexit . tablabel . ' ' . tabbufnames

			let tablabel .= '%#TabSep#' . '|'
						\ . ( is_selected ? '%#TabLineSel#' : '%#TabLine#' )

			let g:TabLineSet_out_pos = g:TabLineSet_out_pos + 3


			for elem in g:TabLineSet_tab_filters
				while len( elem ) < 3 | call add( elem, '' ) | endwhile
				let tablabel = substitute( tablabel, 
						\ elem[0], elem[1], elem[2] )
			endfor

			let tabline_out .= tablabel


		endfor		" for tabnum in range( 1, tabpagenr('$') )


		" ------------------------------
		"  Final formatting
		"
		" after the last tab fill with TabLineFill and reset tab page nr
		let tabline_out .= '%#TabLineFillEnd#%T'


		" right-align the label to close the current tab page
		let last_close = ''
		if tabpagenr('$') > 1 && s:verbose == ''
			let last_close = '%=%#TabLine#%999X X'
		endif

		let avail = ( &columns - 1 ) - g:TabLineSet_out_pos - ( last_close == '' ? 2 : 0 )

		if g:TabLineSetFillerFunc != '' && s:verbose =~ 'filler_func'
			let tabline_out .= '%{' . g:TabLineSetFillerFunc . '(' . avail . ')}'
		endif

		let tabline_out .= last_close




		" too slow:
		"let maxlen_start = maxlen_start + 1
		let maxlen_start = maxlen_start + ( avail / numtabs )

	endwhile " extend maxlen 


	let g:TabLineSet_output_pre = tabline_out

	for elem in g:TabLineSet_tabline_filters 
		while len( elem ) < 3 | call add( elem, '' ) | endwhile
		let tabline_out = substitute( tabline_out, 
					\ elem[0], elem[1], elem[2] )
	endfor

	let g:TabLineSet_output_post = tabline_out

	if g:TabLineSet_postproc_func != ''
		call call( g:TabLineSet_postproc_func, [ tabline_out ] )
	endif

"	let s:test_count += 1
"	if s:last_out == tabline_out
"		echo s:test_count . ', is same'
"	else
"		echo s:test_count . ', is not same'
"	endif
"	let s:last_out = tabline_out

	return tabline_out

endfunction

let s:last_out = ''

" End main function  }}}




function! Tst_preproc( tabline )
	return '[test]' . a:tabline
endfunction


let s:modified_table = {}
function! Tst_postproc_modified( tabline )
	let updated = []
	for bufnr in range( 1, bufnr("$") )
		if !bufexists( bufnr ) | continue | endif
		let modded = getbufvar( bufnr, '&modified' )
		if !has_key( s:modified_table, bufnr )
			let s:modified_table[ bufnr ] = modded
		endif
		if s:modified_table[ bufnr ] != modded
			let s:modified_table[ bufnr ] = modded
			call add( updated, [ bufnr, modded ] )
		endif
	endfor

	for elem in updated
		let bufnr = elem[0]
		let modded = elem[1]
		echomsg 'bufnr#' . bufnr . ', ' . bufname( bufnr ) . ' is now ' . ( modded ? '' : 'no' ) . 'modified'
	endfor

	" call somefunction( updated )

endfunction
		




"                          Misc functions                              {{{
" -------------------------------------------------------------------------
"
" 


function! s:Set_maxlen( maxlen )
	if a:maxlen < g:TabLineSet_verbose_auto 
		let s:verbose = '' 
	endif
	let ret = max( [ 2, a:maxlen ] )
	return ret
endfunction



function! TabLineSetFillerNull( avail )
	return ''
endfunction


let s:test_count = 0
function! TabLineSetFillerTest( avail )
	let s:test_count += 1
	let out = strftime( '%H:%M:%S' ) . '#' . s:test_count
	if strlen( out ) > a:avail
		let out = ''
	else
		while strlen( out ) <= a:avail
			let out = '.'. out
		endwhile
	endif
	return out
endfunction


let s:TabLineSet_verbose_save = ''


function! TabLineSet_verbose_toggle()
	call TabLineSet_hl_init()
	call TabLineSet_verbose_toggle0()
	call s:Force_tabline_update()
endfunction

" Have it split up to use this internally, when a "1 new" will fail in the
" sandbox.
function! TabLineSet_verbose_toggle0()
	if s:TabLineSet_verbose_save == ''
		let s:TabLineSet_verbose_save = g:TabLineSet_verbose
		let g:TabLineSet_verbose = ''
	else
		let g:TabLineSet_verbose = s:TabLineSet_verbose_save
		let s:TabLineSet_verbose_save = ''
	endif

endfunction

function! s:Force_tabline_update()
	" Make it update:
	1new
	quit
endfunction



let s:all_verbose_sets_idx = 0

function! TabLineSet_verbose_rotate()
	call TabLineSet_hl_init()
	let s:all_verbose_sets_idx = s:all_verbose_sets_idx + 1
	if s:all_verbose_sets_idx > len( g:TabLineSet_verbose_sets ) - 1
		let s:all_verbose_sets_idx = 0
	endif

	let g:TabLineSet_verbose = join( 
				\g:TabLineSet_verbose_sets[ s:all_verbose_sets_idx ], ',' )
	"silent! normal! gtgT
	1new
	quit
endfunction


" End Misc functions  }}}





"                          Highlighting (configurable)                  {{{
" -------------------------------------------------------------------------
"
" 


set tabline=%!TabLineSet_main()

if &showtabline < 1
	set showtabline=1	" 2=always
endif

function! TabLineSet_hl_init()
	"							*cterm-colors*
	"	    NR-16   NR-8    COLOR NAME ~
	"	    0	    0	    Black
	"	    1	    4	    DarkBlue
	"	    2	    2	    DarkGreen
	"	    3	    6	    DarkCyan
	"	    4	    1	    DarkRed
	"	    5	    5	    DarkMagenta
	"	    6	    3	    Brown, DarkYellow
	"	    7	    7	    LightGray, LightGrey, Gray, Grey
	"	    8	    0*	    DarkGray, DarkGrey
	"	    9	    4*	    Blue, LightBlue
	"	    10	    2*	    Green, LightGreen
	"	    11	    6*	    Cyan, LightCyan
	"	    12	    1*	    Red, LightRed
	"	    13	    5*	    Magenta, LightMagenta
	"	    14	    3*	    Yellow, LightYellow
	"	    15	    7*	    White
	"
	"	The number under "NR-16" is used for 16-color terminals ('t_Co'

	hi! TabWinNum term=bold,underline cterm=underline gui=bold,underline
				\ ctermfg=green guifg=Green ctermbg=darkgrey guibg=DarkGrey

	hi! TabWinNumSel term=bold,underline cterm=underline gui=bold,underline
				\ ctermfg=magenta ctermbg=blue guifg=Magenta guibg=#0000ff

	hi! TabPunct term=bold,underline cterm=underline gui=bold,underline
				\ ctermfg=cyan guifg=cyan ctermbg=darkgrey guibg=DarkGrey

	hi! TabPunctSel term=bold,underline cterm=underline gui=bold,underline
				\ ctermfg=magenta ctermbg=blue guifg=Magenta guibg=#0000ff

	hi! TabLineFill term=underline cterm=underline gui=underline

	hi! TabLineFillEnd term=underline cterm=underline gui=underline
				\ ctermfg=white ctermbg=black guifg=white guibg=black

	hi! TabLineSel  term=bold,reverse,underline 
				\ ctermfg=white ctermbg=blue guifg=#ffff00 guibg=#0000ff gui=underline


	hi! TabModded term=underline 
				\ cterm=underline ctermfg=black ctermbg=yellow
				\ gui=underline guifg=black guibg=yellow
				"guibg=#c0c000


	hi! TabExit term=underline,bold ctermfg=red guifg=#ff0000 guibg=darkgrey
				\  cterm=underline gui=underline 

	hi! TabExitSel gui=underline term=underline,bold guifg=green guibg=blue
				\  cterm=underline ctermfg=green ctermbg=blue

	hi! TabSep term=reverse,standout,underline cterm=reverse,standout,underline
				\ gui=reverse,standout,underline
				\ ctermfg=black ctermbg=white


endfunction


call TabLineSet_hl_init()

" End highlighting   }}}




