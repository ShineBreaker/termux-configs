# Fish Shell 配置文件
# Termux 优化配置

# 设置环境变量
set -gx EDITOR nano
set -gx VISUAL nano
set -gx LANG en_US.UTF-8
set -gx TERM xterm-256color

# 设置路径
set -gx PATH $PATH $HOME/.local/bin

# 移动友好缩写
abbr -a .. 'cd ..'
abbr -a ... 'cd ../..'
abbr -a ~ 'cd ~'
abbr -a l 'ls -la'
abbr -a ll 'ls -l'
abbr -a la 'ls -la'
abbr -a lt 'ls -lt'

# 包管理缩写
abbr -a pkgi 'pkg install'
abbr -a pkgu 'pkg update && pkg upgrade'
abbr -a pkgs 'pkg search'
abbr -a pkgl 'pkg list-installed'

# Git 缩写
abbr -a g 'git'
abbr -a gs 'git status'
abbr -a ga 'git add'
abbr -a gc 'git commit -m'
abbr -a gp 'git push'
abbr -a gl 'git pull'
abbr -a gd 'git diff'

# 其他缩写
abbr -a c 'clear'
abbr -a q 'exit'
abbr -a h 'history'

# Fastfetch 缩写
abbr -a ff 'fastfetch'
abbr -a ffmini 'fastfetch --config config-compact.jsonc'
abbr -a fffull 'fastfetch'
abbr -a ffcfg 'nano ~/.config/fastfetch/config.jsonc'
abbr -a ffcfgmini 'nano ~/.config/fastfetch/config-compact.jsonc'

# 编辑配置缩写
abbr -a fishrc 'nano ~/.config/fish/config.fish'
abbr -a termuxrc 'nano ~/.termux/termux.properties'

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
