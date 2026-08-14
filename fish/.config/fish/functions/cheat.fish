function cheat
    echo (set_color cyan)"╔════════════════════════════════════════╗"
    echo (set_color cyan)"║     📱 Termux Fish 快捷命令参考        ║"
    echo (set_color cyan)"╚════════════════════════════════════════╝"
    echo
    echo (set_color yellow)"📂 导航:"
    echo (set_color normal)"  ..     返回上级目录"
    echo "  ...    返回上两级"
    echo "  ~      返回主目录"
    echo "  l      详细列表 (ls -la)"
    echo "  ll     长列表 (ls -l)"
    echo "  la     显示隐藏文件"
    echo "  lt     按时间排序"
    echo
    echo (set_color yellow)"📦 包管理:"
    echo (set_color normal)"  pkgi   安装包"
    echo "  pkgu   更新所有包"
    echo "  pkgs   搜索包"
    echo "  pkgl   列出已安装"
    echo
    echo (set_color yellow)"🔀 Git:"
    echo (set_color normal)"  gs     git status"
    echo "  ga     git add"
    echo "  gc     git commit"
    echo "  gp     git push"
    echo "  gl     git pull"
    echo "  gd     git diff"
    echo
    echo (set_color yellow)"📊 系统信息 (Fastfetch):"
    echo (set_color normal)"  ff         显示系统信息"
    echo "  ffmini     紧凑模式 (小屏幕)"
    echo "  fffull     完整模式"
    echo "  ffcfg      编辑标准配置"
    echo "  ffcfgmini  编辑紧凑配置"
    echo
    echo (set_color yellow)"⚡ 其他:"
    echo (set_color normal)"  c      清屏"
    echo "  q      退出"
    echo "  h      历史记录"
    echo "  update 更新系统"
    echo "  termux-reload  重载设置"
    echo
    echo (set_color yellow)"📝 编辑配置:"
    echo (set_color normal)"  fishrc     编辑 Fish 配置"
    echo "  termuxrc   编辑 Termux 配置"
    echo
    echo (set_color yellow)"📦 Dotfiles 管理:"
    echo (set_color normal)"  dot cd              进入 dotfiles 目录"
    echo "  dot stow <包>       链接配置包"
    echo "  dot unstow <包>     取消链接"
    echo "  dot restow <包>     重新链接"
    echo "  dot list            列出所有包"
    echo "  dot status          检查链接状态"
    echo "  dot add <包>        添加新包"
    echo
    echo (set_color cyan)"💡 提示: 按 TAB 键自动补全命令"
    echo
end
