" 使用 vim-plug 管理插件
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'      " 文件樹
Plug 'vim-scripts/TagHighlight' " 可選：語法標註
Plug 'morhetz/gruvbox' " 安裝 gruvbox
Plug 'ycm-core/YouCompleteMe'

call plug#end()

" PowerVim 快捷鍵
nnoremap ;n :NERDTreeToggle<CR>
nnoremap ;h <C-w>h
nnoremap ;l <C-w>l
nnoremap ;k <C-w>k
nnoremap ;j <C-w>j
nnoremap ;w :w<CR>

" NERDTree 和普通文檔區域都能夠通用的 ;q 快捷鍵映射
nnoremap ;q :call CloseBufferOrNERDTree()<CR>

" 定義函數來關閉 NERDTree 或當前文檔
function! CloseBufferOrNERDTree()
  " 檢查當前緩衝區的 filetype 是否為 nerdtree
  if &filetype == 'nerdtree'
    " 如果是 NERDTree，則關閉 NERDTree
    NERDTreeToggle
  else
    " 否則，關閉當前文檔
    quit
  endif
endfunction

syntax enable          " 啟用語法高亮
set background=dark    " 設置背景為暗色（根據主題而定）
colorscheme gruvbox    " 啟用 gruvbox 配色主題

set noerrorbells
set visualbell
set t_vb=

let NERDTreeShowHidden=1

autocmd StdinReadPre * let s:std_in=1

autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

autocmd BufEnter * if winnr('$') == 1 && getbufvar(winbufnr(0), '&filetype') ==# 'nerdtree' | quit | endif
