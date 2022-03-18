" 折り返しを有効にする "set wrap

" 80文字で折り返す
" set textwidth=80

" マルチバイト文字の場合も折り返しを有効にする
"set formatoptions+=m

" 行番号を削除
set nonumber

" todoリストを簡単に入力する
abbreviate tl - [ ]
abbreviate tll [ ]

" 折りたたみ禁止
set foldmethod=syntax
let g:perl_fold=1
set foldlevel=100 "Don't autofold anything

" todoリストのon/offを切り替える
nnoremap <buffer> <Leader><Leader> :call ToggleCheckbox()<CR>
vnoremap <buffer> <Leader><Leader> :call ToggleCheckbox()<CR>

" 選択行のチェックボックスを切り替える
function! ToggleCheckbox()
  let l:line = getline('.')
  if l:line =~ '\-\s\[\s\]'
    " 完了時刻を挿入する
    let l:result = substitute(l:line, '-\s\[\s\]', '- [>]', '')
    call setline('.', l:result)
  elseif l:line =~ '\-\s\[>\]'
    " 完了時刻を挿入する
    let l:result = substitute(l:line, '-\s\[>\]', '- [x]', '') . ' [' . strftime("%Y/%m/%d (%a) %H:%M") . ']'
    call setline('.', l:result)
  elseif l:line =~ '\-\s\[x\]'
    let l:result = substitute(substitute(l:line, '-\s\[x\]', '- [-]', ''), '\s\[\d\{4}.\+]$', '', '')
    call setline('.', l:result)
  elseif l:line =~ '\-\s\[.\]'
    let l:result = substitute(l:line, '-\s\[.\]', '- [ ]', '')
    call setline('.', l:result)
  end
endfunction

" NeadTree設定
autocmd VimEnter * NERDTree | wincmd p
