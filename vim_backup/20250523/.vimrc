" 使用 vim-plug 管理插件
call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'  " 狀態列
Plug 'preservim/nerdtree'       " 文件樹
Plug 'mileszs/ack.vim'		" 搜尋工具
Plug 'vim-scripts/TagHighlight' " 可選：語法標註
Plug 'morhetz/gruvbox'          " 安裝 gruvbox
Plug 'mhinz/vim-startify'       " 啟動頁面
Plug 'github/copilot.vim'       " 新增 Copilot
Plug 'tpope/vim-fugitive'	" Git 整合
Plug 'airblade/vim-gitgutter'	" Git 狀態顯示

call plug#end()

" PowerVim 快捷鍵
nnoremap <Space> <C-w>W		  " 切換分割視窗
nnoremap ;h <C-w>h                " 移動到左邊分割視窗
nnoremap ;l <C-w>l                " 移動到右邊分割視窗
nnoremap ;k <C-w>k                " 移動到上方分割視窗
nnoremap ;j <C-w>j                " 移動到下方分割視窗
nnoremap ;w :w<CR>                " 快速儲存
nnoremap ;q :q!<CR>               " 強制關閉當前視窗
nnoremap ;s :split<CR>            " 垂直分割視窗
nnoremap ;v :vsplit<CR>           " 水平分割視窗
nnoremap ;g :Gdiff<CR>            " Git 命令
" 設置更簡單的終端模式退出按鍵
tnoremap <Esc> <C-\><C-n>

" 開啟終端機
nnoremap ;t :terminal<CR>
nnoremap ;r :NERDTreeRefreshRoot<CR> " 刷新 NERDTree 根目錄
nnoremap ;f :NERDTreeFind<CR>        " 在 NERDTree 中找到當前檔案
nnoremap ;n :NERDTreeToggle<CR>      " 切換 NERDTree 檔案樹

" 設置 Vim 的行為
set directory=~/.vim/swap//

" 自動建立目錄
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "p", 0700)
endif

set number                        " 顯示行號
set relativenumber                " 顯示相對行號
set splitbelow                    " 新分割視窗預設在下方

" 在 NERDTree 中使用 ;c 改變工作目錄並展開資料夾
autocmd FileType nerdtree nnoremap <buffer> ;c :call NERDTreeCDAndOpen()<CR>

" 在 NERDTree 中使用 CD (Shift+cd) 改變工作目錄並展開資料夾
" autocmd FileType nerdtree nnoremap <buffer> CD :call NERDTreeCDAndOpen()<CR>

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

set showcmd            " 顯示命令行
let NERDTreeShowHidden=1 " 顯示隱藏檔案
let g:NERDTreeIgnore = ["\.svn$", "\.DS_Store", "node_modules", "vendor", "\.vscode", ".Trash"]

" 自定義啟動頁面標題
let g:startify_custom_header = [
    \ '   快捷鍵指南',
    \ '   ==================',
    \ '',
    \ '   窗口導航:',
    \ '     Space - 切換到分割視窗',
    \ '     ;h - 移動到左邊分割視窗',
    \ '     ;l - 移動到右邊分割視窗',
    \ '     ;k - 移動到上方分割視窗',
    \ '     ;j - 移動到下方分割視窗',
    \ '     ;s - 水平分割視窗',
    \ '     ;v - 垂直分割視窗',
    \ '',
    \ '   檔案操作:',
    \ '     ;w - 快速儲存',
    \ '     ;q - 強制關閉當前視窗',
    \ '     ;t - 開啟終端機',
    \ '',
    \ '   NERDTree:',
    \ '     ;n - 切換 NERDTree 檔案樹',
    \ '     ;r - 刷新 NERDTree 根目錄',
    \ '     ;f - 在 NERDTree 中找到當前檔案',
    \ '     ;c - 在 NERDTree 中改變工作目錄並展開資料夾',
    \ '',
    \ '   NERDTree 內部快捷鍵:',
    \ '     o - 打開檔案或展開/折疊目錄',
    \ '     t - 在新標籤頁中打開檔案',
    \ '     i - 垂直分割視窗打開檔案',
    \ '     s - 水平分割視窗打開檔案',
    \ '     I - 切換隱藏檔案顯示',
    \ '     R - 刷新當前目錄',
    \ '     m - 顯示檔案系統選單 (新增/刪除/移動)',
    \ '     ? - 切換說明文檔',
    \ '',
    \ ]

let g:startify_lists = [
    \ { 'type': 'files', 'header': ['   最近檔案'] },
    \ { 'type': 'bookmarks', 'header': ['   書籤'] },
    \ ]

let g:startify_bookmarks = [
    \ { 'i': '~/.vimrc' },
    \ { 't': '~/.tmux.conf' },
    \ { 'z': '~/.zshrc' },
    \ ]

" 自定義腳注
let g:startify_custom_footer = [
    \ '   Happy coding!',
    \ ]

" 確保 Startify 總是首先顯示
autocmd VimEnter *
    \ if !argc()
    \ |   Startify
    \ |   NERDTree
    \ |   wincmd w
    \ | endif

autocmd StdinReadPre * let s:std_in=1 " 標記是否從 stdin 讀取

" 啟動時自動開啟 NERDTree（若無檔案參數）
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" 若只剩 NERDTree 視窗則自動關閉 Vim
" autocmd BufEnter * 
    \ if winnr('$') == 1 && getbufvar(winbufnr(0), '&filetype') ==# 'nerdtree' 
    \ | quit 
    \ | endif

augroup NERDTreeStartify
    autocmd!
    autocmd BufEnter *
        \ if winnr('$') == 1 && getbufvar(winbufnr(0), '&filetype') ==# 'nerdtree'
        \ |   Startify       
        \ |   NERDTree       
        \ |   wincmd w 
	\ | endif
augroup END

" 在 NERDTree 視窗時 ;q 直接關閉 Vim
autocmd FileType nerdtree nnoremap <buffer> ;q :qa!<CR>

" 在終端模式下將 Shift+Space 映射為 <C-\><C-n> (切換到普通模式)
if has('terminal')
  tnoremap <S-Space> <C-\><C-n>
endif

" 更新標記的頻率（毫秒，默認為 4000）
set updatetime=100

" 自定義標記符號
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'
let g:gitgutter_sign_removed_first_line = '^'
let g:gitgutter_sign_modified_removed = '~-'

" 啟用/禁用修改標記列的顏色（高亮）
let g:gitgutter_highlight_lines = 0
let g:gitgutter_highlight_linenrs = 1

" highlight GitGutterAdd    ctermfg=blue
" highlight GitGutterChange ctermfg=green
" highlight GitGutterDelete ctermfg=red

" 設置標記欄總是可見
set signcolumn=yes

" 啟用 vim-gitgutter 的調試模式
let g:gitgutter_log = 1

" 在啟動時自動啟用 GitGutter
autocmd VimEnter * GitGutterEnable
