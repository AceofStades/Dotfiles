:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a
:set ignorecase

nnoremap  <C-O> :tabn<CR>
nnoremap  <C-U> :tabp<CR>
nnoremap  <C-I> :tabnew<CR>

noremap <C-J> <C-W>j
noremap <C-K> <C-W>k
noremap <C-H> <C-W>h
noremap <C-L> <C-W>l

"cnoreabbrev term :split<CR>:term<CR><C-W>7-
cnoreabbrev term :split<CR><C-W>j:term<CR>:resize 12<CR>
noremap <C-0> <C-W>l<C-W>j<C-W>=:resize 12<CR>

:tnoremap <Esc> <C-\><C-n>

call plug#begin()

Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/lifepillar/pgsql.vim' " PSQL Pluging needs :SQLSetType pgsql.vim
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " Auto Completion
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
Plug 'https://github.com/preservim/tagbar' " Tagbar for code navigation
Plug 'https://github.com/terryma/vim-multiple-cursors' " CTRL + N for multiple cursors
Plug 'https://github.com/lambdalisue/suda.vim/' " Sudo
Plug 'numirias/semshi', { 'do': ':UpdateRemotePlugins' } "Python colorsscheme
Plug 'https://github.com/numirias/semshi' "Python colorscheme
Plug 'github/copilot.vim' "Copilot so yes
Plug 'zbirenbaum/copilot.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'CopilotC-Nvim/CopilotChat.nvim', { 'branch': 'canary' }

set encoding=UTF-8

call plug#end()

nnoremap <C-t> :NERDTreeToggle<CR>

nmap <F8> :TagbarToggle<CR>

let g:semshi#filetypes = ['python']
let g:semshi#excluded_hl_groups	= ['local']
let g:semshi#mark_selected_nodes = 1
let g:semshi#no_default_builtin_highlight = v:true
let g:semshi#simplify_markup = v:true
let g:semshi#error_sign	= v:true
let g:semshi#error_sign_delay = 1.5
let g:semshi#always_update_all_highlights = v:true
let g:semshi#tolerate_syntax_errors = v:true
let g:semshi#self_to_attribute = v:true

:set completeopt-=preview " For No Previews

:colorscheme abstract

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" --- Just Some Notes ---
" :PlugClean :PlugInstall :UpdateRemotePlugins
"
" :CocInstall coc-python
" :CocInstall coc-clangd
" :CocInstall coc-snippets
" :CocCommand snippets.edit... FOR EACH FILE TYPE

" air-line
let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

augroup fish_syntax
	au!
	autocmd BufNewFile,BufRead *.fish set syntax=sh
augroup end

autocmd ColorScheme abstract
  \ highlight CopilotSuggestion guifg=#555555 ctermfg=8

lua << EOF
require("CopilotChat").setup {
  debug = true, -- Enable debugging
  -- See Configuration section for rest
}
