# 启动欢迎消息
function fish_greeting
    if type -q fastfetch
        fastfetch
    else
        echo "Fish Shell"
    end
end

# 设置提示符 (starship 已在 00-init.fish 中接管，此处为简版回退)
if not type -q starship
function fish_prompt
    set -l last_status $status
    set -l cwd (prompt_pwd)

    # 状态颜色 (须在块外声明，块内的 set -l 会在 end 之后失效)
    set -l status_color
    if test $last_status -eq 0
        set status_color (set_color green)
    else
        set status_color (set_color red)
    end

    # 显示提示符
    echo -n (set_color cyan)$cwd(set_color normal)
    echo -n ' '
    echo -n $status_color'❯'(set_color normal)
    echo -n ' '
end
end
