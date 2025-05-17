" 使用 vim-plug 管理插件
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'       " 文件樹
Plug 'vim-scripts/TagHighlight' " 可選：語法標註
Plug 'morhetz/gruvbox'          " 安裝 gruvbox

call plug#end()

" PowerVim 快捷鍵
nnoremap ;n :NERDTreeToggle<CR>
nnoremap ;h <C-w>h
nnoremap ;l <C-w>l
nnoremap ;k <C-w>k
nnoremap ;j <C-w>j
nnoremap ;w :w<CR>
nnoremap ;s :split<CR>
nnoremap ;v :vsplit<CR>

" 在終端模式下使用 ; 加方向進行視窗切換
tnoremap ;h <C-\><C-n><C-w>h
tnoremap ;j <C-\><C-n><C-w>j
tnoremap ;k <C-\><C-n><C-w>k
tnoremap ;l <C-\><C-n><C-w>l

set number
set relativenumber

" 確保新分割出現在底部
set splitbelow
" 創建5行高的終端快捷鍵
nnoremap ;t :terminal<CR>

" 添加刷新 NERDTree 的快捷鍵
nnoremap ;r :NERDTreeRefreshRoot<CR>

" 在 NERDTree 中使用 ;c 改變工作目錄並展開資料夾
autocmd FileType nerdtree nnoremap <buffer> ;c :call NERDTreeCDAndOpen()<CR>

" 在 NERDTree 中使用 CD (Shift+cd) 改變工作目錄並展開資料夾
autocmd FileType nerdtree nnoremap <buffer> CD :call NERDTreeCDAndOpen()<CR>

function! NERDTreeCDAndOpen()
  let node = g:NERDTreeFileNode.GetSelected()
  if node.path.isDirectory
    " 改變工作目錄
    call nerdtree#ui_glue#chDirIfOptionSet(node.path.str())
    " 打開目錄
    call node.open()
    echo "Changed directory to: " . node.path.str() . " and opened folder"
  else
    echo "Not a directory"
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
