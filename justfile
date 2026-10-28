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

# 安装 Pi 编码助手（官方托管安装器，可重复执行以升级）
install-pi:
    curl -fsSL https://pi.dev/install.sh | sh

# 安装 Tailscale（bropines/tailscale-termux-cli，Android 免 root；可重复执行以升级）
install-tailscale:
    curl -fsSL https://raw.githubusercontent.com/bropines/tailscale-termux-cli/main/remote-install.sh | bash

# 安装 Emacs 配置（UniEmacs）: clone 仓库、部署原生 Emacs 入口、预装字体并在 Termux 预构建插件
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

    # Android 原生 Emacs（org.gnu.emacs）只读自己家目录的 init，
    # 仓库体已 clone 到 ~/.config/emacs，这里把两个入口文件复制过去。
    emacs_home="/data/data/org.gnu.emacs/files"
    if [ -d "$emacs_home" ]; then
        mkdir -p "$emacs_home/.emacs.d"
        cp "$target/early-init.el" "$target/init.el" "$emacs_home/.emacs.d/"
        echo "已部署入口文件到 $emacs_home/.emacs.d/"
    else
        echo "未检测到 Android 原生 Emacs（$emacs_home），跳过入口文件部署"
    fi

    # just emacs = termux-deps → font → icons → packages：
    # 在 Termux 里装齐依赖、字体并在本机预构建插件（缓存进 Termux home，
    # 与原生 Emacs 共享），避免首次打开时现装现编。
    cd "$target"
    just emacs

# 重新链接所有配置包（修改配置后执行）
restow:
    bash bin/.local/bin/dot restow

# 检查所有配置包的链接状态
status:
    bash bin/.local/bin/dot status

# 从数据文件重新生成 README/docs 表格与 cheat（改数据文件后执行）
docs:
    python3 tools/gen-docs

# 校验生成文档与数据源是否同步（提交前/CI）
check:
    python3 tools/gen-docs --check
