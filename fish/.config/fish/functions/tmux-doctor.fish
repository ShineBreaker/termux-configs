function tmux-doctor -d "tmux server 无响应时给出选项：清除僵死进程并重试 / 跳过"
    # 场景：Termux 被系统冻结或强杀后，残留的 tmux server 变成「假死」——
    # 进程还在、socket 还在，但不再处理任何命令。此时任何 tmux 命令都会永久
    # 阻塞，开新标签页就会卡在 Fish 启动上。
    #
    # 本函数只做「诊断 + 交互式处置」：给出清除并重试 / 跳过的选项，
    # 无论选哪个，Fish 都会正常打开（tmux 只是「进不去」，绝不拖垮 shell）。

    set -l probe (tmux-probe)
    if test "$probe" != hung
        echo "[tmux] server $probe，无需处理"
        return 0
    end

    printf '\n'
    printf '  %s[tmux]%s server 无响应（可能被系统冻结，tmux 命令会一直卡住）\n' (set_color -o yellow) (set_color normal)
    printf '        %sr%s 清除僵死进程并重试    %ss%s 跳过本次（进入普通 Fish）%s\n' \
        (set_color -o green) (set_color normal) (set_color -o yellow) (set_color normal) (set_color normal)
    printf '        选择 > '

    # 读一个字符；15 秒无人应答就当作跳过（避免无人值守时卡在启动阶段）
    set -l ans (command timeout -k 1 15 bash -c 'IFS= read -r -n 1 a 2>/dev/null; printf "%s" "$a"' 2>/dev/null)
    printf '\n'

    if not contains -- "$ans" r R
        echo "  [tmux] 已跳过自动进入（普通 Fish 正常可用；随时可执行 tmux-doctor 重试）"
        return 1
    end

    echo "  [tmux] 清除僵死进程…"
    # 先礼后兵：优雅关闭 -> 强杀残留（被系统冻结的进程只有 SIGKILL 才吃）
    command timeout -k 0.5 1 tmux kill-server >/dev/null 2>&1 </dev/null
    command pkill -9 -x tmux >/dev/null 2>&1
    sleep 0.3

    set probe (tmux-probe)
    if test "$probe" = hung
        echo "  [tmux] 仍然无响应，已跳过自动进入（普通 Fish 正常可用）"
        return 1
    end

    echo "  [tmux] 已恢复（$probe）"
    return 0
end
