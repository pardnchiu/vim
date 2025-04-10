#!/bin/bash
# vim_restore.sh - 還原 Vim 配置的獨立腳本

# 獲取腳本所在目錄的絕對路徑
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 檢查是否提供了備份目錄參數
if [ $# -eq 1 ]; then
    BACKUP_DIR="$1"
    # 檢查提供的路徑是否存在
    if [ ! -d "$BACKUP_DIR" ]; then
        echo "錯誤: 指定的備份目錄 '$BACKUP_DIR' 不存在"
        exit 1
    fi
else
    # 默認使用腳本所在目錄
    BACKUP_DIR="$SCRIPT_DIR"
    echo "未指定備份目錄，將使用腳本所在目錄: $BACKUP_DIR"
fi

echo "開始從 $BACKUP_DIR 還原 Vim 配置"

# 檢查必要的備份文件
if [ ! -f "$BACKUP_DIR/.vimrc" ]; then
    echo "錯誤: 找不到 .vimrc 備份文件 (在 $BACKUP_DIR/.vimrc)"
    exit 1
fi

if [ ! -d "$BACKUP_DIR/vim" ] && [ ! -d "$BACKUP_DIR/.vim" ]; then
    echo "錯誤: 找不到 .vim 目錄備份 (在 $BACKUP_DIR/vim 或 $BACKUP_DIR/.vim)"
    exit 1
fi

# 確定 vim 目錄路徑
if [ -d "$BACKUP_DIR/vim" ]; then
    VIM_DIR="$BACKUP_DIR/vim"
else
    VIM_DIR="$BACKUP_DIR/.vim"
fi

# 詢問用戶是否確認還原
echo "將從以下路徑還原 Vim 配置:"
echo "  .vimrc: $BACKUP_DIR/.vimrc"
echo "  .vim 目錄: $VIM_DIR"
echo "這將覆蓋你當前的 Vim 配置。確定要繼續嗎? (y/n)"
read -r confirm

if [ "$confirm" != "y" ]; then
    echo "還原已取消"
    exit 0
fi

# 備份當前配置
CURRENT_DATE=$(date +"%Y%m%d_%H%M%S")
CURRENT_BACKUP_DIR="$HOME/.vim_old_$CURRENT_DATE"

mkdir -p "$CURRENT_BACKUP_DIR"
echo "將當前配置備份到: $CURRENT_BACKUP_DIR"

if [ -f "$HOME/.vimrc" ]; then
    cp "$HOME/.vimrc" "$CURRENT_BACKUP_DIR/.vimrc"
fi

if [ -d "$HOME/.vim" ]; then
    cp -r "$HOME/.vim" "$CURRENT_BACKUP_DIR/.vim"
fi

# 還原 .vimrc 文件
cp "$BACKUP_DIR/.vimrc" "$HOME/.vimrc"
echo "已還原 .vimrc 文件"

# 還原 .vim 目錄
mkdir -p "$HOME/.vim"
# 首先清空目標目錄，但保留創建的目錄結構
find "$HOME/.vim" -mindepth 1 -delete 2>/dev/null

# 複製所有文件
cp -r "$VIM_DIR/"* "$HOME/.vim/" 2>/dev/null
cp -r "$VIM_DIR/."* "$HOME/.vim/" 2>/dev/null
echo "已還原 .vim 目錄"

# # 檢查 YouCompleteMe 是否存在
# if [ -d "$HOME/.vim/plugged/YouCompleteMe" ]; then
#     echo "檢測到 YouCompleteMe 插件，正在使用 --all 選項重新編譯..."
#     cd "$HOME/.vim/plugged/YouCompleteMe" || exit
#     python3 install.py --all
    
#     if [ $? -eq 0 ]; then
#         echo "YouCompleteMe 編譯成功"
#     else
#         echo "YouCompleteMe 編譯失敗，請手動檢查"
#         echo "可能需要手動運行: cd $HOME/.vim/plugged/YouCompleteMe && python3 install.py --all"
#     fi
# fi

# 檢查是否需要安裝插件
if [ -f "$HOME/.vimrc" ]; then
    if grep -q "plug#begin" "$HOME/.vimrc"; then
        echo "檢測到 vim-plug 配置，是否要安裝所有插件? (y/n)"
        read -r install_plugins
        
        if [ "$install_plugins" = "y" ]; then
            echo "正在安裝插件..."
            vim +PlugInstall +qall
            echo "插件安裝完成"
        fi
    fi
fi

echo "Vim 配置還原完成!"
echo "若恢復失敗，你的原始配置已備份到: $CURRENT_BACKUP_DIR"