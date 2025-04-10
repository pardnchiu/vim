#!/bin/bash
# vim_backup_only.sh - 只備份 Vim 配置，不生成還原腳本

# 設定備份目錄為當前目錄，只用日期命名（不含時間）
BACKUP_DIR="$(pwd)/vim_backup"
BACKUP_DATE=$(date +"%Y%m%d")
BACKUP_FULL_PATH="$BACKUP_DIR/$BACKUP_DATE"

# 如果目錄已存在，先刪除舊的備份
if [ -d "$BACKUP_FULL_PATH" ]; then
    echo "發現同日期的備份，將先刪除舊備份..."
    rm -rf "$BACKUP_FULL_PATH"
fi

# 建立備份目錄
mkdir -p "$BACKUP_FULL_PATH"

# 顯示備份開始訊息
echo "開始備份 Vim 配置到: $BACKUP_FULL_PATH"

# 備份 .vimrc 文件
if [ -f "$HOME/.vimrc" ]; then
    cp "$HOME/.vimrc" "$BACKUP_FULL_PATH/.vimrc"
    echo "已備份 .vimrc 文件"
else
    echo "警告: 找不到 .vimrc 文件"
fi

# 備份整個 .vim 目錄
if [ -d "$HOME/.vim" ]; then
    cp -r "$HOME/.vim" "$BACKUP_FULL_PATH/vim"
    echo "已備份 .vim 目錄"
else
    echo "警告: 找不到 .vim 目錄"
fi

# 創建一個文件記錄 YouCompleteMe 的配置情況
if [ -d "$HOME/.vim/plugged/YouCompleteMe" ]; then
    echo "檢測到 YouCompleteMe 插件，記錄其狀態"
    echo "YouCompleteMe 插件存在於配置中" > "$BACKUP_FULL_PATH/ycm_info.txt"
    
    # 記錄已安裝的補全器
    echo "安裝命令提示: cd ~/.vim/plugged/YouCompleteMe && python3 install.py --all" >> "$BACKUP_FULL_PATH/ycm_info.txt"
    echo "" >> "$BACKUP_FULL_PATH/ycm_info.txt"
    
    # 如果有 third_party 目錄，記錄其中的補全器
    if [ -d "$HOME/.vim/plugged/YouCompleteMe/third_party" ]; then
        echo "已安裝的補全器:" >> "$BACKUP_FULL_PATH/ycm_info.txt"
        ls -la "$HOME/.vim/plugged/YouCompleteMe/third_party" >> "$BACKUP_FULL_PATH/ycm_info.txt"
    fi
fi

# 記錄使用的插件
if [ -f "$HOME/.vimrc" ]; then
    echo "正在記錄已使用的插件..."
    grep -i "Plug '" "$HOME/.vimrc" > "$BACKUP_FULL_PATH/plugins_list.txt" 2>/dev/null
    grep -i 'Plug "' "$HOME/.vimrc" >> "$BACKUP_FULL_PATH/plugins_list.txt" 2>/dev/null
    
    if [ -s "$BACKUP_FULL_PATH/plugins_list.txt" ]; then
        echo "已記錄插件清單到 plugins_list.txt"
    else
        echo "未找到使用 vim-plug 管理的插件，或格式不匹配"
    fi
fi

# # 創建一個可攜帶的壓縮包，並且覆蓋舊的
# tar -czf "$BACKUP_DIR/vim_backup_$BACKUP_DATE.tar.gz" -C "$BACKUP_DIR" "$BACKUP_DATE"
# echo "已創建可攜帶的備份壓縮包: $BACKUP_DIR/vim_backup_$BACKUP_DATE.tar.gz"

echo "備份完成!"
echo "備份位置: $BACKUP_FULL_PATH"
echo "壓縮包位置: $BACKUP_DIR/vim_backup_$BACKUP_DATE.tar.gz"