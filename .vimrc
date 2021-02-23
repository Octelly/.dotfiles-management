set nocompatible
set number relativenumber
set termguicolors

set wrap!

filetype plugin on
syntax on

colorscheme sonokai
hi Normal guibg=NONE ctermbg=NONE

" https://github.com/kovidgoyal/kitty/issues/108
let &t_ut=''

inoremap <Tab><Space> <Esc>/<++><enter>"_c4l

autocmd FileType html inoremap ;b <b></b><Space><++><Esc>T>;1i

command! -nargs=0 Sw w !sudo tee % > /dev/null

call plug#begin('~/.vim/plugged')

Plug 'chrisbra/Colorizer'
Plug 'wakatime/vim-wakatime'
Plug 'Valloric/YouCompleteMe'  " FIXME

call plug#end()
