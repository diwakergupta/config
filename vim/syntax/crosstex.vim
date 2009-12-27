" Vim syntax file
" Language:	CrossTeX (bibliographic database format for (La)TeX)
" Maintainer:	Diwaker Gupta <diwaker@floatingsun.net>
" Filenames:	*.xtx

" Initialization
" ==============
" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" Ignore case
syn case ignore

setlocal iskeyword+="@-@,:,-,_"

" Keywords
" ========
syn keyword xtxObjectType article author book booklet 
syn keyword xtxObjectType collection conference conferencetrack country 
syn keyword xtxObjectType inbook incollection inproceedings journal 
syn keyword xtxObjectType location manual mastersthesis misc 
syn keyword xtxObjectType month newspaper newspaperarticle patent
syn keyword xtxObjectType phdthesis proceedings rfc state 
syn keyword xtxObjectType string techreport thesis unpublished 
syn keyword xtxObjectType url workshop 

syn keyword xtxFieldType contained abstract address address affiliation
syn keyword xtxFieldType contained annote author bib bibsource
syn keyword xtxFieldType contained booktitle category chapter city
syn keyword xtxFieldType contained contents copyright country crossref
syn keyword xtxFieldType contained doi dvi edition editor
syn keyword xtxFieldType contained ee email ftp howpublished
syn keyword xtxFieldType contained html http institution isbn
syn keyword xtxFieldType contained issn journal key keywords
syn keyword xtxFieldType contained language lccn location longname
syn keyword xtxFieldType contained month monthno mrnumber name
syn keyword xtxFieldType contained note number organization pages
syn keyword xtxFieldType contained pdf phone price ps
syn keyword xtxFieldType contained publisher rtf school series
syn keyword xtxFieldType contained shortname size state title
syn keyword xtxFieldType contained type url volume year

" Clusters
" ========
syn cluster xtxFieldContents contains=xtxUnescapedSpecial,xtxBrace,xtxParen

" Matches
" =======

syn match xtxUnescapedSpecial contained /[^\\][%&]/hs=s+1
syn match xtxKey contained /\s*[^ \t}="]\+,/hs=s,he=e-1 nextgroup=xtxField
syn match xtxVariable contained /[^{}," \t=]/

" Regions
" =======
syn region xtxQuote contained start=/"/ end=/"/ skip=/\(\\"\)/ contains=@xtxFieldContents
syn region xtxBrace contained start=/{/ end=/}/ skip=/\(\\[{}]\)/ contains=@xtxFieldContents
syn region xtxField contained start="\S\+\s*=\s*" end=/[}),]/me=e-1 contains=xtxFieldType,xtxBrace,xtxParen,xtxQuote,xtxVariable

" Highlighting defaults
" =====================
hi link xtxObjectType Type
hi link xtxFieldType Keyword

let b:current_syntax = "crosstex"
