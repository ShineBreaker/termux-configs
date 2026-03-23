# 启动欢迎消息
function fish_greeting
    if type -q fastfetch
        fastfetch
    else
        echo "Fish Shell"
    end
end

# 设置提示符
function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd)

    # 状态颜色
    if test $last_status -eq 0
        set -l status_color (set_color green)
    else
        set -l status_color (set_color red)
    end

    # 显示提示符
    echo -n (set_color cyan)$cwd(set_color normal)
    echo -n ' '
    echo -n $status_color'❯'(set_color normal)
    echo -n ' '
end
