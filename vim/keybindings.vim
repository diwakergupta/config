" change directory to that of current file
" map <Leader>cd :exe 'cd ' . expand ("%:p:h")<CR>

" switch buffers
map <C-PageUp> :bp<CR>
map <C-PageDown> :bn<CR>
imap <C-PageUp> <Esc>:w<CR>:bp<CR>
imap <C-PageDown> <Esc>:w<CR>:bn<CR>

" select all
map <C-d>a <Esc>ggVG

" copy, cut, paste
vmap <C-d>c "+y
vmap <C-d>x "+x
imap <C-d>v <Esc>"+gpa

" backspace in visual mode deletes selection
vmap <BS> d

" write all changed buffers and exit vim
nmap <C-q> :wqa<CR>

" format paragraph
map Q vipgq

" close buffer
map <C-d>w <Esc>:update<CR>:bd<CR>

" save buffer
map <C-d>s :update<CR>

" window navigation
map <C-Up> <C-W><Up>
map <C-Down> <C-W><Down>
map <C-Left> <C-W><Left>
map <C-Right> <C-W><Right>
map <C-j> <C-W><Up>
map <C-k> <C-W><Down>
map <C-h> <C-W><Left>
map <C-l> <C-W><Right>

