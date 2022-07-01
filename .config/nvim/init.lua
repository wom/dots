vim.cmd('set nocompatible')
require('plugins')
require("nvim-tree").setup()
-- settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.cmd([[
if has("win32") || has("win16")
        let os="windows"
else 
        let os=system('uname -s')
endif
colorscheme duskfox
set history=50
set mouse=a
set showcmd
" Telescope!
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
""
" NvimTree
nnoremap <leader>n <cmd>NvimTreeToggle<cr>
""
filetype plugin indent on
autocmd!
set history=50
set mouse=a
set showcmd
set hidden
syntax on
set novisualbell
set wildmenu
set cpo-=<
set wcm=<C-Z>
highlight TrailingWhitespace ctermbg=red  guibg=red
function! NumberToggle()
    "if !empty($TMUX)
        "let tmux=1
        "echo "tmux1::".tmux."::"
    "else
        "let tmux=0
        "echo "tmux0"
    "endif
    "echo "In Func"
    if (&relativenumber == 1)
        "echo "isRelative"
        :set norelativenumber
        :set foldcolumn=0
    else
        "echo "inElse"
        if (&number == 1)
        "echo "isNumber"
            :set nonumber
            :set relativenumber
        else
            :set number
        endif
    endif
endfunction
nnoremap <F2> :call NumberToggle()<CR>

"buffer browsing.
nnoremap <silent><S-h> :bp<CR>
nnoremap <silent><S-l> :bn<CR>

""
" Tab Stuff!
set shiftround
set cursorline

""
"tab completion.
set wildmode=list:longest,full 
set wildmenu
:set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc

"multiple splits
"nmap + <C-W>+
"nmap - <C-W>-
nnoremap <silent> OA <C-W>-
nnoremap <silent> OB <C-W>+
nnoremap <silent> OC <C-W>>
noremap <silent> OD <C-W><
map <leader><space>     :nohlsearch <CR>

function! MyDate()
        let @x = substitute(system("date \"+%A, %B %d %Y\"")."\n","\n"," ", "")
        "let @x = substitute(system("date \"+%A, %B %d %Y\"")."\n   -----------------------------","\n"," ", "")
        normal! "xp
endf
map <leader><leader>d   :call MyDate()<CR>
if os != "windows"
    "preserve swap independently.
    :set dir=~/.vim/swp//
    if version >= 720
        "preserve undo independently.
        :set undodir=~/.vim/undodir//
        :set undofile
        :set undolevels=1000
        :set undoreload=10000
    endif
else
    ":set dir=~\swp\\
    :set clipboard=unnamed
endif
""
"DiffOrig Mapping.
function! DiffOrig()
    if &diff
        wincmd p | bdel | diffoff
    else
        vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
    endif
endfunction
map <leader>do :call DiffOrig()<cr>

" Folding
set foldmethod=syntax
set foldlevelstart=1
let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML
]])
