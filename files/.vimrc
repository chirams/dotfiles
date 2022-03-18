"
" .vimrc
"


" Default {{{
" -------------------------------------------------
"

" current dir
if $HOME == '/root'
    let g:self_dir = '/home/'.$USER
else
    let g:self_dir = $HOME
endif

" backup flag
let g:backup_f=0
" dein flag
let g:dein_f=0
" delete last spase flag
let g:del_last_spase_f=0

" ローカル設定ファイル
" -------------------------------------------------
"
let s:local_vimrc = expand(g:self_dir."/.vimrc.local")
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
else
    :execute ":redir! > " . s:local_vimrc
    :silent! echon "\" current dir" . "\n"
    :silent! echon "let g:backup_f=" . g:backup_f . "\n"
    :silent! echon "\" dein flag" . "\n"
    :silent! echon "let g:dein_f=" . g:dein_f . "\n"
    :silent! echon "\" delete last spase flag" . "\n"
    :silent! echon "let g:del_last_spase_f=" . g:del_last_spase_f . "\n"
    :redir END
endif


" バックアップ定義
" -------------------------------------------------
"
" Swap File
if g:backup_f==1
    if isdirectory(expand(g:self_dir."/.vim/tmp"))
        set backupdir=expand(g:self_dir."/.vim/tmp")
    endif
endif

" }}}


" エンコード {{{
" -------------------------------------------------
"

" 設定ファイル用
scriptencoding utf-8

" vim内部で用いるエンコーディングを指定
set encoding=utf-8
" バッファの保存時に用いるエンコーディング
set fileencodings=utf-8,euc-jp,ucs-2le,ucs-2,cp932,iso-2022-jp,utf-16
" 端末の出力に用いられるエンコーディング
set termencoding=utf-8

" 2バイト文字対策
set ambiwidth=double

" }}}


" 基本パラメータ {{{
" -------------------------------------------------
"

" Color Schema
colorscheme ron
" colorscheme default

" True Color
" set termguicolors

" ヘルプ言語
set helplang=ja,en
" 互換モード
set nocompatible

" 行数の表示
set number
" バックスペースキーの動作を決定する
set backspace=2

" 新しい行を作ったときに高度な自動インデントを行う
set smartindent
" 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする
" // set autoindent
" インデントのある長い行の折りえしを綺麗に
" // set breakindent
" 自動インデントの各段階に使われる空白の数
set softtabstop=4
" ファイル内の <Tab> が対応する空白の数
set tabstop=4
" タブをスペースに変更
set expandtab
" インデント時に使用されるスペースの数
set shiftwidth=4

"強調表示(シンタックス)のON/OFF設定
syntax on
if !has('gui_running')
  set t_Co=256
endif
highlight StatusLine ctermfg=23 ctermbg=7

" git protocol
let g:vundle_default_git_proto='git'

" 最初からペーストモード
" // set paste

" 末尾の改行を除去
" set noeol


" マウス
"set mouse=a

" }}}


" 検索 {{{
" -------------------------------------------------
"

" インクリメンタルサーチを行う
set incsearch
" (no)検索をファイルの末尾まで検索したら、ファイルの先頭へループする
set nowrapscan

" 大文字小文字を無視して検索
set ignorecase
" highlight matches with last search pattern
set hlsearch
" 閉じ括弧が入力されたとき、対応する括弧を表示する
set showmatch
" サーチハイライトををESC二回で消す
nmap <Esc><Esc> :nohlsearch<CR><Esc>

" }}}


" 表示設定 {{{
" -------------------------------------------------
"

" 常にステータスラインを表示する
set laststatus=2

" <? を無効にする→ハイライト除外にする
let g:php_noShortTags = 0

" コマンドライン補完
set wildmode=list,full
" php補完
highlight Pmenu ctermbg=4
highlight PmenuSel ctermbg=1
highlight PMenuSbar ctermbg=4

" カレント行ハイライトON
"set cursorline
" カーソル位置をハイライト（列）
"set cursorcolumn

"括弧のハイライトを止める
let g:loaded_matchparen = 1
" 最後のスペースを削除
if g:del_last_spase_f==1
    autocmd BufWritePre * :%s/\s\+$//ge
endif
" マルチバイト
set formatoptions+=mM

" 入力中のコマンドを表示する
set showcmd
" コマンドラインモードで<Tab>キーによるファイル名補完を有効にする
set wildmenu
" ウインドウのタイトルバーにファイルのパス情報等を表示する
set title

" 不可視文字の表示
"set list
" 不可視文字の詳細設定
"set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%

" }}}


" 折りたたみ {{{
" -------------------------------------------------
"

" set foldmethod=marker
" set foldlevel=0

" 折りたたみ禁止
"set foldmethod=syntax
"let g:perl_fold=1
"set foldlevel=100 "Don't autofold anything
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" }}}


" タブ {{{
" -------------------------------------------------
"

" vim バニラ用タブ表示設定 {{{
" ----------------------------
" コピペに付き、要検証

" Anywhere SID.
function! s:SID_PREFIX()
    return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
    let s = ''
    for i in range(1, tabpagenr('$'))
        let bufnrs = tabpagebuflist(i)
        let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
        let no = i  " display 0-origin tabpagenr.
        let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
        let title = fnamemodify(bufname(bufnr), ':t')
        let title = '[' . title . ']'
        let s .= '%'.i.'T'
        let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
        let s .= no . ':' . title
        let s .= mod
        let s .= '%#TabLineFill# '
    endfor
    let s .= '%#TabLineFill#%T%=%#TabLine#'
    return s
endfunction "}}}

let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'

set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]

" Tab jump
for n in range(1, 9)
    execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor

" }}}

" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
" tc 新しいタブを一番右に作る
map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tx タブを閉じる
map <silent> [Tag]x :tabclose<CR>
" tn 次のタブ
map <silent> [Tag]n :tabnext<CR>
" tp 前のタブ
map <silent> [Tag]p :tabprevious<CR>
" 左右のカーソル移動で行間移動可能にする。
set whichwrap=b,s,h,l,<,>,[,],~

" }}}


" key bind {{{
" -------------------------------------------------
"

" 検索語が画面中央にくるように
nmap n nzz
nmap N Nzz

" Shift + 矢印でウィンドウサイズを変更
nnoremap <S-Left>  <C-w><<CR>
nnoremap <S-Right> <C-w>><CR>
nnoremap <S-Up>    <C-w>-<CR>
nnoremap <S-Down>  <C-w>+<CR>

" }}}


" ショートカット {{{
" -------------------------------------------------
"

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %

" 現在時刻
inoremap <Leader>time <C-R>=strftime('%H:%M')<CR>

" }}}


" jqを使ったJSONパーサー {{{
" -------------------------------------------------
" 引用元: http://qiita.com/tekkoc/items/324d736f68b0f27680b8
"

command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
    if 0 == a:0
        let l:arg = "."
    else
        let l:arg = a:1
    endif
    execute "%! jq \"" . l:arg . "\""
endfunction


" }}}

" dein 設定 {{{
" -------------------------------------------------
"

if g:dein_f==1

    if &compatible
        set nocompatible
    endif

    " dein.vim ディレクトリ
    let s:dein_dir = expand(g:self_dir."/.vim/dein.vim")

    " 無い場合、githubから取得
    if &runtimepath !~# '/dein.vim'
        if !isdirectory(s:dein_dir)
            " centos7系対応
            "execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
            execute '!git clone -b 1.0 https://github.com/Shougo/dein.vim' s:dein_dir
        endif
        execute 'set runtimepath^=' . fnamemodify(s:dein_dir, ':p')
    endif

    " 詳細設定
    let g:rc_dir    = expand(g:self_dir.'/.vim/dein.rc')
    if dein#load_state(s:dein_dir)
        call dein#begin(s:dein_dir)

        " プラグインリストを記載した TOML
        let s:toml      = g:rc_dir . '/dein.toml'
        let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

        if isdirectory(g:rc_dir)
            " TOMLのキャッシュ
            call dein#load_toml(s:toml,      {'lazy': 0})
            call dein#load_toml(s:lazy_toml, {'lazy': 1})
        endif

        " 設定終了
        call dein#end()
        call dein#save_state()
    endif

    " 設定ファイル読み込み
    try
        if filereadable(g:rc_dir."/dein.conf")
            execute 'source '.g:rc_dir."/dein.conf"
        endif
    catch
        echo 'Read error for dein.conf.toml.'
    endtry

    " 自動インストール検知
    " vimprocだけは最初にインストール
    " if dein#check_install(['vimproc'])
    "     let s:dein_install=input("Plugin(vimproc) Install? (y/n):")
    "     if s:dein_install=='y'
    "         echo "Plugin(vimproc) Install.."
    "         call dein#install(['vimproc'])
    "     else
    "         echo "Plugin don't Installed.."
    "     endif
    " endif

    " その他のインストール
    if dein#check_install()
        let s:dein_install=input("Plugin Install? (y/n):")
        if s:dein_install=='y'
            echo "Plugin Install.."
            call dein#install()
        else
            echo "Plugin don't Installed.."
        endif
    endif

endif

" コマンドショートカット
"" アップデート
command DeinUpdate :call dein#update()
"" アップデートチェック
command DeinUpdateCheck :call dein#check_update()

" }}}


" ファイルタイプ {{{
" -------------------------------------------------
"

filetype plugin on
filetype indent on

" autocmd FileType * setlocal formatoptions-=ro
autocmd BufEnter * setlocal formatoptions-=r
autocmd BufEnter * setlocal formatoptions-=o

autocmd BufNewFile,BufRead *.md             set filetype=markdown nonumber
autocmd BufNewFile,BufRead memo             set filetype=markdown nonumber
autocmd BufNewFile,BufRead *.dspec          set filetype=dspec
autocmd BufNewFile,BufRead *.procinfo       set filetype=procin
autocmd BufNewFile,BufRead *.nse            set filetype=lua
autocmd BufNewFile,BufRead *.repo           set filetype=dosini
autocmd BufNewFile,BufRead Make.def         set filetype=make
autocmd BufNewFile,BufRead *.jade           set filetype=jade
autocmd BufNewFile,BufRead jquery.*.js      set filetype=javascript syntax=jquery
autocmd BufNewFile,BufRead *.do,*.html      set filetype=php
autocmd BufNewFile,BufRead dein.conf        set filetype=vim
autocmd BufNewFile,BufRead dein.toml        set filetype=vim
autocmd BufNewFile,BufRead dein_lazy.toml   set filetype=vim
autocmd BufNewFile,BufRead *.toml           set filetype=conf

" autocmd FileType make setlocal noexpandtab
autocmd BufNewFile,BufRead make             set noexpandtab

" Dict : Java
let s:local_java_dict = expand(g:self_dir.'/.vim/dict/java.dict')
if filereadable(s:local_java_dict)
    autocmd FileType java :set dictionary=s:local_java_dict
endif

" Dict : JavaScript
let s:local_javascript_dict = expand(g:self_dir.'/.vim/dict/javascript.dict')
if filereadable(s:local_javascript_dict)
    autocmd FileType js,javascript :set dictionary=s:local_javascript_dict
endif

" Dict : perl
let s:local_perl_dict = expand(g:self_dir.'/.vim/dict/perl_base.dict')
if filereadable(s:local_perl_dict)
    autocmd FileType pl :set dictionary=s:local_perl_dict
endif

" }}}

" Coding Standards {{{
" -------------------------------------------------
"

"" Coding Standards : Ruby
:autocmd Filetype ruby set softtabstop=2
:autocmd Filetype ruby set shiftwidth=2
:autocmd Filetype ruby set tabstop=2

"" Coding Standards : Scala
:autocmd Filetype scala set softtabstop=2
:autocmd Filetype scala set shiftwidth=2
:autocmd Filetype scala set tabstop=2

" }}}
