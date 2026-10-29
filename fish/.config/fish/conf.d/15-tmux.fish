# tmux 会话复用 (渐进增强: 未安装 tmux 时静默跳过)
# Termux 每个新标签页都会启动登录 Fish，此处把交互式 Fish 直接替换为 tmux 客户端。
# 每个标签页都会拿到一个人类可读且唯一的会话名 (如 calm-otter，见
# ~/.config/tmux/scripts/tab-name)，状态栏左侧、终端标题、`tmux ls`、MOTD
# 都用它来区分标签页，比 pts/N 之类的客户端号好认。
#   - 默认 (main): 标签页共享 main 的窗口与历史 (分组会话，各自独立选中窗口)，
#                  关掉标签页/重启 Termux 后窗口仍在
#   - tab: 每个标签页一个完全独立的新会话 (窗口与历史都不共享)
#   - 0/off: 完全不自动进入，保留普通 Fish
# 已在 tmux 内 (嵌套 Fish)、非交互式调用时都不会触发，避免套娃。
# 临时切换模式: TMUX_AUTO=0 fish / TMUX_AUTO=tab fish
# 永久生效: set -Ux TMUX_AUTO tab (写入 fish universal 变量)
# 自定义标签页名: TMUX_TAB_NAME=work fish
#
# 【超时护栏】Termux 被系统冻结/强杀后，残留的 tmux server 可能变成「假死」：
# 进程还在、socket 还在，但不再处理任何命令。此时任何 tmux 命令都会**永久阻塞**，
# fish 启动就卡死 (tab-name 取名、MOTD 查询会话都是这么卡的)。
# 因此本文件所有 tmux 调用一律加超时: timeout -k <宽限> <时长>
#   -k: 先发 SIGTERM，若进程不理会再发 SIGKILL，保证调用一定会返回
# 进入 tmux 前还会先探活；探到假死就清掉旧 server 重建，绝不让 shell 卡住。

if status is-interactive; and not set -q TMUX; and type -q tmux

    # ---- server 探活 / 自愈 ------------------------------------------------
    function __tmux_probe
        # ok = 有 server 且响应; none = 没有 server; hung = server 卡死不响应
        # 健康时 tmux 是毫秒级返回，1 秒还没回来说明已经假死
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

    function __tmux_recover
        # 先礼后兵: 优雅关闭 -> 强杀残留 (被系统冻结的进程只有 SIGKILL 才吃)
        command timeout -k 0.5 1 tmux kill-server >/dev/null 2>&1 </dev/null
        command pkill -9 -x tmux >/dev/null 2>&1
        sleep 0.3
    end

    set -l tmux_auto main
    if set -q TMUX_AUTO
        set tmux_auto "$TMUX_AUTO"
    end

    switch "$tmux_auto"
        case 0 off false no
            # 显式禁用: 保持普通 Fish
        case '*'
            # 1) 探活: server 卡死先自愈，自愈不了就放弃进入 (宁可普通 fish 也不卡)
            set -l probe (__tmux_probe)
            if test "$probe" = hung
                __tmux_recover
                set probe (__tmux_probe)
            end

            if test "$probe" = hung
                echo "[tmux] server 无响应，已跳过自动进入 (TMUX_AUTO=0 可关闭本提示)" >&2
            else
                # 2) 取标签页名: tmux 配置包提供 tab-name 脚本，未链接该包时退回随机名
                set -l tab_name
                set -l name_script ~/.config/tmux/scripts/tab-name
                if test -f "$name_script"
                    # 输出走临时文件: 避免 tmux 派生的进程长期持有管道导致读端卡住
                    set -l tmp (mktemp)
                    command timeout -k 2 5 bash "$name_script" >$tmp 2>/dev/null
                    set -l names (cat $tmp)
                    if test (count $names) -gt 0
                        set tab_name $names[1]
                    end
                    rm -f $tmp
                end
                if test -z "$tab_name"
                    set tab_name tab-(random)
                end

                # 3) 防止 Termux 应用被系统冻结 (冻结会让 server 假死)，可关
                set -l wake 1
                if set -q TMUX_WAKE_LOCK
                    set wake "$TMUX_WAKE_LOCK"
                end
                if test "$wake" != 0; and type -q termux-wake-lock
                    command termux-wake-lock >/dev/null 2>&1
                end

                # 4) 进入 tmux
                switch "$tmux_auto"
                    case tab per-tab
                        # 每标签页完全独立: 窗口与历史都不共享，会话名同样可读且唯一
                        exec tmux new-session -s "$tab_name"
                    case '*'
                        # 默认: main 是共享窗口的锚点，标签页本身作为分组会话挂上去，
                        # 于是每个标签页有自己的当前窗口，但窗口/历史仍是同一套
                        if test "$probe" = none
                            command timeout -k 2 5 tmux new-session -d -s main
                        else
                            command timeout -k 1 2 tmux has-session -t =main >/dev/null 2>&1
                            or command timeout -k 2 5 tmux new-session -d -s main
                        end
                        exec tmux new-session -t =main -s "$tab_name"
                end
            end
    end
end
