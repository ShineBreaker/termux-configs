# tmux 会话复用 (渐进增强: 未安装 tmux 时静默跳过)
# Termux 每个新标签页都会启动登录 Fish，此处把交互式 Fish 直接替换为 tmux 客户端:
#   - 默认 (main): 所有标签页共享名为 main 的会话，断开/重启 Termux 后仍然存在
#   - tab: 每个标签页一个独立会话，之后用前缀键打开会话列表切换
#   - 0/off: 完全不自动进入，保留普通 Fish
# 已在 tmux 内 (嵌套 Fish)、非交互式调用时都不会触发，避免套娃。
# 临时切换模式: TMUX_AUTO=0 fish / TMUX_AUTO=tab fish
# 永久生效: set -Ux TMUX_AUTO tab (写入 fish universal 变量)
if status is-interactive; and not set -q TMUX; and type -q tmux
    set -l tmux_auto main
    if set -q TMUX_AUTO
        set tmux_auto "$TMUX_AUTO"
    end

    switch "$tmux_auto"
        case 0 off false no
            # 显式禁用: 保持普通 Fish
        case tab per-tab
            # 每标签页独立会话；名字带时间戳 + fish PID，避免重名
            set -l ses_name termux-(date +%m%d-%H%M%S)-$fish_pid
            exec tmux new-session -s $ses_name
        case '*'
            # 复用 main 会话: 已存在则 attach，否则新建
            exec tmux new-session -A -s main
    end
end
