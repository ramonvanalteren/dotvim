" Use Vim settings, rather then Vi settings (much better!).
" " This must be first, because it changes other options as a side effect.
set nocompatible

" This makes sure that whenever I save this file, it is reloaded in my current editor
" So any changes I save to the vimrc file are automatically in effect as soon as I save it.
if has("autocmd")
    autocmd bufwritepost .vimrc source $MYVIMRC
endif

" This sets up the pathogen plugin, which allows me to install other plugins
" as a bundle
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" Enable syntax highlighting.
syntax on

" Tabs should be converted to a group of 4 spaces.
" This is the official Python convention
" (http://www.python.org/dev/peps/pep-0008/)
set shiftwidth=4
set textwidth=121
set tabstop=4
set softtabstop=4
set expandtab
set smarttab

" Set utf-8 encoding
set encoding=utf-8

" Set status
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " filename
set statusline+=%h%m%r%w                     " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
set statusline+=%=                           " right align remainder
set statusline+=0x%-8B                       " character value
set statusline+=%-14(%l,%c%V%)               " line, character
set statusline+=%<%P                         " file position

" Show line number and cursor position
set ruler

" Display incomplete commands.
set showcmd

" To save, press ctrl-s.
nmap <c-s> :w<CR>
imap <c-s> <Esc>:w<CR>a

" Search stuff
set showmatch " show matching brackets
set matchtime=5 " how many tenths of a second to blink matching brackets for
set nohlsearch " do not highlight searched for phrases
set incsearch

" Indenting
set smartindent
set noautoindent " Autoindent drives me nuts
"set cindent " Do c-style indenting

" Folding
" Folding options confuse me and seem to hamper my productivity
" Commenting them out for now
" set foldenable
" set foldmethod=indent
" set foldlevelstart=99
"" Save my folds automagically
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview

filetype plugin indent on " load filetype plugins with their indent rules

" Set a readable colorscheme, especially for the comment sections which used
" are unreadable in darkblue
colorscheme desert
" These are few additions to the colorsettings of desert scheme that I find usefull
hi NonText ctermfg=DarkGrey ctermbg=NONE
hi SpecialKey ctermfg=DarkGrey ctermbg=NONE

" Show autocomplete menus
set wildmenu

" Set linenumbers on
set number

" Show tabs instead of spaces and any trailing whitespace
set list
set listchars=tab:→.,trail:-,eol:↵


" Python integration
" This beauty remembers where you were the last time you edited the file, and returns to the same position.
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Python IDE according to: http://blog.dispatched.ch/2009/05/24/vim-as-python-ide/
" With additional stuff from all over the place

" Minibuffexpl part
map <Leader>u :UMiniBufExplorer<cr> " update minibufexp window
map <Leader>t :TMiniBufExplorer<cr> " terminate minibufexp window
let g:miniBufExplMapWindowNavVim = 1 " map window keys to navigation (hjkl)
let g:miniBufExplMapWindowNavArrows = 1 " map window keys to arrow keys
let g:miniBufExplMapCTabSwitchBufs = 1 " switch to different buffer with tab
let g:miniBufExplModSelTarget = 1 " Don't use unmodifiable windows to put buffer in

" Ctag integration that takes care of completion
let Tlist_Ctags_Cmd='/Volumes/Shared/prefix-64/usr/bin/ctags'

" Show Taglist when pressing P
map T <Plug>TaskList<CR>
map P :TlistToggle<CR>

" Set autocompletion for python
" Bindings are the standard Crtl+N or Crtl+X Ctrl+O
autocmd FileType python set omnifunc=pythoncomplete#Complete

" Python snippet to allow jumping into lib code by using gf
" http://sontek.net/Python-with-a-modular-IDE-(Vim)
python << EOF
import os, sys, vim
for p in sys.path:
    if os.path.isdir(p):
        vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF

" compile :make support for python for more advanced syntax checking
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
