set nocompatible
"
if has("win32") || has("win16")
        let os="windows"
else 
        let os=system('uname -s')
endif
set backupskip=/tmp/*,/private/tmp/*
if os != "windows"
    "" . resolve(expand("%:p")) . "&" . resolve(expand("%:p")) . "&"Vundle stuff...
    filetype on 
    filetype off
    set rtp+=~/.vim/vundle.git/
    call vundle#rc()
    let $GIT_SSL_NO_VERIFY = 'true'
    ""
    " My Bundles:
    " "
    " github hosted
    Bundle 'scrooloose/nerdtree.git'
    Bundle 'scrooloose/nerdcommenter.git'
    Bundle 'theevocater/vim-perforce.git'
    "Bundle 'vim-scripts/TeTrIs.vim.git'
    Bundle 'vim-scripts/taglist.vim.git'
    Bundle 'vim-scripts/matchit.zip'
    "Bundle 'fholgado/minibufexpl.vim.git'
    Bundle 'msanders/snipmate.vim.git'
    "Bundle 'Lokaltog/vim-easymotion'
    "Bundle 'chrisbra/NrrwRgn.git'
    Bundle 'vimoutliner/vimoutliner.git'
    "Mac only..
    if os != "Darwin"
        Bundle 'tpope/vim-fugitive'
        Bundle 'rizzatti/funcoo.vim'
        Bundle 'rizzatti/dash.vim'
    endif
    ""
    "Better autocompleting.
    Bundle 'Shougo/neocomplcache.git'
    "Allows async in neocomplcache
    Bundle 'Shougo/vimproc.git'
    ""
    "Perl
    Bundle 'vim-scripts/perl-support.vim.git'
    "color scheme.
    Bundle 'altercation/vim-colors-solarized'
    ""
    "vimux setup
    Bundle 'benmills/vimux.git'
    "For vimux to work over nfs cleanly; disable warnings. Can do this via
    "'VERBOSE=nil' in the ruby code somewhere.
    ""
    "Powerline is pretty.
    "Bundle 'Lokaltog/vim-powerline.git'
    ""
    "for browser.. not working?
    "Bundle 'vim-scripts/browser.vim.git'
    "Bundle 'vim-scripts/synmark.vim.git'
    ""
    "
    "vim-pad crashes me. Why? It looks promising, bug report filed.
    "Bundle 'fmoralesc/vim-pad.git'
    "Bundle 'scrooloose/syntastic.git'
    "Bundle 'vim-scripts/ZoomWin.git'
    "Bundle 'vim-scripts/AutoComplPop.git'
    "Bundle 'kien/ctrlp.vim.git'
    " End my Bundles.
    ""
endif

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
if os != "windows"
""
"For Powerline
"set laststatus=2
"set encoding=utf-8
"set t_Co=256
"let g:Powerline_symbols = 'compatible'
"let g:Powerline_dividers_override = ['>>', '>', '<<', '<']
"call Pl#Theme#InsertSegment('currhigroup', 'after', 'TARGET_SEGMENT')
""
endif
""
"test
"
map <silent> <A-h> <C-w>< 
map <silent> <A-j> <C-W>- 
map <silent> <A-k> <C-W>+ 
map <silent> <A-l> <C-w>> 
""
"Tab!
map <tab> %
silent! unmap [%
silent! unmap ]%
"Move..
"
noremap H ^
noremap L $
vnoremap L g_
let g:NERDTreeDirArrows=0
highlight TrailingWhitespace ctermbg=red  guibg=red
match     TrailingWhitespace /\s\+$/
" key mapping for quick toggling of list characters
nmap <silent> <Leader><Tab> :set list!<Bar>:nohlsearch<Bar>:set list?<CR>
" key mapping to remove trailing whitespace on current line
nmap <Backspace><Backspace> :let _s=@/<Bar>:.s/\s\+$//ge<Bar>:let @/=_s<Bar>:nohlsearch<CR>
"
""
set textwidth=80
inoremap kj <Esc>
inoremap jj <Esc>jj
inoremap kk <Esc>kk
inoremap :wq <Esc>:wq
"set cc=+1
"/test
""

""
"Environ Specific.
autocmd BufRead,BufNewFile *.json     set filetype=json
"thpl as perl mapping.
autocmd BufRead,BufNewFile *.thpl     set filetype=perl
"conf as perl mapping.
autocmd BufRead,BufNewFile *.conf     set filetype=perl
"rs as perl (ccl files)
autocmd BufRead,BufNewFile *.rs     set filetype=perl
"plan as perl
autocmd BufRead,BufNewFile *.plan     set filetype=perl
"stest as perl
autocmd BufRead,BufNewFile *.stest     set filetype=perl
""

:colorscheme torte
syntax enable
if os != "windows"
""
"Solarized color scheme setup...
"needed if terminal not setup correctly.
"let g:solarized_termcolors=256
let g:solarized_termtrans=1
set background=dark
colorscheme solarized
endif
"
":colorscheme desert
"line numbers... {
"Relative line numbers
if (version >= 730)
    :set relativenumber
endif
if has("gui")
    :au FocusLost * :set number
    :au FocusGained * :set relativenumber
else 
    " use an orange cursor in insert mode
    "let &t_SI = "\<Esc>]12;orange\x7"
    "" use a red cursor otherwise
    "let &t_EI = "\<Esc>]12;red\x7"
    "silent !echo -ne "\033]12;red\007"
    " reset cursor when vim exits
    autocmd VimLeave * silent !echo -ne "\033]112\007"
    " use \003]12;gray\007 for gnome-terminal
endif
""
"Toggle
"nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
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
"}
" GUI Settings {
if has("gui")
    set mousehide
    set guioptions=agimrLt
    set guioptions-=r
    set go-=L
"Copy yanked to clipboard
"set go+=a
endif
" }

"if editing a line and ctrl-u
"allows :u to undo just the i_ctrl-u
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u


" To get the File, Open dialog box to default to the current file's directory
set browsedir=buffer

"auto indent
set autoindent

"Tab buffer browsing.
nnoremap <silent><S-h> :bp<CR>
nnoremap <silent><S-l> :bn<CR>


"enables highlighting on search.
"other options: 
"       'is' incremental search
"       'ic' ignore case
set hls

"sets the terminal support.
"set term=xterm
set showmode

"tab expansion$daysBack
set tabstop=4
set smarttab
set shiftwidth=4
set shiftround
set expandtab
set cursorline

"tab completion.
set wildmode=list:longest,full 
set wildmenu
:set wildignore=*.o,*.obj,*.bak,*.exe

"multiple splits
"nmap + <C-W>+
"nmap - <C-W>-
nnoremap <silent> OA <C-W>-
nnoremap <silent> OB <C-W>+
nnoremap <silent> OC <C-W>>
nnoremap <silent> OD <C-W><

"nmap <Up> gk
"nmap <Down> gj

nmap <F10> :qa<CR>

"center...
"nmap <space> zz :set foldcolumn=1
nmap <space> zz
nmap n nzz
nmap N Nzz
"pasteToggle. Toggle before/afte each paste.

set pastetoggle=<F4>

""
"call NERDTree plugin
nmap <F5> :NERDTreeToggle<CR>
nmap <S-F5> :NERDTreeClose<CR>
" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1
""


"Cleanup Junk
map <silent> <F3> :call CleanScript()<CR>
imap <silent> <F3> <C-o><F3>
"map <silent> <F4> :call SplitschedNDISP()<CR>
"imap <silent> <F4> <C-o><F4>
map <silent> <F6> :call StripHostName()<CR>
imap <silent> <F6> <C-o><F6>

if version >= 720
    """
    " Enable AutoComplPop.
    let g:neocomplcache_enable_at_startup = 1
    let g:neocomplcache_use_vimproc = 1
    inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<TAB>"
    inoremap <expr> <C-u> pumvisible() ? neocomplcache#close_popup() : "\<c-u>"
    inoremap <expr> <C-x><C-u> pumvisible() ? \<C-u> : "\<C-u>"
else
    let g:neocomplcache_enable_at_startup = 0
endif

imap <silent> <F9> <C-o><F9>

function! CleanScript()
        :%s///ge
        :%s///ge
        :%s/\[K//ge
        :%s///ge
endf
function! TrimSpaces()
    :'<,'>s/\s\+/ /g
endf

function! SplitschedNDISP()
        :%s/--/--/g
endf
function! StripHostName()
        :'<,'>s/:.*//
endf


function! MyDate()
        let @x = substitute(system("date \"+%A, %B %d %Y\"")."\n","\n"," ", "")
        "let @x = substitute(system("date \"+%A, %B %d %Y\"")."\n   -----------------------------","\n"," ", "")
        normal! "xp
endf

""File type specific...
augroup filters
    autocmd!
    autocmd FileType perl       map <buffer> <leader>tt :!perltidy<CR>
    autocmd FileType perl       map <buffer> <leader>l :CheckPerl<CR>
    autocmd FileType php        map <buffer> <leader>l :CheckPhp<CR>
    autocmd FileType python     map <buffer> <leader>l :CheckPy<CR>
    autocmd FileType python     map <buffer> <leader>tt :!autopep8  --indent-size 4 --aggressive -<CR>
    autocmd FileType javascript map <buffer> <leader>tt :!uglifyjs -b<CR>
    autocmd FileType json       map <buffer> <leader>tt :!python -mjson.tool<CR>
augroup END

map <leader>ct          :!column -t<CR>
map <leader>n           :NERDTreeToggle<CR>
map <leader>t           :Tlist<CR>
map <leader><space>     :nohlsearch <CR>
map <leader><leader>d   :call MyDate()<CR>
""

"fix backspace
:set bs=2

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
"Toggle quickfix.
map <leader>q :QFix<CR>

"View last search results in their own window (Cur file)
nmap <leader>s :vimgrep /<C-R>//j %<CR>:copen<CR><CR>
"View last search results in their own window (Cur dir)
nmap <leader>S :call BufSearch() <cr>
"Trim spaces on selection...
nmap <leader>ts :call TrimSpaces() <cr>


function! BufSearch()
    echo @/
    let g:buflist = ""
    bufdo let g:buflist.=" ".expand("%:p")
    execute "vimgrep /".@/."/j ".g:buflist
    copen
endfunction

" function to delete duplicate lines
function! Del()
        if getline(".") == getline(line(".") - 1)
                norm dd
        endif
endfunction

"quick fix toggle.
command -bang -nargs=? QFix call QFixToggle(<bang>0)
function! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced == 0
        cclose
        unlet g:qfix_win
    else
        copen 10
        let g:qfix_win = bufnr("$")
    endif
endfunction
""
" If we ever work with multiple file types in same shell; comment out the
" remapping of <leader>e
function! CheckForShebang()
    let firstLine= getline(1)
    let fn=@%
    if (match( firstLine , '^\#!') == 0)
        "echo firstLine
        if (match( firstLine , '.*perl.*') == 0)
            "echo "Is perl."
            :RunPerl
        else
            :RunMisc
        endif
    else
        echo "Not executable file."
    endif
endfunction
function! CheckForShebangTmux()
    let firstLine= getline(1)
    let fn=@%
    if !empty($TMUX)
        let tmux=1
    else
        let tmux=0
    endif
    if (match( firstLine , '^\#!') == 0)
        "echo firstLine
        if (match( firstLine , '.*perl.*') == 0)
            "echo "Is perl:".tmux.":"
            if tmux
                :TRunPerl
                "echo 'inTmux'
            else
                "echo 'NotinTmux'
                :RunPerl
            endif
        else
            ":TRunMisc
            if tmux
                :TRunMisc
            else
                :RunMisc
            endif
        endif
    else
        echo "Not executable file."
    endif
endfunction

"map <leader>e :call CheckForShebang()<cr>
"map <leader>e :call CheckForShebangTmux()<cr>
map <leader>e :call CheckForShebang()<cr>
"
"Disable whitespace in vimdiff...
set diffopt+=iwhite
"DiffOrig Mapping.
function! DiffOrig()
    if &diff
        wincmd p | bdel | diffoff
    else
        vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
    endif
endfunction

"DiffP4 Mapping.
function! DiffP4()
    if &diff
        :echo "Already in a diff."
    else
        :!p4 diff %
    endif
endfunction
map <leader>do :call DiffOrig()<cr>
map <leader>dp :call DiffP4()<cr>



"useful.
function! RunCmdOnFile(cmd)
    let fn = expand("%:p")
    let ft = &l:filetype
    botright copen
    setlocal modifiable
    %d _
    silent execute "read !".a:cmd." ".fn
    1d _
    normal! 0
    if ft != ""
        execute "setf ".ft
    else
        setlocal filetype=
    endif
    setlocal nomodifiable nomodified
    wincmd p
endfunction

function! RunCmd(cmd)
    botright copen
    setlocal modifiable
    %d _
    silent execute "read !".a:cmd
    1d _
    normal! 0
    setlocal filetype=
    setlocal nomodifiable nomodified
    wincmd p
endfunction

""
" My Run Functions 
command! -nargs=1 Run                call RunCmdOnFile(<q-args>)
command!          RunPerl            call RunCmdOnFile("/usr/bin/perl ")
command!          RunMisc            call RunCmdOnFile("")
command! -nargs=1 TRun               call VimuxRunCommand("clear; " . bufname("%") . <q-args>)
command!          TRunPerl           call VimuxRunCommand("clear; /usr/bin/perl ". bufname("%"))
command!          TRunMisc           call VimuxRunCommand("clear; " . bufname("%"))
command!          CheckPerl          call RunCmdOnFile("/x/eng/localtest/noarch/share/nate/4/last/bin/natelint ")
command!          CheckPhp           call RunCmdOnFile("/usr/bin/php -l ")
command!          CheckPy            call RunCmdOnFile("/usr/local/bin/pep8 ")
""



""
"{{{
" Highlight Word
"
" This mini-plugin provides a few mappings for highlighting words temporarily.
"
" Sometimes you're looking at a hairy piece of code and would like a certain
" word or two to stand out temporarily.  You can search for it, but that only
" gives you one color of highlighting.  Now you can use <leader>N where N is
" a number from 1-6 to highlight the current word in a specific color.
"   {{{
function! HiInterestingWord(n) 
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction " }}}

" Mappings
"   {{{

nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
nnoremap <silent> <leader>0 :call clearmatches()<cr>

"   }}}
" Default Highlights
"   {{{

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195

"   }}}
" }}}
""

" Testing folding..
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
