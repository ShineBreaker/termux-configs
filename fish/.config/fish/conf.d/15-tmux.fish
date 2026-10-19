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
if status is-interactive; and not set -q TMUX; and type -q tmux
    set -l tmux_auto main
    if set -q TMUX_AUTO
        set tmux_auto "$TMUX_AUTO"
    end

    # 取标签页名: tmux 配置包提供 tab-name 脚本，未链接该包时退回随机名
    set -l tab_name
    set -l name_script ~/.config/tmux/scripts/tab-name
    if test -f "$name_script"
        set tab_name (command bash "$name_script")
    end
    if test -z "$tab_name"
        set tab_name tab-(random)
    end

    switch "$tmux_auto"
        case 0 off false no
            # 显式禁用: 保持普通 Fish
        case tab per-tab
            # 每标签页完全独立: 窗口与历史都不共享，会话名同样可读且唯一
            exec tmux new-session -s "$tab_name"
        case '*'
            # 默认: main 是共享窗口的锚点，标签页本身作为分组会话挂上去，
            # 于是每个标签页有自己的当前窗口，但窗口/历史仍是同一套
            if not tmux has-session -t =main 2>/dev/null
                tmux new-session -d -s main
            end
            exec tmux new-session -t =main -s "$tab_name"
    end
end
