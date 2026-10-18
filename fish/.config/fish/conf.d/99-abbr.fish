# 导航缩写
abbr -a '..' -- 'cd ..'
abbr -a '...' -- 'cd ../..'
abbr -a '~' -- 'cd ~'
abbr -a l -- 'ls -la'
# ll 与桌面一致: 长列表含隐藏文件
abbr -a ll -- 'ls -la'
abbr -a la -- 'ls -la'
# lt 按时间排序: eza 与 ls 的排序参数不同，按是否安装分别定义
if type -q eza
    abbr -a lt -- 'ls -l --sort=modified'
else
    abbr -a lt -- 'ls -lt'
end

# 包管理缩写
abbr -a pkgi -- 'oma install'
abbr -a pkgu -- 'oma update && pkg upgrade'
abbr -a pkgs -- 'oma search'
abbr -a pkgl -- 'oma list'

# Git 缩写 (g* 为移动端紧凑组合; cm/cmall/push/clone 与桌面保持一致)
abbr -a g -- 'git'
abbr -a gs -- 'git status'
abbr -a ga -- 'git add'
abbr -a gc -- 'git commit -m'
abbr -a gp -- 'git push'
abbr -a gl -- 'git pull'
abbr -a gd -- 'git diff'
abbr -a cm -- 'git commit'
# 桌面为 git commit --all -S；Termux 默认不依赖 GPG 签名，如需签名自行加 -S
abbr -a cmall -- 'git commit --all'
abbr -a push -- 'git push'
abbr -a clone -- 'git clone'

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
abbr -a helixrc -- '$EDITOR ~/.config/helix/config.toml'
abbr -a starshiprc -- '$EDITOR ~/.config/starship.toml'
abbr -a atuinrc -- '$EDITOR ~/.config/atuin/config.toml'
abbr -a gitrc -- '$EDITOR ~/.config/git/config'

# 与桌面同名习惯: 在终端内打开 Emacs
abbr -a ee -- 'emacsclient --tty --alternate-editor=""'

# Tailscale 远程登录缩写 (仅 tailscale 已安装时定义)
# 电脑的用户名/节点名如变化，改这一行即可
if type -q tailscale
    abbr -a enter -- 'tailscale ssh brokenshine@brokenshine-laptop'
end
