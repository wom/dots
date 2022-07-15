vim.cmd('set nocompatible')
require('plugins')
require('setup')

-- settings - Move into wom at some point and migrate to native lua
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.o.guifont = "FiraCode NF:h8"

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
nnoremap <leader>fn <cmd>Telescope file_browser<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
""
" NvimTree
nnoremap <leader>n <cmd>NvimTreeToggle<cr>
""
filetype plugin indent on
"autocmd!
set history=50
set mouse=a
set showcmd
set hidden
syntax on
set novisualbell
set wildmenu
set wildmode=list:longest,full 
:set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc
set cpo-=<
set wcm=<C-Z>
"highlight TrailingWhitespace ctermbg=red  guibg=red

function! NumberToggle()
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

map <leader><space>     :nohlsearch <CR>

function! MyDate()
        let @x = substitute(system("date \"+%A, %B %d %Y\"")."\n","\n"," ", "")
        "let @x = substitute(system("date \"+%A, %B %d %Y\"")."\n   -----------------------------","\n"," ", "")
        normal! "xp
endf
map <leader><leader>d   :call MyDate()<CR>
if os != "windows"
    "preserve swap independently.
    :set dir=~/.cache/nvim/swp//
    "preserve undo independently.
    :set undodir=~/.cache/nvim/undodir//
    :set undofile
    :set undolevels=1000
    :set undoreload=10000
else
    :set clipboard=unnamed
endif

""
function! DiffOrig()
    if &diff
        wincmd p | bdel | diffoff
    else
        vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
    endif
endfunction
map <leader>do :call DiffOrig()<cr>

" Folding
set foldmethod=indent
set foldlevelstart=99
]])
