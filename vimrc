set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'ycm-core/YouCompleteMe'

Plugin 'octol/vim-cpp-enhanced-highlight'

Plugin 'rdnetto/YCM-Generator'

Plugin 'tomasiser/vim-code-dark'

call vundle#end()
filetype plugin indent on

" set runtimepath-=~/.vim/bundle/vim-cpp-enhanced-highlight

set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
" disable vi compatibility (emulation of old bugs)
set nocompatible
" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent
" configure tabwidth and insert spaces instead of tabs
set tabstop=4        " tab width is 4 spaces
set shiftwidth=4     " indent also with 4 spaces
set expandtab        " expand tabs to spaces
" wrap lines at 120 chars. 80 is somewaht antiquated with nowadays displays.
" set textwidth=120
" turn syntax highlighting on
set t_Co=256
syntax on
" colorscheme wombat256
" turn line numbers on
set number
" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

let g:ycm_enable_semantic_highlighting=1
let g:ycm_enable_inlay_hints=1
let g:ycm_autoclose_preview_window_after_completion = 1
" let g:cpp_experimental_simple_template_highlight = 1
" let g:cpp_experimental_template_highlight = 1

nmap \d :YcmCompleter GoToDefinition<Enter>
nmap \t :YcmCompleter GetType<Enter>
nmap \f :YcmCompleter FixIt<Enter>
nmap \h <plug>(YCMHover)

let g:codedark_transparent=1

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/

" nmap <leader>sp :call <SID>SynStack()<CR>
nmap <F3> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


augroup filetype_c
    autocmd!
    autocmd Filetype cpp    colorscheme codedark
    autocmd Filetype python colorscheme codedark
    autocmd Filetype cuda   colorscheme codedark
    autocmd Filetype c      colorscheme codedark
augroup end

imap jj <Esc>
