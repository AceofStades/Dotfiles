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

noremap <C-p> :FZF<CR>







" Set C++ file type
autocmd BufNewFile,BufRead *.cpp set filetype=cpp

" Compile and run C++ program in subshell
" function! CompileAndRun()
"   let fileName = expand('%')
"   if fileName =~ '\.cpp$'
"     let exeName = substitute(fileName, '\.cpp$', '', '')
"     execute 'w | !g++ -std=c++20 -Wall -Wextra -Wpedantic -O2 -o ' . exeName . ' ' . fileName
"     if v:shell_error == 0
"       let cmd = "kitty -e bash -c './" . exeName . "; read -p \"Press enter to exit...\"'"
"       call system(cmd)
"       redraw!
"     endif
"   else
"     echo 'Not a C++ file'
"   endif
" endfunction

function! CompileAndRun()
  let fileName = expand('%')

  " Check file extension and choose compiler/interpreter"
  if fileName =~ '\.cpp$'
    let compiler = 'g++'
    let flags = '-std=c++20 -Wall -Wextra -Wpedantic -O2'
    let exeName = substitute(fileName, '\.cpp$', '', '')
  elseif fileName =~ '\.c$'
    let compiler = 'gcc'
    let flags = '-Wall -Wextra -Wpedantic -O2'
    let exeName = substitute(fileName, '\.c$', '', '')
  elseif fileName =~ '\.py$'
    let compiler = 'python'  " No compilation needed for Python"
    let exeName = fileName   " Executable name is the filename itself"
  else
    echo 'Unsupported file type'
    return
  endif

  " Compile (if needed) and run the program"
  if compiler != 'python'
    execute '!' . compiler . ' ' . flags . ' -o ' . exeName . ' ' . fileName
    if v:shell_error == 0
      let cmd = "kitty -e bash -c './" . exeName . "; read -p \"\nPress enter to exit...\"'"
      call system(cmd)
      redraw!
    else
      echoerr 'Compilation failed!'
    endif
  else
    " execute '!' . compiler . ' ' . fileName
	let cmd = "kitty -e bash -c 'python " . exeName . "; read -p \"\nPress enter to exit...\"'"
	call system(cmd)
	redraw!  " Redraw after running Python script"
  endif
endfunction


" Map keys to compile and run current file
map <F5> :call CompileAndRun()<CR>
map <F9> :w<CR>:!clear<CR>:call CompileAndRun()<CR>
nnoremap <A-o> :call CompileAndRun()<CR>







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
Plug 'jiangmiao/auto-pairs' " Auto Pairs
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " Fuzzy finder

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

source ~/.config/nvim/coc.vim

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

g:python_host_prog = '/home/aceofstades/venvs/.nvim-venv/bin/python'
g:python3_host_prog = '/home/aceofstades/venvs/.nvim-venv/bin/python'

inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"
imap <silent><script><expr> <S-Tab> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true


augroup fish_syntax
	au!
	autocmd BufNewFile,BufRead *.fish set syntax=sh
augroup end

autocmd ColorScheme abstract
  \ highlight CopilotSuggestion guifg=#555555 ctermfg=8

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif

:set signcolumn=no


