function dot --description 'Dotfiles 管理 (转发给 ~/.local/bin/dot)'
    # cd 必须在当前 shell 中执行，其余命令转发给 bin 包链接的脚本
    if test "$argv[1]" = cd
        set -l dir (command dot path); and cd $dir
    else
        command dot $argv
    end
end
