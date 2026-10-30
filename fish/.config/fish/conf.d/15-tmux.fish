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
# fish 启动就卡死 (tab-name 取名、MOTD 查会话都是这么卡的)。
# 因此本文件所有 tmux 调用一律加超时 (timeout -k: SIGTERM 无效再 SIGKILL)，
# 进入前先用 tmux-probe 探活；探到假死就交给 tmux-doctor 交互处理
# (清除僵死进程并重试 / 跳过)。**无论选哪个，Fish 都会正常打开**——
# tmux 只是「进不去」，绝不允许它把 shell 拖死。

if status is-interactive; and not set -q TMUX; and type -q tmux

    set -l tmux_auto main
    if set -q TMUX_AUTO
        set tmux_auto "$TMUX_AUTO"
    end

    switch "$tmux_auto"
        case 0 off false no
            # 显式禁用: 保持普通 Fish
        case '*'
            # 1) 探活: server 卡死就交给 tmux-doctor (交互: 清除并重试 / 跳过)
            set -l probe (tmux-probe)
            if test "$probe" = hung
                tmux-doctor
                set probe (tmux-probe)
            end

            if test "$probe" = hung
                # 仍然无响应: 不进 tmux, 但 Fish 正常继续 (绝不卡住启动)
                echo "[tmux] server 无响应，已跳过自动进入（普通 Fish 正常可用）" >&2
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
                # 分两步且每步都带超时: 先后台建会话 -> 确认 server 仍然响应 ->
                #    才 exec 接管终端。这样即使 server 在最后一步假死, Fish 也
                #    一定能正常打开 (最坏情况只是不进 tmux)。
                switch "$tmux_auto"
                    case tab per-tab
                        # 每标签页完全独立: 窗口与历史都不共享，会话名同样可读且唯一
                        command timeout -k 2 5 tmux new-session -d -s "$tab_name"
                        if test (tmux-probe) = ok
                            exec tmux attach-session -t "$tab_name"
                        else
                            echo "[tmux] 接管会话失败，已保留普通 Fish（可执行 tmux attach -t $tab_name 接管）" >&2
                        end
                    case '*'
                        # 默认: main 是共享窗口的锚点，标签页本身作为分组会话挂上去，
                        # 于是每个标签页有自己的当前窗口，但窗口/历史仍是同一套
                        if test "$probe" = none
                            command timeout -k 2 5 tmux new-session -d -s main
                        else
                            command timeout -k 1 2 tmux has-session -t =main >/dev/null 2>&1
                            or command timeout -k 2 5 tmux new-session -d -s main
                        end
                        command timeout -k 2 5 tmux new-session -d -t =main -s "$tab_name"
                        if test (tmux-probe) = ok
                            exec tmux attach-session -t "$tab_name"
                        else
                            echo "[tmux] 接管会话失败，已保留普通 Fish（可执行 tmux attach -t $tab_name 接管）" >&2
                        end
                end
            end
    end
end
