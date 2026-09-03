# 移动友好缩写
abbr -a '..' -d '返回上级目录' -- 'cd ..'
abbr -a '...' -d '返回上两级目录' -- 'cd ../..'
abbr -a '~' -d '返回主目录' -- 'cd ~'
abbr -a l -d '详细列表' -- 'ls -la'
abbr -a ll -d '长列表' -- 'ls -l'
abbr -a la -d '显示隐藏文件' -- 'ls -la'
abbr -a lt -d '按时间排序' -- 'ls -lt'

# 包管理缩写
abbr -a pkgi -d '安装包' -- 'oma install'
abbr -a pkgu -d '更新所有包' -- 'oma update && pkg upgrade'
abbr -a pkgs -d '搜索包' -- 'oma search'
abbr -a pkgl -d '列出已安装包' -- 'oma list'

# Git 缩写
abbr -a g -d 'git' -- 'git'
abbr -a gs -d '查看仓库状态' -- 'git status'
abbr -a ga -d '暂存文件' -- 'git add'
abbr -a gc -d '提交更改' -- 'git commit -m'
abbr -a gp -d '推送到远端' -- 'git push'
abbr -a gl -d '拉取远端更新' -- 'git pull'
abbr -a gd -d '查看差异' -- 'git diff'

# 其他缩写
abbr -a c -d '清屏' -- 'clear'
abbr -a q -d '退出' -- 'exit'
abbr -a h -d '查看历史记录' -- 'history'

# 仅在 zoxide 已安装时定义 cd 缩写，避免 zoxide 缺失时 cd 彻底失效 (渐进增强)
if type -q zoxide
    abbr -a cd -d 'zoxide 智能跳转' -- 'z'
end

# Fastfetch 缩写
abbr -a ff -d '显示系统信息' -- 'fastfetch'
abbr -a ffmini -d '紧凑模式系统信息' -- 'fastfetch --config config-compact.jsonc'
abbr -a fffull -d '完整模式系统信息' -- 'fastfetch'
abbr -a ffcfg -d '编辑标准配置' -- '$EDITOR ~/.config/fastfetch/config.jsonc'
abbr -a ffcfgmini -d '编辑紧凑配置' -- '$EDITOR ~/.config/fastfetch/config-compact.jsonc'

# 编辑配置缩写
abbr -a fishrc -d '编辑 Fish 配置' -- '$EDITOR ~/.config/fish/config.fish'
abbr -a termuxrc -d '编辑 Termux 配置' -- '$EDITOR ~/.termux/termux.properties'
