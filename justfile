# termux-configs 一键指令。
# 用法: 在仓库目录运行 just 查看全部指令。
# 本文件只做入口封装——逻辑分别由 setup.sh 与 dot 命令实现，勿在此重复实现。

# 显示所有可用指令
default:
    @just --list

# 完整安装: 装软件 → 链接配置 → 设置 Fish（同 bash setup.sh）
setup:
    bash setup.sh

# 从 packages.txt 批量安装软件
install:
    bash setup.sh install

# 导出已安装软件到 packages.txt
export:
    bash setup.sh export

# 安装 Emacs 配置（UniEmacs）: clone 到 ~/.config/emacs 并补全依赖
install-emacs:
    #!/usr/bin/env bash
    set -euo pipefail
    target="$HOME/.config/emacs"
    if [ -e "$target" ] && [ ! -d "$target/.git" ]; then
        echo "错误: $target 已存在且不是 git 仓库，请先手动处理" >&2
        exit 1
    fi
    if [ -d "$target/.git" ]; then
        echo "UniEmacs 已在 $target，跳过 clone"
    else
        command -v git >/dev/null || pkg install -y git
        mkdir -p "$(dirname "$target")"
        git clone https://github.com/ShineBreaker/UniEmacs.git "$target"
    fi
    cd "$target"
    just emacs

# 重新链接所有配置包（修改配置后执行）
restow:
    #!/usr/bin/env bash
    set -euo pipefail
    for pkg in */; do
        pkg="${pkg%/}"
        if [ "$pkg" != "docs" ]; then
            stow -R -t ~ "$pkg"
        fi
    done
    echo "已重新链接全部配置包"

# 检查所有配置包的链接状态
status:
    dot status
