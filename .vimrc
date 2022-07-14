" 色設定
colorscheme elflord " colorscheme koehler

syntax enable

" setting
"文字コードをUFT-8に設定
set fenc=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd


" 見た目系
" 行番号を表示
set number
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk


" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" Plugin設定
" vundle.vimを使う
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" 構文チェッカ
Plugin 'scrooloose/syntastic'

" Tabキー補完
Plugin 'ervandew/supertab'

" golang用
" Plugin 'fatih/vim-go'
" Plugin 'nsf/gocode', {'rtp': 'vim/'}
Plugin 'mattn/vim-gomod'
let g:go_gocode_unimported_packages = 1
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['errcheck', 'golint', 'govet', 'go']
au BufNewFile,BufRead *.go set noexpandtab tabstop=4 shiftwidth=4
let mapleader = "\<Space>"

au FileType go nmap <leader>s <Plug>(go-def-split)
au FileType go nmap <leader>v <Plug>(go-def-vertical)

" Markdown用
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled = 1
au BufNewFile,BufRead *.md set expandtab tabstop=4 shiftwidth=4

" Python用
" Plugin 'davidhalter/jedi-vim'
Plugin 'petobens/poet-v'
Plugin 'Glench/Vim-Jinja2-Syntax'
let g:syntastic_python_checkers = ["flake8"]
" jedi-vimにtab設定が入ってるっぽいのでいらない

" git
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-fugitive'
Plugin 'gotchane/vim-git-commit-prefix'

" ctrlp.vim
Plugin 'ctrlpvim/ctrlp.vim'

" toml
Plugin 'cespare/vim-toml'

" nerdtree
Plugin 'scrooloose/nerdtree'

" vim-lsp-settings
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'

" auto-complete
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

" lsp error highlight
Plugin 'itchyny/lightline.vim'
Plugin 'halkn/lightline-lsp'
 
call vundle#end()

" backspace setting
set backspace=indent,eol,start

" Omni
set omnifunc=syntaxcomplete#Complete

" vim-lsp
if executable('pyls')
    " pip install python-language-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go,*py call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" python向け
let g:lsp_settings = {
\   'pylsp-all': {
\     'workspace_config': {
\       'pylsp': {
\         'configurationSources': ['flake8']
\       }
\     }
\   },
\}

" golang 向け lsp_setings
let g:lsp_settings['gopls'] = {
\  'workspace_config': {
\    'usePlaceholders': v:true,
\    'analyses': {
\      'fillstruct': v:true,
\    },
\  },
\  'initialization_options': {
\    'usePlaceholders': v:true,
\    'analyses': {
\      'fillstruct': v:true,
\    },
\  },
\}

" error highlight
let g:lightline = {
\ 'active': {
\   'right': [ [ 'lsp_errors', 'lsp_warnings', 'lsp_ok', 'lineinfo' ],
\              [ 'percent' ],
\              [ 'fileformat', 'fileencoding', 'filetype' ] ]
\ },
\ 'component_expand': {
\   'lsp_warnings': 'lightline_lsp#warnings',
\   'lsp_errors':   'lightline_lsp#errors',
\   'lsp_ok':       'lightline_lsp#ok',
\ },
\ 'component_type': {
\   'lsp_warnings': 'warning',
\   'lsp_errors':   'error',
\   'lsp_ok':       'middle',
\ },
\ }
highlight link LspWarningHighlight Error
highlight link LspErrorHighlight Error
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_signs_enabled = 0

