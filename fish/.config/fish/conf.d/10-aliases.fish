# 现代 CLI 工具别名 (渐进增强: 未安装时保留原命令)
# 说明: 此处用 alias 而非 abbr——别名在管道、命令替换等场景同样生效；
# 仅在交互式 fish 会话中定义，不影响其他 shell 的脚本。
# 注意: ls 别名会接管 99-abbr.fish 中 l/ll/la/lt 展开后的 ls 调用。
if status is-interactive
    # eza: 增强版 ls (目录优先、彩色、git 状态)
    if type -q eza
        alias ls 'eza --group-directories-first'
    end

    # bat: 带语法高亮的 cat
    type -q bat; and alias cat bat

    # dust: 直观的磁盘占用树 (替代 du)
    type -q dust; and alias du dust

    # fd: 更快的 find
    type -q fd; and alias find fd

    # ripgrep: 更快的 grep
    type -q rg; and alias grep rg

    # catr: 绕过 bat 使用系统 cat (管道/大文件/脚本场景)
    alias catr 'command cat'

    # 与桌面一致的安全默认: 覆盖/删除前确认
    alias cp 'cp -i'
    alias rm 'rm -i'
end
