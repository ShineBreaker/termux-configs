# 设置环境变量
# 编辑器降级检测: hx -> nano -> vi，未安装时不留空
if type -q hx
    set -gx EDITOR hx
    set -gx VISUAL hx
else if type -q nano
    set -gx EDITOR nano
    set -gx VISUAL nano
else
    set -gx EDITOR vi
    set -gx VISUAL vi
end
set -gx LANG zh_CN.UTF-8
# 仅在未处于 tmux 时设置，避免覆盖 tmux 所需的 TERM (screen-256color 等)
if not set -q TMUX
    set -gx TERM xterm-256color
end

# 设置路径
fish_add_path -a -g $HOME/.local/bin
