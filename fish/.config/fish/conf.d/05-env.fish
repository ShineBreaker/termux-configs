# 设置环境变量
set -gx EDITOR hx
set -gx VISUAL hx
set -gx LANG zh_CN.UTF-8
set -gx TERM xterm-256color

# 设置路径
fish_add_path -a -g $HOME/.local/bin
