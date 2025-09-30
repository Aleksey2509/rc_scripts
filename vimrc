set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'ryanoasis/vim-devicons'

Plugin 'tpope/vim-surround'

Plugin 'tpope/vim-fugitive'

Plugin 'tmhedberg/SimpylFold'

Plugin 'ycm-core/YouCompleteMe'

Plugin 'Aleksey2509/vim-code-dark-fork'

Plugin 'KarimElghamry/vim-auto-comment'

Plugin 'psf/black'

Plugin 'preservim/nerdtree'

Plugin 'lervag/vimtex'

call vundle#end()
filetype plugin indent on

syntax on

let g:vimtex_view_method = 'zathura'

let g:vimtex_compiler_method = 'latexmk'

set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set autoindent
set foldmethod=syntax
let g:SimpylFold_docstring_preview=1

" set backspace=indent,eol,start

set smartindent
" configure tabwidth and insert spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" set textwidth=120

set t_Co=256
set number
set showmatch
set comments=sl:/*,mb:\ *,elx:\ */

let g:ycm_enable_semantic_highlighting=1
let g:ycm_enable_inlay_hints=1
let g:ycm_autoclose_preview_window_after_completion = 1

let g:ycm_echo_current_diagnostic = 'virtual-text'
let g:ycm_update_diagnostics_in_insert_mode=0
let g:ycm_warning_symbol = '!#'

nmap \v :call ToggleRelNumber()<Enter>
nmap \s :call ToggleHl()<Enter>
nmap \d :YcmCompleter GoToDefinition<Enter>
nmap \t :YcmCompleter GetType<Enter>
nmap \f :YcmCompleter FixIt<Enter>
nmap \c :YcmCompleter Format<Enter>
nmap \g <Plug>(YCMFindSymbolInDocument)
nmap \G <Plug>(YCMFindSymbolInWorkspace)
nmap \r :YcmCompleter GoToReferences<Enter>
nmap \h <plug>(YCMHover)
nnoremap <silent> <localleader>S <Plug>(YCMToggleInlayHints)
" let g:ycm_language_server = [
"   \   {
"   \     'name': 'haskell-language-server',
"   \     'cmdline': [ 'haskell-language-server-wrapper', '--lsp' ],
"   \     'filetypes': [ 'haskell', 'lhaskell' ],
"   \     'project_root_files': [ 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml' ],
"   \   },
"   \ ]

hi darkModernGreen ctermfg=43
hi yellowOrange ctermfg=179
hi def link cppOperator Function

call prop_type_add( 'YCM_HL_namespace', { 'highlight': 'darkModernGreen' } )
call prop_type_add( 'YCM_HL_concept', { 'highlight': 'darkModernGreen' } )
call prop_type_add( 'YCM_HL_class', { 'highlight': 'darkModernGreen' } )
call prop_type_add( 'YCM_HL_function', { 'highlight': 'Function' } )
call prop_type_add( 'YCM_HL_label', { 'highlight': 'Macro' } )
call prop_type_add( 'YCM_HL_formatSpecifier', { 'highlight': 'Special' } )

set relativenumber
set ruler
set signcolumn=number
set wildmenu
set scrolloff=5

" nmap <leader>sp :call <SID>SynStack()<CR>
nmap <F3> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

imap jj <ESC>

let g:codedark_transparent=1
let g:inline_comment_dict = {
		\'//': ["js", "ts", "cpp", "cc", "hh", "h", "cu", "c", "dart"],
		\'#': ['py', 'sh'],
		\'"': ['vim'],
		\}

augroup filetype_c
    autocmd!
    autocmd Filetype cpp    call SetKnownLanguagesOptions()
    autocmd Filetype cuda   call SetKnownLanguagesOptions()
    autocmd Filetype c      call SetKnownLanguagesOptions()
    autocmd Filetype rust   call SetKnownLanguagesOptions()
    autocmd Filetype haskell   call SetKnownLanguagesOptions()
augroup end

augroup python_fl
    autocmd!
    autocmd Filetype python call SetKnownLanguagesOptions()
augroup end

function ToggleHl()
    let current = trim(execute('set hlsearch?'))
    if current == "nohlsearch"
        :set hlsearch
    else
        :set nohlsearch
    endif
endfunction


function ToggleRelNumber()
    let current = trim(execute('set relativenumber?'))
    if current == "relativenumber"
        :set norelativenumber
    else
        :set relativenumber
    endif
endfunction

function SetKnownLanguagesOptions()
        set cursorline
        colorscheme codedark
endfunction

highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
