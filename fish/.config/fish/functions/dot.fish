function dot --description 'Dotfiles 管理 (转发给 ~/.local/bin/dot)'
    # cd 必须在当前 shell 中执行，其余命令转发给 bin 包链接的脚本
    if not command -q dot
        echo "外部 dot 命令未找到，请先在仓库目录执行 stow -t ~ bin 链接 bin 包"
        return 1
    end
    if test "$argv[1]" = cd
        set -l dir (command dot path); and cd $dir
    else
        command dot $argv
    end
end
