# 移动友好缩写
abbr -a '..' -- 'cd ..'
abbr -a '...' -- 'cd ../..'
abbr -a '~' -- 'cd ~'
abbr -a l -- 'ls -la'
abbr -a ll -- 'ls -l'
abbr -a la -- 'ls -la'
abbr -a lt -- 'ls -lt'

# 包管理缩写
abbr -a pkgi -- 'oma install'
abbr -a pkgu -- 'oma update && pkg upgrade'
abbr -a pkgs -- 'oma search'
abbr -a pkgl -- 'oma list'

# Git 缩写
abbr -a g -- 'git'
abbr -a gs -- 'git status'
abbr -a ga -- 'git add'
abbr -a gc -- 'git commit -m'
abbr -a gp -- 'git push'
abbr -a gl -- 'git pull'
abbr -a gd -- 'git diff'

# 其他缩写
abbr -a c -- 'clear'
abbr -a q -- 'exit'
abbr -a h -- 'history'

# 仅在 zoxide 已安装时定义 cd 缩写，避免 zoxide 缺失时 cd 彻底失效 (渐进增强)
if type -q zoxide
    abbr -a cd -- 'z'
end

# Fastfetch 缩写
abbr -a ff -- 'fastfetch'
abbr -a ffmini -- 'fastfetch --config ~/.config/fastfetch/config-compact.jsonc'
abbr -a fffull -- 'fastfetch --config ~/.config/fastfetch/config.jsonc'
abbr -a ffcfg -- '$EDITOR ~/.config/fastfetch/config.jsonc'
abbr -a ffcfgmini -- '$EDITOR ~/.config/fastfetch/config-compact.jsonc'

# 编辑配置缩写
abbr -a fishrc -- '$EDITOR ~/.config/fish/config.fish'
abbr -a termuxrc -- '$EDITOR ~/.termux/termux.properties'
