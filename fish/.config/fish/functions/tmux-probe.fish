function tmux-probe -d "探测 tmux server 是否响应：ok=正常 none=没起 hung=卡死"
    # 所有 tmux 调用都必须带超时：server 假死时（进程还在、socket 还在，
    # 但不再处理命令）任何 tmux 命令都会永久阻塞。
    # timeout -k: 先 SIGTERM，不理会再 SIGKILL，保证调用一定返回。
    command timeout -k 0.5 1 tmux list-sessions >/dev/null 2>&1 </dev/null
    set -l rc $status
    switch $rc
        case 0
            echo ok
        case 1
            echo none
        case '*'
            echo hung
    end
end
