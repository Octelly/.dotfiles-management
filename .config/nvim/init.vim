" ┏┓╻┏━╸┏━┓╻ ╻╻┏┳┓   ┏━╸┏━┓┏┓╻┏━╸╻┏━╸
" ┃┗┫┣╸ ┃ ┃┃┏┛┃┃┃┃   ┃  ┃ ┃┃┗┫┣╸ ┃┃╺┓
" ╹ ╹┗━╸┗━┛┗┛ ╹╹ ╹   ┗━╸┗━┛╹ ╹╹  ╹┗━┛
" ( gaming 😎 )

" COMMON SETTINGS {{{
runtime! 'sheerun-vimrc.vim'

set number relativenumber
set termguicolors	" sheerun doesn't enable this on Kitty
set foldmethod=marker
set wrap!

set mouse=a " sheerun should enable this but doesn't?

filetype plugin on
syntax on

colorscheme sonokai
" }}}

" NON-NEOVIDE SETTINGS {{{
if !exists('g:neovide')
  " use terminal bg
  hi Normal guibg=NONE ctermbg=NONE
  
  " https://github.com/kovidgoyal/kitty/issues/108
  let &t_ut=''
endif
" }}}

" NEOVIDE SETTINGS {{{
let g:neovide_transparency = 0.9
let g:neovide_cursor_vfx_mode = "wireframe"
set guifont=FiraCore\ Nerd\ Font\ Mono:h14
" }}}


" CTRL keybinds {{{
" CTRL-Tab is next tab
noremap <C-Tab> :BufferNext<CR>
" CTRL-SHIFT-Tab is previous tab
noremap <C-S-Tab> :BufferPrevious<CR>
" terminals will generally not support this by default,
" the config for Kitty can be fixed like this:
" 	https://web.archive.org/web/20220323082808/https://erwin.co/getting-ctrltab-to-work-in-neovim/
" CTRL-w is close tab
" noremap <C-w> :BufferClose

" CTRL-b for file tree
noremap <C-b> :NvimTreeToggle<CR>
" }}}

" CUSTOM COMMANDS {{{
" https://stackoverflow.com/a/7078429
cmap w!! w !sudo tee > /dev/null %
" }}}


" ENSURE VIMPLUG {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif
" }}}

" PLUGIN OPTIONS {{{
"let g:airline_powerline_fonts = 1
"let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]
"set signcolumn=yes:9
let g:coq_settings = {"auto_start": "shut-up"}
let g:Hexokinase_highlighters = [ 'background' ]
let g:dashboard_default_executive = 'telescope'
" }}}

" PLUGINS {{{
call plug#begin('~/.vim/plugged')

" auto completion engine
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}

" highlight colour codes
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" let the FBI spy on me
Plug 'wakatime/vim-wakatime'

" status line goessss
"Plug 'vim-airline/vim-airline'
Plug 'feline-nvim/feline.nvim'

" language pack
Plug 'sheerun/vim-polyglot'

" the way you'd expect Vim to handle brackets
Plug 'jiangmiao/auto-pairs'

" file tree
"Plug 'preservim/nerdtree'
Plug 'kyazdani42/nvim-tree.lua'

" shortcut hinting
Plug 'folke/which-key.nvim'

" vim rofi
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" notifications
Plug 'rcarriga/nvim-notify'

" tabs
Plug 'romgrk/barbar.nvim'

" icons :)
"Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'

" dashboard
Plug 'glepnir/dashboard-nvim'

call plug#end()
" }}}

" ╻  ╻ ╻┏━┓
" ┃  ┃ ┃┣━┫   ╺━╸╺━╸╺━╸╺━╸╺━╸╺━╸╺━╸╺━╸╺━╸
" ┗━╸┗━┛╹ ╹

lua << EOF
-- see ./lua/lua_funcs.lua for more info
lua_funcs = require("lua_funcs")

-- FELINE SETTINGS {{{

local shared_components = {}

shared_components[1] = {
  {
    provider = 'omg emi 🥺',
    hl = {
      bg = 'red'
    },
    --left_sep = 'slant_right',
    right_sep = {
      str='slant_right',
      hl = {
        fg='red',
        bg='blue'
      }
    }
  },
  {
    provider = 'ahoj kati :)',
    hl = {
      fg = 'black',
      bg = 'blue'
    },
    right_sep = 'slant_right',
  }
}

local components = {
  --active = {{{provider='omg emi 🥺', hl={bg='red'}}}},
  active = shared_components,
  inactive = shared_components,
}

local feline_theme = {
  fg        = '#e3e1e4',
  bg        = '#2d2a2e',

  black     = '#1a181a',
  red       = '#f85e84',
  green     = '#9ecd6f',
  yellow    = '#e5c463',
  blue      = '#7accd7',
  magenta   = '#ab9df2',
  cyan      = '#78dce8',
  white     = '#e3e1e4',

  orange    = '#ef9062',

  --violet    = '#9E93E8',
  --skyblue   = '#50B0F0',
  --oceanblue = '#0066cc',
}

require('feline').setup{
  components = components,
  theme = feline_theme
}

-- }}}

-- PLUGIN SETUP {{{
require("notify").setup({
   stages = "slide", 
})
vim.notify = require("notify")
require('nvim-web-devicons').setup{default = true}
require('which-key').setup()
require('nvim-tree').setup()
--- }}}
EOF
