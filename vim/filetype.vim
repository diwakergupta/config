augroup filetypedetect
    au BufNewFile,BufRead *.html setfiletype xhtml
    au BufNewFile,BufRead SConstruct setfiletype python
    au BufNewFile,BufRead *.muttrc setfiletype muttrc
    au BufNewFile,BufRead *.cls setfiletype tex
    au BufNewFile,BufRead *.ft setfiletype xml
    au BufNewFile,BufRead *.tac setfiletype python
    au BufNewFile,BufRead *.tex setfiletype tex
    au BufNewFile,BufRead *.cfdg setfiletype cfdg
    au BufNewFile,BufRead *.xtx setfiletype crosstex
augroup END
