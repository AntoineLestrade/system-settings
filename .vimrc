" Switches {{{
let g:enable_powerline     = 0
let g:enable_lightline     = 1
let g:enable_airline       = 0
let g:use_conemu_specifics = 0
let g:use_mswin_vim        = 1
let g:enable_startify      = 1
let g:enable_signify       = 1
let g:enable_orgmode       = 1
let g:enable_beta_textobj  = 1
"}}}

" Environment {{{
" ## Identify platform {{{
silent function! OSX()
    return has('macunix')
endfunction
silent function! LINUX()
    return has('unix') && !has('macunix') && !has('win32unix')
endfunction
silent function! WINDOWS()
    return  (has('win16') || has('win32') || has('win64'))
endfunction
" }}}

" ## Basics {{{
set nocompatible        " Must be first line
if !WINDOWS()
    set shell=/bin/sh
endif
" }}}

let s:vimfiles_dir = $HOME . '/.vim/'

" ## Windows Compatible {{{
" On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
" across (heterogeneous) systems easier.
"if WINDOWS()
    "set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
"          let s:vimfiles_dir = $HOME . '/vimfiles/'
"endif
" }}}

function! GetBundleDir(dir) "{{{
    return (s:vimfiles_dir . 'bundle/' . a:dir)
endfunction " }}}

if g:use_mswin_vim " {{{
" Set options and add mapping such that Vim behaves a lot like MS-Windows
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2012 Jul 25

" bail out if this isn't wanted (mrsvim.vim uses this).



" set the 'cpoptions' to its Vim default
if 1	" only do this when compiled with expression evaluation
  let s:save_cpo = &cpoptions
endif
set cpo&vim

" set 'selection', 'selectmode', 'mousemodel' and 'keymodel' for MS-Windows
behave mswin

" backspace and cursor keys wrap to previous/next line
set backspace=indent,eol,start whichwrap+=<,>,[,]

" backspace in Visual mode deletes selection
vnoremap <BS> d

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x

" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y

" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP

cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+

" Pasting blockwise and linewise selections is not possible in Insert and
" Visual mode without the +virtualedit feature.  They are pasted as if they
" were characterwise instead.
" Uses the paste.vim autoload script.
" Use CTRL-G u to have CTRL-Z only undo the paste.

exe 'inoremap <script> <C-V> <C-G>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <C-V> ' . paste#paste_cmd['v']

imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>

" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

" Use CTRL-S for saving, also in Insert mode
noremap <C-S>		:update<CR>
vnoremap <C-S>		<C-C>:update<CR>
inoremap <C-S>		<C-O>:update<CR>

" For CTRL-V to work autoselect must be off.
" On Unix we have two selections, autoselect can be used.
if !has("unix")
  set guioptions-=a
endif

" CTRL-Z is Undo; not in cmdline though
noremap <C-Z> u
inoremap <C-Z> <C-O>u

" CTRL-Y is Redo (although not repeat); not in cmdline though
"noremap <C-Y> <C-R>
"inoremap <C-Y> <C-O><C-R>

" Alt-Space is System menu
if has("gui")
  noremap <M-Space> :simalt ~<CR>
  inoremap <M-Space> <C-O>:simalt ~<CR>
  cnoremap <M-Space> <C-C>:simalt ~<CR>
endif

" CTRL-A is Select all
noremap <C-A> gggH<C-O>G
inoremap <C-A> <C-O>gg<C-O>gH<C-O>G
cnoremap <C-A> <C-C>gggH<C-O>G
onoremap <C-A> <C-C>gggH<C-O>G
snoremap <C-A> <C-C>gggH<C-O>G
xnoremap <C-A> <C-C>ggVG

" CTRL-Tab is Next window
noremap <C-Tab> <C-W>w
inoremap <C-Tab> <C-O><C-W>w
cnoremap <C-Tab> <C-C><C-W>w
onoremap <C-Tab> <C-C><C-W>w

" CTRL-F4 is Close window
noremap <C-F4> <C-W>c
inoremap <C-F4> <C-O><C-W>c
cnoremap <C-F4> <C-C><C-W>c
onoremap <C-F4> <C-C><C-W>c

" restore 'cpoptions'
set cpo&
if 1
  let &cpoptions = s:save_cpo
  unlet s:save_cpo
endif
endif
" }}}

" ## ConEmu specifics {{{
if g:use_conemu_specifics && !empty($CONEMUBUILD)
    echom "Running in conemu"
    set termencoding=utf8
    set term=xterm
    set t_Co=256
    "let &t_AB="\e[48;5;%dm"
    "let &t_AF="\e[38;5;%dm"
    " termcap codes for cursor shape changes on entry and exit to
    " /from insert mode
    " doesn't work
    "let &t_ti="\e[1 q"
    "let &t_SI="\e[5 q"
    "let &t_EI="\e[1 q"
    "let &t_te="\e[0 q"
endif
" }}}

" }}}

if filereadable(expand("~/_vimrc.local_before"))
    source ~/_vimrc.local_before
endif

" NeoBundle {{{====================
" ## AutoInstall {{{
if !filereadable(s:vimfiles_dir.'bundle/neobundle.vim/README.md')
    echon 'Installing NeoBundle...'
    "  silent execute '
    if !isdirectory(s:vimfiles_dir.'bundle')
        call mkdir(s:vimfiles_dir.'bundle')
    endif
    silent execute '!git clone https://github.com/Shougo/neobundle.vim ' .s:vimfiles_dir.'bundle/neobundle.vim'
endif
" }}}
filetype off
execute 'set runtimepath+='.s:vimfiles_dir.'bundle/neobundle.vim'

call neobundle#begin(expand(s:vimfiles_dir.'bundle'))

function! s:load_bundles() " {{{
NeoBundleFetch 'Shougo/neobundle.vim'

" ## Unite / Library {{{
NeoBundleLazy 'Shougo/unite.vim', {
                \ 'depends': ['Shougo/vimproc'],
                \ 'autoload': {
                \   'commands':[
                \       { 'name': 'Unite', 'complete': 'customlist,unite#complete_source' },
                \       'UniteWithCursorWord',
                \       'UniteWithInput',
                \       'UniteWithBufferDir'
                \   ]
                \ }
                \ }
NeoBundle 'Shougo/vimproc',  { 'build': {
    \   'windows': 'mingw32-make -f make_mingw32.mak',
    \   'cygwin': 'make -f make_cygwin.mak',
    \   'mac': 'make -f make_mac.mak',
    \   'unix': 'make -f make_unix.mak',
    \ } }
NeoBundleLazy 'Shougo/vimshell.vim', {
        \   'depends': ['Shougo/vimproc'],
        \   'autoload' : {
        \       'commands' : [
        \       { 'name' : 'VimShell',
        \         'complete' : 'customlist,vimshell#complete'},
        \       { 'name' : 'VimShellTab',
        \         'complete' : 'customlist,vimshell#complete'},
        \       { 'name' : 'VimShellBufferDir',
        \         'complete' : 'customlist,vimshell#complete'},
        \       { 'name' : 'VimShellCreate',
        \         'complete' : 'customlist,vimshell#complete'},
        \         'VimShellExecute', 'VimShellInteractive',
        \         'VimShellTerminal', 'VimShellPop'],
        \   }
        \ }
" vim-quickrun/quickrun {{{
"   vim-precious dependency
NeoBundleLazy 'thinca/vim-quickrun'
" }}}
" Shougo/context_filetype.vim {{{
"   -> vim-precious dependency
NeoBundleLazy 'Shougo/context_filetype.vim'
" }}}
" }}}

" ## UI {{{
" NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'nanotech/jellybeans.vim'
" #### bling/vim-airline {{{
if g:enable_powerline && has('python')
    NeoBundle 'Lokaltog/powerline'
elseif g:enable_lightline
    " A pretty statusline, bufferline integration
    NeoBundle 'itchyny/lightline.vim'
    NeoBundle 'bling/vim-bufferline'
elseif g:enable_airline
    NeoBundle 'bling/vim-airline', {'gui': 1, 'terminal': 0 } " Powerline replacement
endif
" }}}
" NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'Yggdroot/indentLine'
" }}}

" ## File management {{{{
" #### scrooloose/nerdtree {{{
NeoBundleLazy 'scrooloose/nerdtree', {
            \ 'autoload': {
            \       'commands': 'NERDTreeToggle',
            \ }
            \}
" }}}
" #### jistr/vim-nerdtree-tabs {{{
"NeoBundleLazy 'jistr/vim-nerdtree-tabs', {
"            \ 'depends': 'scrooloose/nerdtree',
"            \ 'autoload': {
"            \       'commands': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeTabsToggle' ],
"            \       'mappings': '<Plug>NERDTreeTabsToggle'
"            \   }
"            \ }
" }}}
" #### kien/ctrlp.vim {{{
NeoBundleLazy 'kien/ctrlp.vim', {
            \ 'autoload': {
            \       'commands': ['CtrlP']
            \   }
            \ }
" }}}
" #### tacahiroy/ctrlp-funky {{{
NeoBundleLazy 'tacahiroy/ctrlp-funky', {
            \ 'depends': 'kien/ctrlp.vim',
            \ 'autoload': {
            \       'commands': 'CtrlPFunky'
            \   }
            \ }
" }}}
" }}}

" ## Vim enhancements {{{
NeoBundle 'matchit.zip'
" NeoBundle 'osyo-manga/vim-anzu'
" }}}

    " ## Motion {{{
    " #### Lokaltog/vim-easymotion {{{
    NeoBundleLazy 'Lokaltog/vim-easymotion', {
                \ 'autoload' : {
                \       'mappings' : [['sxno', '<Plug>(easymotion-']],
                \       'functions' : [
                \              'EasyMotion#User',
                \               'EasyMotion#JK',
                \               'EasyMotion#is_active',
                \       ],
                \   }
                \ }
    " }}}
    " #### rhysd/clever-f.vim {{{
    NeoBundleLazy 'rhysd/clever-f.vim', {
                \   'autoload': {
                \           'mappings': [['sxno', '<Plug>(clever-f-']]
                \   }
                \ }
    " }}}
    " #### rhysd/accelerated-jk {{{
    NeoBundleLazy 'rhysd/accelerated-jk', {
                \ 'autoload': {
                \       'mappings': [['sxno', '<Plug>(accelerated_jk_']]
                \       }
                \ }
    " }}}
    " }}}

" ## Text objects {{{
" Create custom test object (dependency)
NeoBundleLazy 'kana/vim-textobj-user'
" kana/vim-textobj-entire {{{
" text objects to select entire buffer content
" default ae;
" ie -> without leading and trailing empty lines
NeoBundleLazy 'kana/vim-textobj-entire', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'ae'], ['xo', 'ie']]
            \    }
            \} " }}}
" kana/vim-textobj-fold {{{
" text objects for folding (az, iz)
NeoBundleLazy 'kana/vim-textobj-fold', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'az'], ['xo', 'iz']]
            \ }
            \} " }}}
" kana/vim-textobj-indent {{{
" Text objects for indented block of lines (ai, ii)
NeoBundleLazy 'kana/vim-textobj-indent', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'ai'], ['xo', 'ii']]
            \ }
            \} " }}}
" kana/vim-textobj-line {{{
" Text objects for the current line (al, il)
NeoBundleLazy 'kana/vim-textobj-line', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'al'], ['xo', 'il']]
            \ }
            \} " }}}
" kana/vim-textobj-syntax {{{
" Text objects for syntax highlighted items (ay, iy)
NeoBundleLazy 'kana/vim-textobj-syntax', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'ay'], ['xo', 'iy']]
            \ }
            \} " }}}
" NeoBundleLazy 'kana/vim-textobj-django-template'  " adb, idb
" thinca/vim-textobj-between {{{
" Text objects for a range between a character
"       af{char} (including {char})
"       if{char} (excluding {char})
NeoBundleLazy 'thinca/vim-textobj-between', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'af'], ['xo', 'if'], ['xo', '<Plug>(textobj-between-']]
            \ }
            \} " }}}
" mattn/vim-textobj-url {{{
" au, iu
NeoBundleLazy 'mattn/vim-textobj-url', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'au'], ['xo', 'iu']]
            \ }
            \} " }}}
" NeoBundleLazy 'osyo-manga/vim-textobj-multiblock' " ab, ib
" lucapette/vim-textobj-underscore {{{
" https://github.com/lucapette/vim-textobj-underscore
" a_, i_
NeoBundleLazy 'lucapette/vim-textobj-underscore', {
            \ 'depends': 'kana/vim-textobj-user',
            \ 'autoload': {
            \       'mappings': [['xo', 'a_'], ['xo', 'i_']]
            \ }
            \} " }}}
" haya14busa/vim-textobj-number {{{
 " an, in
NeoBundleLazy 'haya14busa/vim-textobj-number', {
            \ 'depends' : 'kana/vim-textobj-user',
            \ 'autoload' : {
            \       'mappings' : [['xo', 'an'], ['xo', 'in']]
            \   }
            \ } " }}}
" NeoBundleLazy 'h1mesuke/textobj-wiw'              " a,w a,e

NeoBundle 'wellle/targets.vim'
" NeoBundle 'gcmt/wildfire.vim'

" NeoBundle 'tpope/vim-repeat'
" NeoBundle     'tpope/vim-surround'

" Operator
NeoBundleLazy 'kana/vim-operator-user' " dependency
" kana/vim-operator-replace {{{
NeoBundleLazy 'kana/vim-operator-replace', {
            \ 'depends': 'kana/vim-operator-user',
            \ 'autoload': {
            \       'mappings': '<Plug>(operator-replace)'
            \   }
            \}
" }}}
" rhysd/vim-operator-surround {{{
NeoBundleLazy 'rhysd/vim-operator-surround', {
            \ 'depends': 'kana/vim-operator-user',
            \ 'autoload': {
            \       'mappings': [
            \           '<Plug>(operator-surround-append)',
            \           '<Plug>(operator-surround-delete)',
            \           '<Plug>(operator-surround-replace)'
            \       ]
            \   }
            \}
" }}}
" }}}

" ## General / Text edition {{{
NeoBundle 'Townk/vim-autoclose' " replace by 'spf13/vim-autoclose' ?
" }}}

" ## General {{{
" NeoBundle 'vim-scripts/sessionman.vim'

NeoBundleLazy 'mbbill/undotree'
NeoBundle 'vim-scripts/Conque-Shell' "Shell integration
NeoBundle 'vim-scripts/DirDiff.vim' " Perform recursive diff on two directories http://www.vim.org/scripts/script.php?script_id=102
NeoBundle 'dterei/VimBookmarking' "Default keymapping: <F3> :ToggleBookmark; <F4> :PreviousBookmark; <F5> :NextBookmark
if g:enable_startify
    NeoBundle 'mhinz/vim-startify'
endif

if g:enable_orgmode
    NeoBundle 'hsitz/VimOrganizer'
    "NeoBundle 'jceb/vim-orgmode'
    NeoBundle 'xolox/vim-misc' " Vim-shell dependency
    NeoBundle 'xolox/vim-shell'
    NeoBundle 'chrisbra/NrrwRgn'
endif
" }}}


" ## Development - General {{{
NeoBundle 'scrooloose/syntastic' "Enhanced syntax checker, Required external programs (see https://github.com/scrooloose/syntastic)
if g:enable_signify
    NeoBundle 'mhinz/vim-signify'
endif
NeoBundle 'tpope/vim-git' " Included are syntax, indent, and filetype plugin files for git, gitcommit, gitconfig, gitrebase, and gitsendemail
NeoBundle 'tpope/vim-fugitive' " Git
NeoBundleLazy 'gregsexton/gitv', { 'depends': ['tpope/vim-fugitive'], 'autoload': { 'commands': ['Gitv'] } }
NeoBundle 'scrooloose/nerdcommenter'
NeoBundleLazy 'godlygeek/tabular', { 'autoload': { 'commands': ['Tabularize']} }
"if executable('ctags')
NeoBundle 'majutsushi/tagbar', { 'autoload': { 'commands': ['TagbarToggle'] } }
"endif
" }}}

" ## Web development {{{
" mattn/emmet-vim {{{ Html enhancements
NeoBundleLazy 'mattn/emmet-vim',{
        \   'autoload': {
        \       'filetypes': [
        \           'html',
        \           'cshtml',
        \           'xhttml',
        \           'css',
        \           'sass',
        \           'scss',
        \           'styl',
        \           'xml',
        \           'xls',
        \           'markdown',
        \           'htmldjango',
        \       ]
        \   },
        \} " }}}
    NeoBundle 'gregsexton/MatchTag' "Highlight matching tags | may I use matchit.zip
    NeoBundle 'hail2u/vim-css3-syntax'
    NeoBundle 'groenewege/vim-less'
    NeoBundle 'gorodinskiy/vim-coloresque'
    NeoBundle 'tpope/vim-haml'
    " #### Javascript {{{
    NeoBundleLazy 'osyo-manga/vim-precious', {
                \   'depends': ['thinca/vim-quickrun', 'kana/vim-textobj-user', 'Shougo/context_filetype.vim'],
                \   'autoload': {
                \       'filetypes': ['javascript', 'html' ]
                \   }
                \ }
    NeoBundleLazy 'pangloss/vim-javascript', {
                \   'autoload': {
                \       'filetypes': ['javascript', 'html' ]
                \   }
                \ }
    " }}}
    " }}}


" ## MS Technologies dev {{{
NeoBundle 'PProvost/vim-ps1'
NeoBundle 'OrangeT/vim-csharp' " CSharp enhancements (including razor syntax, compilation)
" }}}
endfunction " }}}
"""" TOTEST  {{{
if 0
    " General {
        if count(g:spf13_bundle_groups, 'general')
            Bundle 'altercation/vim-colors-solarized'
            Bundle 'spf13/vim-colors'
            Bundle 'terryma/vim-multiple-cursors'

            if !exists('g:spf13_no_views')
                Bundle 'vim-scripts/restore_view.vim'
            endif
            Bundle 'tpope/vim-abolish.git'
            Bundle 'osyo-manga/vim-over'
            Bundle 'kana/vim-textobj-user'
            Bundle 'kana/vim-textobj-indent'
            Bundle 'gcmt/wildfire.vim'
        endif
    " }

    " Writing {
            Bundle 'reedes/vim-litecorrect'
            Bundle 'reedes/vim-textobj-sentence'
            Bundle 'reedes/vim-textobj-quote'
            Bundle 'reedes/vim-wordy'
    " }


    " General Programming {
            Bundle 'mattn/webapi-vim'
            Bundle 'mattn/gist-vim'
            Bundle 'tpope/vim-commentary' "to replace nerdcommenter?
    " }
    "
    "
    "
    " Snippets & AutoComplete {
        if count(g:spf13_bundle_groups, 'snipmate')
            Bundle 'garbas/vim-snipmate'
            Bundle 'honza/vim-snippets'
            " Source support_function.vim to support vim-snippets.
            if filereadable(expand("~/.vim/bundle/vim-snippets/snippets/support_functions.vim"))
                source ~/.vim/bundle/vim-snippets/snippets/support_functions.vim
            endif
        elseif count(g:spf13_bundle_groups, 'youcompleteme')
            Bundle 'Valloric/YouCompleteMe'
            Bundle 'SirVer/ultisnips'
            Bundle 'honza/vim-snippets'
        elseif count(g:spf13_bundle_groups, 'neocomplcache')
            Bundle 'Shougo/neocomplcache'
            Bundle 'Shougo/neosnippet'
            Bundle 'Shougo/neosnippet-snippets'
            Bundle 'honza/vim-snippets'
        elseif count(g:spf13_bundle_groups, 'neocomplete')
            Bundle 'Shougo/neocomplete.vim.git'
            Bundle 'Shougo/neosnippet'
            Bundle 'Shougo/neosnippet-snippets'
            Bundle 'honza/vim-snippets'
        endif
    " }

    " Javascript {
        if count(g:spf13_bundle_groups, 'javascript')
            Bundle 'elzr/vim-json'
            Bundle 'pangloss/vim-javascript'
            Bundle 'briancollins/vim-jst'
            Bundle 'kchmck/vim-coffee-script'
        endif
    " }

    " HTML {
        if count(g:spf13_bundle_groups, 'html')
            Bundle 'amirh/HTML-AutoCloseTag'
        endif
    " }

    " Edit files using sudo/su
    Plugin 'chrisbra/SudoEdit.vim'

    " <Tab> everything!
    Plugin 'ervandew/supertab'

    " Super easy commenting, toggle comments etc
    Plugin 'scrooloose/nerdcommenter'

    " Autoclose (, " etc
    Plugin 'Townk/vim-autoclose'

    " Handle surround chars like ''
    Plugin 'tpope/vim-surround'

    " Align your = etc.
    Plugin 'vim-scripts/Align'

    " Snippets like textmate
    Plugin 'MarcWeber/vim-addon-mw-utils'
    Plugin 'tomtom/tlib_vim'
    Plugin 'honza/vim-snippets'
    Plugin 'garbas/vim-snipmate'

    " A fancy start screen, shows MRU etc.
    Plugin 'mhinz/vim-startify'

    " Awesome syntax checker.
    " REQUIREMENTS: See :h syntastic-intro
    Plugin 'scrooloose/syntastic'

    " Functions, class data etc.
    " REQUIREMENTS: (exuberant)-ctags
    Plugin 'majutsushi/tagbar'

endif
"}}}

if neobundle#has_cache()
    NeoBundleLoadCache
else
    call s:load_bundles()
    NeoBundleSaveCache
endif

call neobundle#end()
" END Plugin}}}

" Vim Setup {{{========================
filetype plugin indent on

" ## Basic Options {{{
set autoread                   " Automatically read file again which has been changed outside of Vim
set background=dark            " Assume a dark backround
set backspace=indent,eol,start " Working of <BS>,<Del>,CTRL-W,CTRL-U
set hidden                     " Display another buffer when current buffer isn't saved.
set history=1000               " Store a ton of history (default is 20)
set linebreak                  " Vim will wrap long lines at a character in 'breakat'
"set list
"set listchars=tab:›\ ,trail:•,extends:#,nbsp:.                      " Highlight problematic whitespace
set mouse=a                    " Automatically enable mouse usage
set mousehide                  " Hide the mouse cursor while typing
set ruler                      " Show the line and column number of the cursor position
set scrolloff=3                " Lines above/below cursor
set splitright                 " Puts new vsplit windows to the right of the current
set splitbelow                 " Puts new split windows to the bottom of the current
set virtualedit=block          " Allow virtual editing in Visual block mode
"}}}

" ## Clipboard {{{
if has('clipboard')
    if has('unnamedplus')  " When possible use + register for copy-paste
        set clipboard=unnamed,unnamedplus
    else         " On mac and Windows, use * register for copy-paste
        set clipboard=unnamed
    endif
endif
" }}}

" ## Encoding {{{
set encoding=utf-8
set termencoding=utf-8
"}}}

" ## Tab Basic Settings {{{
set autoindent        " Copy indent from current line when starting a new line
set expandtab         " Use the appropriate number of spaces to insert a <Tab>
set shiftround        " Round indent to multiple of 'shiftwidth'
set shiftwidth=4      " Number of spaces to use for each step of (auto)indent
set softtabstop=4     " Number of spaces that a <Tab> counts for while editing operations
set tabstop=4         " Number of spaces that a <Tab> in the file counts for

set pastetoggle=<F12> " pastetoggle (sane indentation on pastes)
"}}}

" ## Folding {{{
"set foldcolumn=0
set foldlevelstart=99
" }}}

" ## Matching {{{
set matchtime=2
set matchpairs+=<:>
set showmatch
" }}}

" ## Search Basic Settings {{{
set incsearch  " Incremental searching
set ignorecase " Ignore case in search patterns
set smartcase  " Override the ignorecase option if the pattern contains upper case
set hlsearch   " Highlight search patterns, support reloading
"}}}

" ## Backup Settings {{{
set backup
"}}}

" ## Undo Basic {{{
if has('persistent_undo')
    set undofile "Automatically saves undo history
    set undolevels=1000
    set undoreload=1000 "Save the whole buffer for undo when reloading it
endif
"}}}

" ## Wildmenu {{{
set wildmenu
set wildmode=longest:full,full
"}}}

" ## Cursor position when opening a file {{{
" Instead of reverting the cursor to the last position in the buffer, we
" set it to the first line when editing a git commit message
au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

function! ResCur()
    if line("'\"") <= line("$")
        normal! g`"
        return 1
    endif
endfunction

augroup resCur
    autocmd!
    autocmd BufWinEnter * call ResCur()
augroup END
" }}}
" END Vim Setup }}}

" Key mapping {{{======================
" Remap <leader>
let mapleader=","

map Q gq

" ## Buffers {{{
" Buffers, preferred over tabs now with bufferline. Buggy?
nnoremap gn :bNext<CR>
"noremap <A-n> :bnext<CR>
"noremap <A-p> :bprevious<CR>
nnoremap gN :bprevious<CR>
nnoremap gd :bdelete<CR>
nnoremap gf <C-^>
" }}}

" ## Code folding options {{{
nmap <leader>f0 :set foldlevel=0<CR>
nmap <leader>f1 :set foldlevel=1<CR>
nmap <leader>f2 :set foldlevel=2<CR>
nmap <leader>f3 :set foldlevel=3<CR>
nmap <leader>f4 :set foldlevel=4<CR>
nmap <leader>f5 :set foldlevel=5<CR>
nmap <leader>f6 :set foldlevel=6<CR>
nmap <leader>f7 :set foldlevel=7<CR>
nmap <leader>f8 :set foldlevel=8<CR>
nmap <leader>f9 :set foldlevel=9<CR>
" }}}

" Use <C-L> to clear the highlighting of :set hlsearch.
"if maparg('<C-L>', 'n') ==# ''
  "nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
  "nmap <silent> <leader>/ :set invhlsearch<CR>
nmap <silent> <leader>/ :nohlsearch<CR><C-L>
"endif

" Delete without saving in register {{{
nmap <Del> "_dl
" }}}

" Visual shifting (does not exit Visual mode) {{{
vnoremap < <gv
vnoremap > >gv
"}}}

" Highlight End-of-Line {{{
function! s:hl_trailing_spaces() "{{{
    highlight! link TrailingSpaces Error
    syntax match TrailingSpaces containedin=ALL /\s\+$/
endfunction "}}}

autocmd BufWinEnter,ColorScheme * call s:hl_trailing_spaces()

function! s:remove_trailing_white_spaces()
    let pos = winsaveview()
    execute '%s/\s\+$//g'
    call winrestview(pos)
endfunction
command! RemoveTrailingWhiteSpaces call <SID>remove_trailing_white_spaces()
command! -range=% TrimSpace  <line1>,<line2>s!\s*$!!g | nohlsearch
" remove trail ^M
command! -range=% RemoveTrailM  <line1>,<line2>s!\r$!!g | nohlsearch
"}}}

"}}}

" Filetypes {{{========================
autocmd FileType vim setlocal foldmethod=marker
autocmd FileType less setlocal foldmethod=marker foldmarker={,}
" }}}

" GVim Settings {{{====================
if has('gui_running')
    set guifont=DejaVu_Sans_Mono_for_Powerline
    set guioptions-=m
    set guioptions-=T
endif
"}}}

" Colorscheme {{{======================
if has('vim_starting')
    "syntax enable
    syntax on
    set background=dark
    set t_Co=256
    if &t_Co < 256 || !has('gui')
        colorscheme default
    else
        try
            colorscheme jellybeans
        catch
            colorscheme darkblue
        endtry
    endif
endif
"}}}

" Plugins configuration {{{============

" ## Unite / Library {{{
" #### Shougo/unite.vim {{{
if neobundle#tap('unite.vim')
    function! neobundle#tapped.hooks.on_post_source(bundle)
        NeoBundleSource unite-action-vimfiler_lcd
    endfunction

    " Settings {{{
     function! neobundle#tapped.hooks.on_source(bundle) "{{{
        " Disable
        let g:unite_source_history_yank_enable = 0

        let g:unite_kind_jump_list_after_jump_scroll=0
        let g:unite_enable_start_insert = 1
        let g:unite_source_rec_min_cache_files = 1000
        let g:unite_source_rec_max_cache_files = 5000
        let g:unite_source_file_mru_long_limit = 6000
        let g:unite_source_file_mru_limit = 500
        let g:unite_source_directory_mru_long_limit = 6000
        let g:unite_prompt = '? '
        let g:unite_winheight = 25
        " Open plugin directory by t
        call unite#custom#alias('directory', 'tabopen', 'tabvimfiler')

        " Fuzzy find
        call unite#filters#matcher_default#use(['matcher_fuzzy'])
        call unite#filters#sorter_default#use(['sorter_rank'])

        call unite#custom#default_action('directory', 'vimshell')
        call unite#custom#default_action('cdable', 'vimshell')

        call unite#custom#source(
                    \   'file_mru', 'matchers',
                    \   ['matcher_project_files', 'matcher_fuzzy'])

        " Ignore pattens
        call unite#custom#source(
            \ 'file_rec,file_rec/async,file_rec/git,file_mru,file,buffer,grep',
            \ 'ignore_pattern', join([
            \ '\.swp', '\.swo', '\~$',
            \ '\.git/', '\.svn/', '\.hg/',
            \ '\.ropeproject/',
            \ 'node_modules/', 'log/', 'tmp/', 'obj/',
            \ '/vendor/gems/', '/vendor/cache/', '\.bundle/', '\.sass-cache/',
            \ '/tmp/cache/assets/.*/sprockets/', '/tmp/cache/assets/.*/sass/',
            \ '\.pyc$', '\.class$', '\.jar$',
            \ '\.jpg$', '\.jpeg$', '\.bmp$', '\.png$', '\.gif$',
            \ '\.o$', '\.out$', '\.obj$', '\.rbc$', '\.rbo$', '\.gem$',
            \ '\.zip$', '\.tar\.gz$', '\.tar\.bz2$', '\.rar$', '\.tar\.xz$',
            \ '\.doc$', '\.docx$',
            \ 'target/',
            \ ], '\|'))

        autocmd FileType unite call s:unite_settings()
        function! s:unite_settings() " {{{
            imap <silent><buffer> <C-j> <Plug>(unite_select_next_line)
            imap <silent><buffer> <C-k> <Plug>(unite_select_previous_line)

            imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
            imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')

            nmap <buffer> <ESC> <Plug>(unite_exit)
            nmap <buffer> q <Plug>(unite_exit)

            imap <buffer>  jj      <Plug>(unite_insert_leave)

            let unite = unite#get_current_unite()
            if unite.profile_name ==# '^search'
                nnoremap <silent><buffer><expr> r unite#do_action('replace')
            else
                nnoremap <silent><buffer><expr> r unite#do_action('rename')
            endif

        endfunction "}}}
    endfunction " }}}
    " }}}

    " Unite {{{
    nnoremap [unite] <Nop>
    xnoremap [unite] <Nop>
    nmap \ [unite]
    xmap \ [unite]

    " Source
    nnoremap <silent> [unite]u :<C-u>Unite source -vertical -silent -start-insert<CR>
    " Buffer
    nnoremap <silent> [unite]b :<C-u>Unite -silent buffer file_mru bookmark<CR>
    " File List
    nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -silent -buffer-name=files file<CR>
    " Register List
    nnoremap <silent> [unite]R :<C-u>Unite -silent -buffer-name=register register<CR>
    " Restore Unite
    nnoremap <silent> [unite]r         :<C-u>UniteResume<CR>
    " Yank History
    let g:unite_source_history_yank_enable = 1
    nnoremap <silent> [unite]y :<C-u>Unite -silent history/yank<CR>
    " Show Mapping List
    nnoremap <silent> [unite]ma :<C-u>Unite -silent mapping<CR>
    " Show Message
    nnoremap <silent> [unite]me :<C-u>Unite -silent output:message<CR>
    " Jump (mnemonic : <C-o> jump to Older cursor position)
    nnoremap <silent> [unite]<C-o> :<C-u>Unite -silent change jump<CR>
    " Grep
    nnoremap <silent> [unite]gr :<C-u>Unite -silent -no-quit grep:.<CR>
    " Line
    nnoremap <silent> g/ :<C-u>Unite -buffer-name=search line -start-insert -no-quit<CR>
    "-Unite Plugin Settings--------------"{{{
    " Execute help.
    nnoremap <silent> [unite]gh  :<C-u>Unite -silent -start-insert -buffer-name=help help<CR>
    " Outeline
    " nnoremap <silent> [unite]o :<C-u>Unite -silent outline -vertical -winwidth=40 -no-start-insert<CR>
    " Use outline like explorer
    nnoremap <silent> [unite]o :<C-u>Unite
                \ -no-quit -keep-focus -no-start-insert
                \ -vertical -direction=botright -winwidth=40 outline<CR>
    " Fold
    nnoremap <silent> [unite]z :<C-u>Unite -silent fold -vertical -winwidth=40 -no-start-insert<CR>
    " Unite Beautiful Atack
    nnoremap <silent> [unite]C :<C-u>Unite -auto-preview colorscheme<CR>
    " Git repository
    nnoremap <silent> [unite]<Space> :<C-u>Unite file_rec/async:! -start-insert<CR>
    nnoremap <silent> <Space><Space> :<C-u>Unite file_rec/git -start-insert<CR>
    "}}}
    "}}}

    call neobundle#untap()
endif
" }}}
" #### Vimproc {{{

" }}}
" #### Vimshell {{{
if neobundle#tap('vimshell.vim')
    function! neobundle#tapped.hooks.on_source(bundle)
        " Use current directory as vimshell prompt.
        let g:vimshell_prompt_expr =
                    \ 'escape(fnamemodify(getcwd(), ":~").">", "\\[]()?! ")." "'
        let g:vimshell_prompt_pattern = '^\%(\f\|\\.\)\+> '
       " let g:vimshell_right_prompt = 'vcs#info("(%s)-[%b]%p", "(%s)-[%b|%a]%p")'
    endfunction

    call neobundle#untap()
endif
" }}}
" }}}

" ## UI {{{
" #### Powerline {{{
if g:enable_powerline
    " Always show the statusline
    set laststatus=2
    " No need to show mode
    set noshowmode
    execute 'set rtp+='.s:vimfiles_dir.'bundle/powerline/powerline/bindings/vim'
endif
" }}}
" #### Lightline {{{
if g:enable_lightline && neobundle#tap('lightline.vim')
    set laststatus=2
    set noshowmode

    " {{{
    let g:lightline = {
                \ 'colorscheme': 'jellybeans',
                \ 'active': {
                \     'left': [
                \         ['mode', 'paste'],
                \         ['readonly', 'fugitive'],
                \         ['ctrlpmark', 'bufferline']
                \     ],
                \     'right': [
                \         ['lineinfo'],
                \         ['percent'],
                \         ['fileformat', 'fileencoding', 'filetype', 'syntastic']
                \     ]
                \ },
                \ 'component': {
                \     'paste': '%{&paste?"!":""}'
                \ },
                \ 'component_function': {
                \     'mode'         : 'MyMode',
                \     'fugitive'     : 'MyFugitive',
                \     'readonly'     : 'MyReadonly',
                \     'ctrlpmark'    : 'CtrlPMark',
                \     'bufferline'   : 'MyBufferline',
                \     'fileformat'   : 'MyFileformat',
                \     'fileencoding' : 'MyFileencoding',
                \     'filetype'     : 'MyFiletype'
                \ },
                \ 'component_expand': {
                \     'syntastic': 'SyntasticStatuslineFlag',
                \ },
                \ 'component_type': {
                \     'syntastic': 'middle',
                \ },
                \ 'subseparator': {
                \     'left': '|', 'right': '|'
                \ }
                \ }
    " }}}
    " {{{
    let g:lightline.mode_map = {
                \ 'n'      : ' N ',
                \ 'i'      : ' I ',
                \ 'R'      : ' R ',
                \ 'v'      : ' V ',
                \ 'V'      : 'V-L',
                \ 'c'      : ' C ',
                \ "\<C-v>" : 'V-B',
                \ 's'      : ' S ',
                \ 'S'      : 'S-L',
                \ "\<C-s>" : 'S-B',
                \ '?'      : '      ' } " }}}

    function! MyMode() " {{{
        let fname = expand('%:t')
        return fname == '__Tagbar__' ? 'Tagbar' :
                    \ fname == 'ControlP' ? 'CtrlP' :
                    \ winwidth('.') > 60 ? lightline#mode() : ''
    endfunction " }}}

    function! MyFugitive() " {{{
        try
            if expand('%:t') !~? 'Tagbar' && exists('*fugitive#head')
                let mark = '± '
                let _ = fugitive#head()
                return strlen(_) ? mark._ : ''
            endif
        catch
        endtry
        return ''
    endfunction " }}}

    function! MyReadonly() " {{{
        return &ft !~? 'help' && &readonly ? '≠' : '' " or ⭤
    endfunction " }}}

    function! CtrlPMark() " {{{
        if expand('%:t') =~ 'ControlP'
            call lightline#link('iR'[g:lightline.ctrlp_regex])
            return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
                        \ , g:lightline.ctrlp_next], 0)
        else
            return ''
        endif
    endfunction " }}}

    function! MyBufferline() " {{{
        call bufferline#refresh_status()
        let b = g:bufferline_status_info.before
        let c = g:bufferline_status_info.current
        let a = g:bufferline_status_info.after
        let alen = strlen(a)
        let blen = strlen(b)
        let clen = strlen(c)
        let w = winwidth(0) * 4 / 11
        if w < alen+blen+clen
            let whalf = (w - strlen(c)) / 2
            let aa = alen > whalf && blen > whalf ? a[:whalf] : alen + blen < w - clen || alen < whalf ? a : a[:(w - clen - blen)]
            let bb = alen > whalf && blen > whalf ? b[-(whalf):] : alen + blen < w - clen || blen < whalf ? b : b[-(w - clen - alen):]
            return (strlen(bb) < strlen(b) ? '...' : '') . bb . c . aa . (strlen(aa) < strlen(a) ? '...' : '')
        else
            return b . c . a
        endif
    endfunction " }}}

    function! MyFileformat() " {{{
        return winwidth('.') > 90 ? &fileformat : ''
    endfunction " }}}

    function! MyFileencoding() " {{{
        return winwidth('.') > 80 ? (strlen(&fenc) ? &fenc : &enc) : ''
    endfunction " }}}

    function! MyFiletype() " {{{
        return winwidth('.') > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
    endfunction " }}}

    let g:ctrlp_status_func = {
                \ 'main': 'CtrlPStatusFunc_1',
                \ 'prog': 'CtrlPStatusFunc_2',
                \ }

    function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked) " {{{
        let g:lightline.ctrlp_regex = a:regex
        let g:lightline.ctrlp_prev = a:prev
        let g:lightline.ctrlp_item = a:item
        let g:lightline.ctrlp_next = a:next
        return lightline#statusline(0)
    endfunction " }}}

    function! CtrlPStatusFunc_2(str) " {{{
        return lightline#statusline(0)
    endfunction " }}}

    let g:tagbar_status_func = 'TagbarStatusFunc'

    function! TagbarStatusFunc(current, sort, fname, ...) abort " {{{
        let g:lightline.fname = a:fname
        return lightline#statusline(0)
    endfunction " }}}

    augroup AutoSyntastic  " {{{
        autocmd!
        autocmd BufWritePost *.c,*.cpp,*.perl,*py call s:syntastic()
    augroup END " }}}
    function! s:syntastic() " {{{
        SyntasticCheck
        call lightline#update()
    endfunction " }}}
    call neobundle#untap()
endif
" LightLine }}}
" #### Airline {{{
if g:enable_airline
    " Always show the statusline
    set laststatus=2
    " No need to show mode
    set noshowmode
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#tabline#enabled = 1
endif
""}}}
" #### nathanaelkane/vim-indent-guides {{{
if neobundle#tap('vim-indent-guides')
    let g:indent_guides_start_level           = 2
    let g:indent_guides_guide_size            = 1
    let g:indent_guides_enable_on_vim_startup = 1
    call neobundle#untap()
endif
" }}}
" #### Yggdroot/indentLine {{{
if neobundle#tap('indentLine')
    let g:indentLine_color_term = 239
    function! neobundle#tapped.hooks.on_source(bundle)
        autocmd InsertEnter * IndentLinesDisable
        autocmd InsertLeave * IndentLinesEnable
    endfunction
    call neobundle#untap()
endif
" }}}
" }}}

" ## File Management {{{
" #### scrooloose/nerdtree {{{
if neobundle#tap('nerdtree')
    function! neobundle#tapped.hooks.on_source(bundle) " {{{
        " close vim if nerdtree is the unique opened buffer
        autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == 'primary') | q | endif
        let g:NERDTreeWinPos             = 'right'
        let g:NERDTreeShowBookmarks      = 1
        let g:NERDTreeShowHidden         = 1
        " let g:NERDTreeShowFiles        = 0
        " let g:NERDTreeIgnore             = ['\.pyc', '\~$', '\.swo$', '\.swp$', '\.git', '\.hg', '\.svn', '\.bzr']
        " let g:NERDTreeChDirMode          = 0
        " let g:NERDTreeQuitOnOpen         = 1
        " let g:NERDTreeMouseMode          = 2
        " let g:NERDTreeKeepTreeInNewTab   = 1
    endfunction " }}}
    nmap <F9> :NERDTreeToggle<CR>
    call neobundle#untap()
endif
" }}}
" #### jistr/vim-nerdtree-tabs {{{
let g:nerdtree_tabs_open_on_gui_startup = 0
" }}}
" #### kien/ctrlp.vim {{{
if neobundle#tap('ctrlp.vim')
    function! neobundle#tapped.hooks.on_source(bundle) " {{{
        let g:ctrlp_working_path_mode = 'ra'
        let g:ctrlp_custom_ignore = {
                    \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

        " On Windows use "dir" as fallback command.
        if WINDOWS()
            let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
        elseif executable('ag')
            let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
        elseif executable('ack-grep')
            let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
        elseif executable('ack')
            let s:ctrlp_fallback = 'ack %s --nocolor -f'
        else
            let s:ctrlp_fallback = 'find %s -type f'
        endif
        let g:ctrlp_user_command = {
                    \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                    \ },
                    \ 'fallback': s:ctrlp_fallback
                    \ }
        " CtrlP - don't recalculate files on start (slow)
        " let g:ctrlp_clear_cache_on_exit = 0
    endfunction " }}}

    nnoremap <silent> <D-t> :CtrlP<CR>
    nnoremap <silent> <D-r> :CtrlPMRU<CR>

    call neobundle#untap()
endif
" }}}
" #### tacahiroy/ctrlp-funky {{{
if neobundle#tap('ctrlp-funky')
    " CtrlP extensions
    let g:ctrlp_extensions = ['funky']

    "funky
    nnoremap <Leader>fu :CtrlPFunky<Cr>
    call neobundle#untap()
endif
" }}}
" }}}

" ## Vim enhancements {{{
" #### ozyo-manga/vim-anzu {{{
" if neobundle#tap('vim-anzu')
"     "call neobundle#config({
"     "            \ 'autoload' : {
"     "            \   'mappings': ['<Plug>(anzu-']
"     "            \}
"     "            \ })
"     nmap * <Plug>(anzu-star-with-echo);n
"
"     " Clear hit count when nokeyinput, move window, or move tab
"     Autocmd CursorHold,CursorHoldI,WinLeave,TabLeave
"                 \   * call anzu#clear_search_status()
"     call neobundle#untap()
" endif
" }}}
" }}}

" ## Motion {{{
" #### Lokaltog/vim-easymotion {{{
if neobundle#tap('vim-easymotion')
    " map  ; <Plug>(easymotion-prefix)
    " omap ; <Plug>(easymotion-prefix)
    " vmap ; <Plug>(easymotion-prefix)
    function! neobundle#tapped.hooks.on_post_source(bundle) "{{{
        EMCommandLineNoreMap <Space> <CR>
        EMCommandLineNoreMap <C-j> <Space>
        if ! g:EasyMotion_do_shade
            highlight! link EasyMotionIncSearch IncSearch
        endif
        highlight! link EasyMotionMoveHL Search
    endfunction "}}}
    function! neobundle#tapped.hooks.on_source(bundle) "{{{
        " EasyMotion Config {{{
        let g:EasyMotion_do_mapping = 0
        " let g:EasyMotion_keys = ';HKLYUIOPNM,QWERTZXCVBASDGJF'
        let g:EasyMotion_keys = ';HKLYUIONM,WERTXCVBASDGJF'
        " Do not shade
        let g:EasyMotion_do_shade = 0
        " Use upper case
        let g:EasyMotion_use_upper = 1
        " Smartcase
        let g:EasyMotion_smartcase = 1
        " Smartsign
        let g:EasyMotion_use_smartsign_us = 1
        " keep cursor column
        let g:EasyMotion_startofline = 0
        " Don't skip folded line
        let g:EasyMotion_skipfoldedline = 0
        " pseudo-migemo
        let g:EasyMotion_use_migemo = 1
        " Jump to first with enter & space
        " let g:EasyMotion_enter_jump_first = 1
        let g:EasyMotion_space_jump_first = 1
        " Prompt
        let g:EasyMotion_prompt = '{n}> '
        " Highlight cursor
        " let g:EasyMotion_cursor_highlight = 1
        "}}}

        " EasyMotion Regrex {{{
        let g:EasyMotion_re_line_anywhere = '\v' .
                    \  '(<.|^.)' . '|' .
                    \  '(.>|.$)' . '|' .
                    \  '(\s+\zs.)' . '|' .
                    \  '(\l)\zs(\u)' . '|' .
                    \  '(_\zs.)' . '|' .
                    \  '(#\zs.)'
        let g:EasyMotion_re_anywhere = '\v' .
                    \  '(<.|^)' . '|' .
                    \  '(.$)' . '|' .
                    \  '(\s+\zs.)' . '|' .
                    \  '(\l)\zs(\u)' . '|' .
                    \  '(_\zs.)' . '|' .
                    \  '(/\zs.)' . '|' .
                    \  '(#\zs.)'
        "}}}

    endfunction "}}}

    " EasyMotion Mapping {{{
    nmap s <Plug>(easymotion-s2)
    vmap s <Plug>(easymotion-s2)
    omap z <Plug>(easymotion-s2)
    nmap ;s <Plug>(easymotion-s)
    vmap ;s <Plug>(easymotion-s)
    omap ;z <Plug>(easymotion-s)

    " Extend search
    map  / <Plug>(easymotion-sn)
    xmap / <Esc><Plug>(easymotion-sn)\v%V
    omap / <Plug>(easymotion-tn)
    noremap  ;/ /
    nmap ;n <Plug>(easymotion-sn)<C-p>
    map ;N <Plug>(easymotion-bd-n)

    set nohlsearch " use EasyMotion highlight
    "nmap n <Plug>(easymotion-next)<Plug>(anzu-update-search-status)zv
    "nmap N <Plug>(easymotion-prev)<Plug>(anzu-update-search-status)zv
    nmap n <Plug>(easymotion-next)zv
    nmap N <Plug>(easymotion-prev)zv
    xmap n <Plug>(easymotion-next)zv
    xmap N <Plug>(easymotion-prev)zv

    " Replace defaut
    " smart f & F
    omap f <Plug>(easymotion-bd-fl)
    xmap f <Plug>(easymotion-bd-fl)
    omap F <Plug>(easymotion-Fl)
    xmap F <Plug>(easymotion-Fl)
    omap t <Plug>(easymotion-tl)
    xmap t <Plug>(easymotion-tl)
    omap T <Plug>(easymotion-Tl)
    xmap T <Plug>(easymotion-Tl)

    " Extend hjkl
    map ;h <Plug>(easymotion-linebackward)
    map ;j <Plug>(easymotion-j)
    map ;k <Plug>(easymotion-k)
    map ;l <Plug>(easymotion-lineforward)

    " Anywhere!
    " map <Space><Space> <Plug>(easymotion-jumptoanywhere)

    " Repeat last motion
    " map ;<Space> <Plug>(easymotion-repeat)

    " move to next/previous last motion match
    nmap <expr> <C-n> yankround#is_active() ?
                \ '<Plug>(yankround-next)' : '<Plug>(easymotion-next)'
    nmap <expr> <C-p> yankround#is_active() ?
                \ '<Plug>(yankround-prev)' : '<Plug>(easymotion-prev)'
    xmap <C-n> <Plug>(easymotion-next)
    xmap <C-p> <Plug>(easymotion-prev)

    nmap <expr><Tab> EasyMotion#is_active() ?
                \ '<Plug>(easymotion-next)' : '<TAB>'
    nmap <expr>' EasyMotion#is_active() ?
                \ '<Plug>(easymotion-prev)' : "'"

    " Extene word motion
    map  ;w  <Plug>(easymotion-bd-wl)
    map  ;e  <Plug>(easymotion-bd-el)
    omap ;b  <Plug>(easymotion-bl)
    " omap ;ge <Plug>(easymotion-gel)
    map ;ge <Plug>(easymotion-gel)

    function! s:wrap_M()
        let current_line = getline('.')
        keepjumps normal! M
        let middle_line = getline('.')
        if current_line == middle_line
            call EasyMotion#JK(0,2)
        endif
    endfunction
    nnoremap <silent> M :<C-u>call <SID>wrap_M()<CR>
    "}}}

    " EasyMotion User {{{
    " EasyMotion#User(pattern, is_visual, direction, is_inclusive)
    noremap  <silent><expr>;c
                \ ':<C-u>call EasyMotion#User(' .
                \ '"\\<' . expand('<cword>') . '\\>", 0, 2, 1)<CR>'
    xnoremap  <silent><expr>;c
                \ '<ESC>:<C-u>call EasyMotion#User(' .
                \ '"\\<' . expand('<cword>') . '\\>", 1, 2, 1)<CR>'

    let g:empattern = {}
    let g:empattern['syntax'] = '\v'
                \ . 'function|endfunction|return|call'
                \ . '|if|elseif|else|endif'
                \ . '|for|endfor'
                \ . '|while|endwhile'
                \ . '|break|continue'
                \ . '|let|unlet'
                \ . '|noremap|map|expr|silent'
                \ . '|g:|s:|b:|w:'
                \ . '|autoload|#|plugin'

    noremap  <silent>;1
                \ :<C-u>call EasyMotion#User(g:empattern.syntax , 0, 2, 1)<CR>
    xnoremap <silent>;1
                \ :<C-u>call EasyMotion#User(g:empattern.syntax , 1, 2, 1)<CR>
    "}}}

    function! EasyMotionMigemoToggle() "{{{
        if !exists(g:EasyMotion_use_migemo) && g:EasyMotion_use_migemo == 1
            let g:EasyMotion_use_migemo = 0
            echo 'Turn Off migemo'
        else
            let g:EasyMotion_use_migemo = 1
            echo 'Turn On migemo'
        endif
    endfunction
    command! -nargs=0 EasyMotionMigemoToggle :call EasyMotionMigemoToggle() "}}}

    call neobundle#untap()
endif
" easymotion }}}
" #### rhysd/clever-f.vim {{{
if neobundle#tap('clever-f.vim')
    function! neobundle#tapped.hooks.on_source(bundle) " {{{
        let g:clever_f_not_overwrites_standard_mappings = 1
        let g:clever_f_smart_case                       = 1
        let g:clever_f_accrossno_line                   = 1
    endfunction " }}}
    nmap f <Plug>(clever-f-f)
    nmap F <Plug>(clever-f-F)
    call neobundle#untap()
endif
" }}}
" #### rhysd/accelerated-jk {{{
if neobundle#tap('accelerated-jk')
    function! neobundle#tapped.hooks.on_source(bunle) "{{{
        let g:accelerated_jk_acceleration_table=[7,52,57]
    endfunction " }}}
    nmap j <Plug>(accelerated_jk_gj)
    nmap k <Plug>(accelerated_jk_gk)
    call neobundle#untap()
endif
" }}}
" }}}

" ## Text objects {{{
" #### wellle/targets.vim {{{
if neobundle#tap('targets.vim')
    " Disable `n` , `l` , `A`
    let g:targets_aiAI = 'ai I'
    let g:targets_nlNL = '  NL'
    call neobundle#untap()
endif
" }}}
" #### kana/vim-operator-replace {{{
if neobundle#tap('vim-operator-replace')
    map ;R <Plug>(operator-replace)
    call neobundle#untap()
endif
" }}}
" #### rhysd/vim-operator-surround {{{
if neobundle#tap('vim-operator-surround')
    "test it...
    map <silent>ys <Plug>(operator-surround-append)
    map <silent>ds <Plug>(operator-surround-delete)
    map <silent>cs <Plug>(operator-surround-replace)
    nmap <silent>yss V<Plug>(operator-surround-append)
    nmap <silent>dss V<Plug>(operator-surround-delete)
    nmap <silent>css V<Plug>(operator-surround-replace)
    call neobundle#untap()
endif
" }}}
" }}}

" ## Development - General {{{
" #### Signify {{{
if g:enable_startify && neobundle#tap('vim-signify')
    nnoremap <silent> <leader>gg :SignifyToggle<CR>
    "nmap ]c <plug>(signify-next-hunk)
    "nmap [c <plug>(signify-prev-hunk)
    call neobundle#untap()
endif
" }}}
" #### Fugitive {{{
if neobundle#tap('vim-fugitive')
"    call neobundle#config({
"                \   'autoload': {
"                \       'commands': [
"                \           'Gstatus', 'Gcommit', 'Gwrite', 'Gdiff', 'Gblame', 'Git', 'Ggrep'
"                \       ]
"                \ }
"                \ })
"
"    let s:bundle = neobundle#get('vim-fugitive')
"    function! s:bundle.hooks.on_post_source(bundle)
"        doautoall fugitive BufNewFile
"    endfunction


    call neobundle#untap()
endif
"if isdirectory(expand(s:vimfiles_dir."bundle/vim-fugitive/"))
"    nnoremap <silent> <leader>gs :Gstatus<CR>
"    nnoremap <silent> <leader>gd :Gdiff<CR>
"    nnoremap <silent> <leader>gc :Gcommit<CR>
"    nnoremap <silent> <leader>gb :Gblame<CR>
"    nnoremap <silent> <leader>gl :Glog<CR>
"    nnoremap <silent> <leader>gp :Git push<CR>
"    nnoremap <silent> <leader>gr :Gread<CR>
"    nnoremap <silent> <leader>gw :Gwrite<CR>
"    nnoremap <silent> <leader>ge :Gedit<CR>
"    " Mnemonic _i_nteractive
"    nnoremap <silent> <leader>gi :Git add -p %<CR>
"endif
" end Fugitive }}}
" #### godlygeek/tabular {{{
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a,, :Tabularize /,\zs<CR>
vmap <Leader>a,, :Tabularize /,\zs<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
" }}}
" #### Tagbar {{{
if neobundle#tap('tagbar')
    let g:tagbar_ctags_bin="C:/NoInstall_Programs/ctags58/ctags.exe"
    map <F7> :TagbarToggle<CR>
    let g:tagbar_iconchars = ['▷', '◢']
    let g:tagbar_left = 1

    "let g:tagbar_type_go = {
    "            \ 'ctagstype' : 'go',
    "            \ 'kinds'     : [  'p:package', 'i:imports:1', 'c:constants', 'v:variables',
    "            \ 't:types',  'n:interfaces', 'w:fields', 'e:embedded', 'm:methods',
    "            \ 'r:constructor', 'f:functions' ],
    "            \ 'sro' : '.',
    "            \ 'kind2scope' : { 't' : 'ctype', 'n' : 'ntype' },
    "            \ 'scope2kind' : { 'ctype' : 't', 'ntype' : 'n' },
    "            \ 'ctagsbin'  : 'gotags',
    "            \ 'ctagsargs' : '-sort -silent'
    "            \ }
    call neobundle#untap()
endif
"}}}
" }}}

" ## Web development {{{
" #### mattn/emmet-vim {{{
if neobundle#tap('emmet-vim')
    let g:user_emmet_leader_key='<Leader>y'
    call neobundle#untap()
endif
" }}}
" #### Javascript {{{
" ###### 'osyo-manga/vim-precious' {{{
let g:markdown_fenced_languages = [
    \  'coffee',
    \  'css',
    \  'erb=eruby',
    \  'javascript',
    \  'js=javascript',
    \  'json=javascript',
    \  'ruby',
    \  'sass',
    \  'xml',
    \  'python',
    \  'vim',
    \]
" }}}
" }}}
" }}}


" ## spf13/vim-autoclose {{{
let g:autoclose_vim_commentmode = 1 "Do not close doublequote while editing vim files
" }}}


" ## Conque-Shell {{{
map ² :ConqueTermSplit powershell.exe<CR>
" }}}

" ## AutoCloseTag {{{
" Make it so AutoCloseTag works for xml and xhtml files as well
au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
nmap <Leader>ac <Plug>ToggleAutoCloseMappings
" }}}


" ## Ctags {{{
set tags=./tags;/,~/.vimtags

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" }}}




" ## Startify {{{
if g:enable_startify
 " Startify, the fancy start page
    let g:ctrlp_reuse_window = 'startify' " don't split in startify
    "let g:startify_bookmarks = [
    "    \ $HOME . "/.vimrc", $HOME . "/.vimrc.first",
    "    \ $HOME . "/.vimrc.last", $HOME . "/.vimrc.plugins"
    "    \ ]
    "let g:startify_custom_header = [
    "    \ '   Author:      Tim Sæterøy',
    "    \ '   Homepage:    http://thevoid.no',
    "    \ '   Source:      http://github.com/timss/vimconf',
    "    \ ''
    "    \ ]
endif
" }}}

" UndoTree {{{
if neobundle#tap('undotree')
    call neobundle#config({
                \ 'autoload': {
                \   'commands': 'UndotreeToggle'
                \   }
                \ })
    nnoremap <Leader>u :UndotreeToggle<CR>
    " If undotree is opened, it is likely one wants to interact with it.
    let g:undotree_SetFocusWhenToggle=1
    call neobundle#untap()
endif
" }}}

" ## VimOrganizer {{{
if g:enable_orgmode && neobundle#tap('VimOrganizer')
    au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
    au BufEnter *.org call org#SetOrgFileType()
    call neobundle#untap()
endif
" }}}
" end Plugins }}}

" Initialize directories {{{===========
function! InitializeDirectories()
    let dir_list = {
                \ 'backup': 'backupdir',
                \ 'views': 'viewdir',
                \ 'swap': 'directory' }

    if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
    endif

    for [dirname, settingname] in items(dir_list)
        let directory = s:vimfiles_dir . dirname . '/'
        if exists("*mkdir")
            if !isdirectory(directory)
                call mkdir(directory)
            endif
        endif
        if !isdirectory(directory)
            echo "Warning: Unable to create backup directory: " . directory
            echo "Try: mkdir -p " . directory
        else
            let directory = substitute(directory, " ", "\\\\ ", "g")
            exec "set " . settingname . "=" . directory
        endif
    endfor
endfunction
call InitializeDirectories()
" }}}

" Finally {{{==========================

if filereadable($HOME.'/_vimrc.last')
    source $HOME/_vimrc.last
endif
" Installation check.
NeoBundleCheck
if !has('vim_starting')
    call neobundle#call_hook('on_source')
endif
set secure
"}}}



" {{{
if 0
    " Plugins {

    " TextObj Sentence {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_sentence
              autocmd!
              autocmd FileType markdown call textobj#sentence#init()
              autocmd FileType textile call textobj#sentence#init()
              autocmd FileType text call textobj#sentence#init()
            augroup END
        endif
    " }

    " TextObj Quote {
        if count(g:spf13_bundle_groups, 'writing')
            augroup textobj_quote
                autocmd!
                autocmd FileType markdown call textobj#quote#init()
                autocmd FileType textile call textobj#quote#init()
                autocmd FileType text call textobj#quote#init({'educate': 0})
            augroup END
        endif
    " }

    " PIV {
        if isdirectory(expand("~/.vim/bundle/PIV"))
            let g:DisableAutoPHPFolding = 0
            let g:PIVAutoClose = 0
        endif
    " }

    " Misc {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            let g:NERDShutUp=1
        endif
        if isdirectory(expand("~/.vim/bundle/matchit.zip"))
            let b:match_ignorecase = 1
        endif
    " }

    " OmniComplete {
        " To disable omni complete, add the following to your .vimrc.before.local file:
        "   let g:spf13_no_omni_complete = 1
        if !exists('g:spf13_no_omni_complete')
            if has("autocmd") && exists("+omnifunc")
                autocmd Filetype *
                    \if &omnifunc == "" |
                    \setlocal omnifunc=syntaxcomplete#Complete |
                    \endif
            endif

            hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
            hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
            hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

            " Some convenient mappings
            inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
            inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"
            inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
            inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
            inoremap <expr> <C-d>      pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
            inoremap <expr> <C-u>      pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"

            " Automatically open and close the popup menu / preview window
            au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
            set completeopt=menu,preview,longest
        endif
    " }


    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Steve Francia <steve.francia@gmail.com>'
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " PyMode {
        " Disable if python support not present
        if !has('python')
            let g:pymode = 0
        endif

        if isdirectory(expand("~/.vim/bundle/python-mode"))
            let g:pymode_lint_checkers = ['pyflakes']
            let g:pymode_trim_whitespaces = 0
            let g:pymode_options = 0
            let g:pymode_rope = 0
        endif
    " }

    " YouCompleteMe {
        if count(g:spf13_bundle_groups, 'youcompleteme')
            let g:acp_enableAtStartup = 0

            " enable completion from tags
            let g:ycm_collect_identifiers_from_tags_files = 1

            " remap Ultisnips for compatibility for YCM
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " Haskell post write lint and check with ghcmod
            " $ `cabal install ghcmod` if missing and ensure
            " ~/.cabal/bin is in your $PATH.
            if !executable("ghcmod")
                autocmd BufWritePost *.hs GhcModCheckAndLintAsync
            endif

            " For snippet_complete marker.
            if !exists("g:spf13_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
        endif
    " }

    " neocomplete {
        if count(g:spf13_bundle_groups, 'neocomplete')
            let g:acp_enableAtStartup = 0
            let g:neocomplete#enable_at_startup = 1
            let g:neocomplete#enable_smart_case = 1
            let g:neocomplete#enable_auto_delimiter = 1
            let g:neocomplete#max_list = 15
            let g:neocomplete#force_overwrite_completefunc = 1


            " Define dictionary.
            let g:neocomplete#sources#dictionary#dictionaries = {
                        \ 'default' : '',
                        \ 'vimshell' : $HOME.'/.vimshell_hist',
                        \ 'scheme' : $HOME.'/.gosh_completions'
                        \ }

            " Define keyword.
            if !exists('g:neocomplete#keyword_patterns')
                let g:neocomplete#keyword_patterns = {}
            endif
            let g:neocomplete#keyword_patterns['default'] = '\h\w*'

            " Plugin key-mappings {
                " These two lines conflict with the default digraph mapping of <C-K>
                if !exists('g:spf13_no_neosnippet_expand')
                    imap <C-k> <Plug>(neosnippet_expand_or_jump)
                    smap <C-k> <Plug>(neosnippet_expand_or_jump)
                endif
                if exists('g:spf13_noninvasive_completion')
                    iunmap <CR>
                    " <ESC> takes you out of insert mode
                    inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
                    " <CR> accepts first, then sends the <CR>
                    inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
                    " <Down> and <Up> cycle like <Tab> and <S-Tab>
                    inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
                    inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
                    " Jump up and down the list
                    inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
                    inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
                else
                    " <C-k> Complete Snippet
                    " <C-k> Jump to next snippet point
                    imap <silent><expr><C-k> neosnippet#expandable() ?
                                \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                                \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
                    smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

                    inoremap <expr><C-g> neocomplete#undo_completion()
                    inoremap <expr><C-l> neocomplete#complete_common_string()
                    "inoremap <expr><CR> neocomplete#complete_common_string()

                    " <CR>: close popup
                    " <s-CR>: close popup and save indent.
                    inoremap <expr><s-CR> pumvisible() ? neocomplete#smart_close_popup()"\<CR>" : "\<CR>"

                    function! CleverCr()
                        if pumvisible()
                            if neosnippet#expandable()
                                let exp = "\<Plug>(neosnippet_expand)"
                                return exp . neocomplete#smart_close_popup()
                            else
                                return neocomplete#smart_close_popup()
                            endif
                        else
                            return "\<CR>"
                        endif
                    endfunction

                    " <CR> close popup and save indent or expand snippet
                    imap <expr> <CR> CleverCr()
                    " <C-h>, <BS>: close popup and delete backword char.
                    inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
                    inoremap <expr><C-y> neocomplete#smart_close_popup()
                endif
                " <TAB>: completion.
                inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
                inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"

                " Courtesy of Matteo Cavalleri

                function! CleverTab()
                    if pumvisible()
                        return "\<C-n>"
                    endif
                    let substr = strpart(getline('.'), 0, col('.') - 1)
                    let substr = matchstr(substr, '[^ \t]*$')
                    if strlen(substr) == 0
                        " nothing to match on empty string
                        return "\<Tab>"
                    else
                        " existing text matching
                        if neosnippet#expandable_or_jumpable()
                            return "\<Plug>(neosnippet_expand_or_jump)"
                        else
                            return neocomplete#start_manual_complete()
                        endif
                    endif
                endfunction

                imap <expr> <Tab> CleverTab()
            " }

            " Enable heavy omni completion.
            if !exists('g:neocomplete#sources#omni#input_patterns')
                let g:neocomplete#sources#omni#input_patterns = {}
            endif
            let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
            let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
            let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
            let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
            let g:neocomplete#sources#omni#input_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
    " }
    " neocomplcache {
        elseif count(g:spf13_bundle_groups, 'neocomplcache')
            let g:acp_enableAtStartup = 0
            let g:neocomplcache_enable_at_startup = 1
            let g:neocomplcache_enable_camel_case_completion = 1
            let g:neocomplcache_enable_smart_case = 1
            let g:neocomplcache_enable_underbar_completion = 1
            let g:neocomplcache_enable_auto_delimiter = 1
            let g:neocomplcache_max_list = 15
            let g:neocomplcache_force_overwrite_completefunc = 1

            " Define dictionary.
            let g:neocomplcache_dictionary_filetype_lists = {
                        \ 'default' : '',
                        \ 'vimshell' : $HOME.'/.vimshell_hist',
                        \ 'scheme' : $HOME.'/.gosh_completions'
                        \ }

            " Define keyword.
            if !exists('g:neocomplcache_keyword_patterns')
                let g:neocomplcache_keyword_patterns = {}
            endif
            let g:neocomplcache_keyword_patterns._ = '\h\w*'

            " Plugin key-mappings {
                " These two lines conflict with the default digraph mapping of <C-K>
                imap <C-k> <Plug>(neosnippet_expand_or_jump)
                smap <C-k> <Plug>(neosnippet_expand_or_jump)
                if exists('g:spf13_noninvasive_completion')
                    iunmap <CR>
                    " <ESC> takes you out of insert mode
                    inoremap <expr> <Esc>   pumvisible() ? "\<C-y>\<Esc>" : "\<Esc>"
                    " <CR> accepts first, then sends the <CR>
                    inoremap <expr> <CR>    pumvisible() ? "\<C-y>\<CR>" : "\<CR>"
                    " <Down> and <Up> cycle like <Tab> and <S-Tab>
                    inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Down>"
                    inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<Up>"
                    " Jump up and down the list
                    inoremap <expr> <C-d>   pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
                    inoremap <expr> <C-u>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
                else
                    imap <silent><expr><C-k> neosnippet#expandable() ?
                                \ "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ?
                                \ "\<C-e>" : "\<Plug>(neosnippet_expand_or_jump)")
                    smap <TAB> <Right><Plug>(neosnippet_jump_or_expand)

                    inoremap <expr><C-g> neocomplcache#undo_completion()
                    inoremap <expr><C-l> neocomplcache#complete_common_string()
                    "inoremap <expr><CR> neocomplcache#complete_common_string()

                    function! CleverCr()
                        if pumvisible()
                            if neosnippet#expandable()
                                let exp = "\<Plug>(neosnippet_expand)"
                                return exp . neocomplcache#close_popup()
                            else
                                return neocomplcache#close_popup()
                            endif
                        else
                            return "\<CR>"
                        endif
                    endfunction

                    " <CR> close popup and save indent or expand snippet
                    imap <expr> <CR> CleverCr()

                    " <CR>: close popup
                    " <s-CR>: close popup and save indent.
                    inoremap <expr><s-CR> pumvisible() ? neocomplcache#close_popup()"\<CR>" : "\<CR>"
                    "inoremap <expr><CR> pumvisible() ? neocomplcache#close_popup() : "\<CR>"

                    " <C-h>, <BS>: close popup and delete backword char.
                    inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
                    inoremap <expr><C-y> neocomplcache#close_popup()
                endif
                " <TAB>: completion.
                inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
                inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<TAB>"
            " }

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " Enable heavy omni completion.
            if !exists('g:neocomplcache_omni_patterns')
                let g:neocomplcache_omni_patterns = {}
            endif
            let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
            let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
            let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\h\w*\|\h\w*::'
            let g:neocomplcache_omni_patterns.go = '\h\w*\.\?'
    " }
    " Normal Vim omni-completion {
    " To disable omni complete, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_omni_complete = 1
        elseif !exists('g:spf13_no_omni_complete')
            " Enable omni-completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

        endif
    " }

    " Snippets {
        if count(g:spf13_bundle_groups, 'neocomplcache') ||
                    \ count(g:spf13_bundle_groups, 'neocomplete')

            " Use honza's snippets.
            let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'

            " Enable neosnippet snipmate compatibility mode
            let g:neosnippet#enable_snipmate_compatibility = 1

            " For snippet_complete marker.
            if !exists("g:spf13_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Enable neosnippets when using go
            let g:go_snippet_engine = "neosnippet"

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
        endif
    " }

    " FIXME: Isn't this for Syntastic to handle?
    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif


    " Wildfire {
    let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"],
                \ }
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/bundle/vim-airline/"))
            if !exists('g:airline_theme')
                let g:airline_theme = 'solarized'
            endif
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
        endif
    " }




" Initialize NERDTree as needed {{{====
function! NERDTreeInitAsNeeded()
    redir => bufoutput
    buffers!
    redir END
    let idx = stridx(bufoutput, "NERD_tree")
    if idx > -1
        NERDTreeMirror
        NERDTreeFind
        wincmd l
    endif
endfunction
" }}}
" }
endif
"}}}