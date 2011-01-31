augroup filetypedetect
    au BufNewFile,BufRead *.html setfiletype xhtml
    au BufNewFile,BufRead *.cls setfiletype tex
    au BufNewFile,BufRead *.tex setfiletype tex
    au BufNewFile,BufRead *.cfdg setfiletype cfdg
    au BufNewFile,BufRead *.xtx setfiletype crosstex
    au BufNewFile,BufRead *.proto setfiletype proto
augroup END
