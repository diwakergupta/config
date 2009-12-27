" HTML.vim
let g:do_xhtml_mappings   = "yes"
let g:html_tag_case       = "lower"
let g:no_html_toolbar     = "yes"
let g:html_authorname     = "Diwaker                  Gupta"
let g:html_authoremail    = "diwaker@floatingsun.net"
let g:no_html_tag_mapping = "yes"

" bash support
let g:BASH_AuthorName               = "Diwaker Gupta"
let g:BASH_AuthorRef                = "DG"
let g:BASH_Email                    = "diwaker@asterdata.com"
let g:BASH_Company                  = "Aster Data Systems, Inc."
let g:BASH_LoadMenus                = "no"
let g:BASH_Template_File = "dg-bash-file-header"

" disable showmarks by default
let showmarks_enable                = 0

" taglist
let Tlist_Auto_Open                 = 0
let Tlist_Auto_Update               = 1
let Tlist_Ctags_Cmd                 = "/usr/bin/ctags"
let Tlist_File_Fold_Auto_Close      = 1
let Tlist_Highlight_Tag_On_BufEnter = 1
let Tlist_Process_File_Always       = 1
let Tlist_Show_One_File             = 1
let Tlist_WinWidth                  = 40

" NERD Commenter
let NERDShutUp=1
let NERDMapleader='<leader>x'
let NERDSpaceDelims=1

" Latex Suite
let g:Tex_CompileRule_dvi = 'latex --src-specials --interaction=nonstopmode $*'
let g:Tex_CompileRule_ps = 'dvips -Ppdf -o $*.ps $*.dvi'
let g:Tex_CompileRule_pdf = 'ps2pdf $*.ps'
let g:Tex_UseEditorSettingInDVIViewer = 1

" rcsvers
let g:rvSaveDirectoryName="/home/diwaker/.rcsfiles/"
let g:rvSaveDirectoryType=1
let g:rvMode=0 "switched off by default

" GetLatestVimScripts
let g:GetLatestVimScripts_allowautoinstall=1

" yankring
let g:yankring_history_dir='~/.vim'

" doxygen toolkit
let g:DoxygenToolkit_briefTag_pre="@synopsis  "
let g:DoxygenToolkit_paramTag_pre="@param "
let g:DoxygenToolkit_returnTag="@returns   "
let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
let g:DoxygenToolkit_blockFooter="--------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="Diwaker Gupta"

" python.vim
let python_highlight_all=1
let python_highlight_space_errors=1

" snipmate
let g:snips_author = "Diwaker Gupta"
