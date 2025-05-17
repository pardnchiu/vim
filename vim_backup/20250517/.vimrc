" 使用 vim-plug 管理插件
call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree'       " 文件樹
Plug 'vim-scripts/TagHighlight' " 可選：語法標註
Plug 'morhetz/gruvbox'          " 安裝 gruvbox
Plug 'github/copilot.vim'       " 新增 Copilot

call plug#end()

" PowerVim 快捷鍵
nnoremap ;n :NERDTreeToggle<CR>   " 切換 NERDTree 檔案樹
nnoremap ;h <C-w>h                " 移動到左邊分割視窗
nnoremap ;l <C-w>l                " 移動到右邊分割視窗
nnoremap ;k <C-w>k                " 移動到上方分割視窗
nnoremap ;j <C-w>j                " 移動到下方分割視窗
nnoremap ;w :w<CR>                " 快速儲存
nnoremap ;q :q!<CR>               " 強制關閉當前視窗
nnoremap ;s :split<CR>            " 水平分割視窗
nnoremap ;v :vsplit<CR>           " 垂直分割視窗
nnoremap ;t :terminal<CR>         " 創建5行高的終端快捷鍵
nnoremap ;r :NERDTreeRefreshRoot<CR> " 刷新 NERDTree 根目錄

" 在終端模式下使用 ; 加方向進行視窗切換
tnoremap ;h <C-\><C-n><C-w>h      " 終端模式下移動到左邊分割視窗
tnoremap ;j <C-\><C-n><C-w>j      " 終端模式下移動到下方分割視窗
tnoremap ;k <C-\><C-n><C-w>k      " 終端模式下移動到上方分割視窗
tnoremap ;l <C-\><C-n><C-w>l      " 終端模式下移動到右邊分割視窗

set number                        " 顯示行號
set relativenumber                " 顯示相對行號
set splitbelow                    " 新分割視窗預設在下方

" 在 NERDTree 中使用 ;c 改變工作目錄並展開資料夾
autocmd FileType nerdtree nnoremap <buffer> ;c :call NERDTreeCDAndOpen()<CR>

" 在 NERDTree 中使用 CD (Shift+cd) 改變工作目錄並展開資料夾
autocmd FileType nerdtree nnoremap <buffer> CD :call NERDTreeCDAndOpen()<CR>

" 自訂函式：切換 NERDTree 目錄並展開
function! NERDTreeCDAndOpen()
  if exists('g:NERDTreeFileNode') && !empty(g:NERDTreeFileNode.GetSelected())
    let node = g:NERDTreeFileNode.GetSelected()
    if node.path.isDirectory
      execute 'cd' fnameescape(node.path.str())
      execute 'NERDTreeCWD'
      echo "Changed directory to: " . node.path.str() . " and opened folder"
    else
      echo "Not a directory"
    endif
  else
    echo "No node selected"
  endif
endfunction

syntax enable          " 啟用語法高亮
set background=dark    " 設置背景為暗色（根據主題而定）
colorscheme gruvbox    " 啟用 gruvbox 配色主題

set noerrorbells       " 關閉錯誤提示音
set visualbell         " 使用視覺提示取代聲音
set t_vb=              " 禁用終端響鈴

let NERDTreeShowHidden=1 " 顯示隱藏檔案

autocmd StdinReadPre * let s:std_in=1 " 標記是否從 stdin 讀取

" 啟動時自動開啟 NERDTree（若無檔案參數）
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" 若只剩 NERDTree 視窗則自動關閉 Vim
autocmd BufEnter * if winnr('$') == 1 && getbufvar(winbufnr(0), '&filetype') ==# 'nerdtree' | quit | endif

" 在 NERDTree 視窗時 ;q 直接關閉 Vim
autocmd FileType nerdtree nnoremap <buffer> ;q :qa!<CR>