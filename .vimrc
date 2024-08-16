set nocompatible

if has("win32") || has("win16")
        let os="windows"
else 
        let os=system('uname -s')
endif
set backupskip=/tmp/*,/private/tmp/*
""
" My Plugins
" git hosted, run via pack...
" mkdir -p ~/.vim/pack/git-plugins/start
" cd ~/.vim/pack/git-plugins/start
" git clone https://github.com/vimwiki/vimwiki
" git clone https://github.com/mattn/calendar-vim
" git clone https://github.com/scrooloose/nerdtree
" git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git
" git clone https://github.com/scrooloose/nerdcommenter
" git clone https://github.com/vim-scripts/taglist.vim
" git clone https://github.com/tpope/vim-fugitive
" git clone https://github.com/w0rp/ale
" git clone https://github.com/altercation/vim-colors-solarized
" git clone https://github.com/maralla/completor.vim
" git clone https://github.com/airblade/vim-gitgutter
" git clone https://github.com/ctrlpvim/ctrlp.vim
" git clone https://github.com/Yggdroot/indentLine 
" git clone https://github.com/pedrohdz/vim-yaml-folds
" git clone https://github.com/voldikss/vim-floaterm
"
" /plugins
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

""
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
set textwidth=120
""
" Indentline
 let g:indentLine_char = '⦙'
""
" Can be annoying...
"inoremap kj <Esc>
"inoremap jj <Esc>jj
"inoremap kk <Esc>kk
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

syntax enable
if os != "windows"
""
"Solarized color scheme setup...
"needed if terminal not setup correctly.
" let g:solarized_termcolors=256
let g:solarized_termtrans=1
set background=dark
"colorscheme solarized
endif
"
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

"nmap <F10> :qa<CR>

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
map <silent> <F6> :call StripHostName()<CR>
imap <silent> <F6> <C-o><F6>


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
    autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup END



map <leader>cf          :!column -t<CR>
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
        elseif (match( firstLine , '.*python3.*') == 0)
            :RunPy3
        elseif (match( firstLine , '.*python.*') == 0)
            :RunPy
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
        if (match( firstLine , '.*python.*') == 0)
            if tmux
                :TRunPy3
            else
                "echo 'NotinTmux'
                :RunPy3
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

"" tmux needs 'vimux' plugin. Can i check for it dynamically?
"map <leader>e :call CheckForShebangTmux()<cr>
map <leader>e :call CheckForShebang()<cr>
""

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
command!          RunPy              call RunCmdOnFile("`which python` ")
command!          RunPy3             call RunCmdOnFile("`which python3` ")
command!          RunMisc            call RunCmdOnFile("")
command! -nargs=1 TRun               call VimuxRunCommand("clear; " . bufname("%") . <q-args>)
command!          TRunPerl           call VimuxRunCommand("clear; /usr/bin/perl ". bufname("%"))
command!          TRunPy3            call VimuxRunCommand("python3 " . bufname("%"))
command!          TRunMisc           call VimuxRunCommand("clear; " . bufname("%"))
command!          CheckPhp           call RunCmdOnFile("/usr/bin/php -l ")
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

" Folding
set foldmethod=syntax
set foldlevelstart=1
"let g:vimwiki_folding='syntax'
let g:vimwiki_folding='expr'

let javaScript_fold=1         " JavaScript
let perl_fold=1               " Perl
let php_folding=1             " PHP
let r_syntax_folding=1        " R
let ruby_fold=1               " Ruby
let sh_fold_enabled=1         " sh
let vimsyn_folding='af'       " Vim script
let xml_syntax_folding=1      " XML
" vimwiki
 let g:vimwiki_list = [{'auto_toc': 1, 'syntax': 'markdown', 'auto_tags': 1}]
 let g:vimwiki_use_calendar = 1
function! ToggleCalendar()

  execute ":Calendar"
  execute ":set nonumber"
  execute ":set norelativenumber"
  "if exists("g:calendar_open")
    "if g:calendar_open == 1
      "execute "q"
      "unlet g:calendar_open
    "else
      "g:calendar_open = 1
    "end
  "else
    "let g:calendar_open = 1
  "end
endfunction
:autocmd FileType vimwiki map c :call ToggleCalendar()<CR>
 
"Calendar toggle
 ""
 "Ale Config
 let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
 let g:ale_sign_error = '✘'
 let g:ale_sign_warning = '⚠'
 let g:ale_lint_on_text_changed = 'never'

 ""
 " vimspector 
 let g:vimspector_enable_mappings = 'HUMAN'

 " Testing floatterm..
 "let g:floaterm_keymap_new = '<Leader>ft'
 let g:floaterm_keymap_toggle = '<Leader>f'
 let g:floaterm_keymap_new = '<Leader>d'
 let g:floaterm_keymap_next = '<Leader>g'

