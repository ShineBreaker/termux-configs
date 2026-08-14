#!/bin/bash
# Termux 优化配置安装脚本
# 使用 Stow 管理 dotfiles
# 支持 Git 克隆部署，克隆到任意目录均可运行

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 仓库目录 = 脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 软件列表文件
PACKAGE_LIST="$SCRIPT_DIR/packages.txt"

# 打印带颜色的消息
print_info() {
    echo -e "${BLUE}[信息]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[成功]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[警告]${NC} $1"
}

print_error() {
    echo -e "${RED}[错误]${NC} $1"
}

print_step() {
    echo -e "${CYAN}[步骤 $1/6]${NC} $2"
}

# 显示使用帮助
show_help() {
    echo "用法: $0 [命令]"
    echo ""
    echo "命令:"
    echo "  install       从 packages.txt 批量安装软件"
    echo "  export        导出已安装的软件到 packages.txt"
    echo "  full          执行完整的配置安装 (默认)"
    echo "  help          显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 install    # 从列表安装软件"
    echo "  $0 export     # 导出已安装软件到列表"
    echo "  $0 full       # 完整安装配置"
    echo "  $0            # 等同于 full"
}

# 检查 oma 是否安装，如果没有则安装
ensure_oma() {
    if ! command -v oma &> /dev/null; then
        print_info "正在安装 OMA 包管理器..."
        pkg install -y oma
        if [ $? -eq 0 ]; then
            print_success "OMA 包管理器安装成功"
        else
            print_error "OMA 包管理器安装失败"
            exit 1
        fi
    else
        print_success "OMA 包管理器已安装"
    fi
}

# 读取软件列表 (跳过空行和注释行，去除首尾空白)
read_packages() {
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$PACKAGE_LIST" \
        | grep -v '^$' | grep -v '^#'
}

# 从软件列表批量安装
install_from_list() {
    if [ ! -f "$PACKAGE_LIST" ]; then
        print_error "软件列表文件不存在: $PACKAGE_LIST"
        print_info "请先运行 '$0 export' 导出已安装软件，或手动创建 $PACKAGE_LIST"
        exit 1
    fi

    print_info "读取软件列表: $PACKAGE_LIST"

    local total
    total=$(read_packages | wc -l)

    if [ "$total" -eq 0 ]; then
        print_warning "软件列表为空，没有需要安装的软件"
        return 0
    fi

    print_info "发现 $total 个软件需要安装"
    echo ""

    local installed=0
    local failed=0
    local skipped=0

    while IFS= read -r package; do
        echo -n "  安装 $package ... "

        # 检查是否已安装
        if pkg list-installed 2>/dev/null | grep -q "^$package/"; then
            echo -e "${YELLOW}已安装${NC}"
            skipped=$((skipped + 1))
            continue
        fi

        # 使用 oma 安装
        if oma install -y "$package" &> /dev/null; then
            echo -e "${GREEN}成功${NC}"
            installed=$((installed + 1))
        else
            echo -e "${RED}失败${NC}"
            failed=$((failed + 1))
        fi
    done < <(read_packages)

    echo ""
    print_success "安装完成: 成功 $installed, 跳过 $skipped, 失败 $failed"

    if [ $failed -gt 0 ]; then
        print_warning "部分软件安装失败，请检查网络连接或软件名称是否正确"
    fi
}

# 导出已安装的软件到列表
export_packages() {
    print_info "正在导出已安装的软件列表..."

    # 创建软件列表文件
    echo "# Termux 软件列表" > "$PACKAGE_LIST"
    echo "# 生成时间: $(date '+%Y-%m-%d %H:%M:%S')" >> "$PACKAGE_LIST"
    echo "# 使用说明:" >> "$PACKAGE_LIST"
    echo "#   - 每行一个软件包名" >> "$PACKAGE_LIST"
    echo "#   - 以 # 开头的行为注释，会被忽略" >> "$PACKAGE_LIST"
    echo "#   - 运行 '$0 install' 可从本列表批量安装" >> "$PACKAGE_LIST"
    echo "" >> "$PACKAGE_LIST"

    # 获取已安装的软件列表（排除系统核心包）
    # 格式: 包名/stable,now 版本 ...
    pkg list-installed 2>/dev/null | grep -v '^Listing' | grep -v '^WARNING' | grep '/' | cut -d'/' -f1 | while IFS= read -r pkg_name; do
        # 跳过核心系统包
        case "$pkg_name" in
            bash|coreutils|curl|dash|debianutils|diffutils|dpkg|ed|findutils|gawk|gdbm|gpgv|grep|gzip|inetutils|less|libandroid-support|libbz2|libc++|libcrypt|libcurl|libevent|libexpat|libgcrypt|libgmp|libgnutls|libgpg-error|libiconv|libidn2|liblz4|liblzma|libmpfr|libncurses|libnghttp2|libnpth|libssh2|libtirpc|libunistring|lsof|nano|ncurses|ncurses-utils|net-tools|openssl|patch|pcre2|procps|psmisc|readline|resolv-conf|sed|tar|termux-am|termux-exec|termux-keyring|termux-licenses|termux-tools|unzip|util-linux|xz-utils|zlib|zstd)
                continue
                ;;
        esac

        echo "$pkg_name"
    done >> "$PACKAGE_LIST"

    # 统计数量
    local total
    total=$(grep -v '^#' "$PACKAGE_LIST" | grep -v '^$' | wc -l)

    print_success "已导出 $total 个软件到: $PACKAGE_LIST"
    print_info "你可以编辑此文件，删除不需要的软件，然后运行 '$0 install' 批量安装"
}

# 命令行参数处理
case "${1:-full}" in
    install)
        ensure_oma
        install_from_list
        exit 0
        ;;
    export)
        export_packages
        exit 0
        ;;
    full)
        # 继续执行完整安装
        ;;
    help|--help|-h)
        show_help
        exit 0
        ;;
    *)
        print_error "未知命令: $1"
        show_help
        exit 1
        ;;
esac

# 显示欢迎信息
clear
echo "=========================================="
echo -e "${CYAN}🚀 Termux 优化配置安装脚本${NC}"
echo "=========================================="
echo ""
echo "本脚本将自动完成以下操作："
echo "  1. 从 packages.txt 安装软件"
echo "  2. 备份现有配置"
echo "  3. 使用 Stow 链接配置文件"
echo "  4. 设置 Fish 为默认 Shell"
echo "  5. 重载 Termux 设置"
echo "  6. 验证配置"
echo ""
echo "=========================================="
echo ""

# 检查是否在 Termux 环境中
if [ -z "$TERMUX_VERSION" ] && [ -z "$TERMUX_API_VERSION" ]; then
    print_warning "未检测到 Termux 环境"
    echo "此脚本专为 Termux 设计"
    read -p "是否继续? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

cd "$SCRIPT_DIR"
print_success "仓库目录: $SCRIPT_DIR"
echo ""

# 步骤 1: 从 packages.txt 安装软件
print_step "1" "从 packages.txt 安装软件..."
echo ""

# 确保 oma 已安装
ensure_oma

# 从软件列表安装
install_from_list

echo ""

# 步骤 2: 备份现有配置
print_step "2" "备份现有配置..."
echo ""

BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 备份现有配置
if [ -d "$HOME/.config/fish" ] && [ ! -L "$HOME/.config/fish" ]; then
    print_info "备份 ~/.config/fish"
    cp -r "$HOME/.config/fish" "$BACKUP_DIR/"
fi

if [ -d "$HOME/.config/fastfetch" ] && [ ! -L "$HOME/.config/fastfetch" ]; then
    print_info "备份 ~/.config/fastfetch"
    cp -r "$HOME/.config/fastfetch" "$BACKUP_DIR/"
fi

if [ -d "$HOME/.termux" ] && [ ! -L "$HOME/.termux" ]; then
    print_info "备份 ~/.termux"
    cp -r "$HOME/.termux" "$BACKUP_DIR/"
fi

if [ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ]; then
    print_success "配置已备份到: $BACKUP_DIR"
else
    rm -rf "$BACKUP_DIR"
    print_info "没有需要备份的现有配置"
fi

echo ""

# 步骤 3: 使用 Stow 链接配置文件
print_step "3" "使用 Stow 链接配置文件..."
echo ""

# 清理现有配置（避免冲突）
print_info "清理现有配置..."
rm -rf "$HOME/.config/fish" 2>/dev/null || true
rm -rf "$HOME/.config/fastfetch" 2>/dev/null || true
rm -rf "$HOME/.termux" 2>/dev/null || true

# 使用 Stow 链接所有包
print_info "链接配置文件..."
echo ""

PACKAGES=(bin fish fastfetch termux)
LINKED_COUNT=0

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        echo -n "  链接 $pkg ... "
        # 执行 stow 并检查退出状态
        if stow -v -t ~ "$pkg" 2>&1; then
            echo -e "${GREEN}成功${NC}"
            LINKED_COUNT=$((LINKED_COUNT + 1))
        else
            echo -e "${RED}失败${NC}"
        fi
    else
        print_warning "包 $pkg 不存在，跳过"
    fi
done

echo ""
print_success "已链接 $LINKED_COUNT 个配置包"
echo ""

# 步骤 4: 设置 Fish 为默认 Shell
print_step "4" "设置 Fish 为默认 Shell..."
echo ""

# 创建 .termux/shell 文件
if [ -d "$HOME/.termux" ]; then
    # 先删除旧文件（避免 Text file busy 问题）
    rm -f "$HOME/.termux/shell" 2>/dev/null || true
    FISH_BIN="$(command -v fish || true)"
    if [ -n "$FISH_BIN" ]; then
        echo "$FISH_BIN" > "$HOME/.termux/shell" 2>/dev/null \
            && print_success "已创建 shell 标记文件" \
            || print_warning "无法创建 shell 标记文件，请手动设置"
    else
        print_warning "未找到 fish，跳过 shell 标记文件"
    fi
fi

# 使用 chsh 设置默认 shell
if chsh -s fish 2>/dev/null; then
    print_success "Fish 已设置为默认 shell"
else
    print_warning "请手动设置默认 shell: chsh -s fish"
fi

echo ""

# 步骤 5: 重载 Termux 设置
print_step "5" "重载 Termux 设置..."
echo ""

if command -v termux-reload-settings &> /dev/null; then
    termux-reload-settings
    print_success "Termux 设置已重载"
else
    print_warning "termux-reload-settings 命令未找到"
fi

echo ""

# 步骤 6: 验证配置
print_step "6" "验证配置..."
echo ""

# 验证链接
print_info "检查符号链接..."
echo ""

ALL_LINKED=true

for pkg in "${PACKAGES[@]}"; do
    echo -n "  检查 $pkg ... "
    case "$pkg" in
        bin)
            if [ -L "$HOME/.local/bin/dot" ] || [ -x "$HOME/.local/bin/dot" ]; then
                echo -e "${GREEN}正常${NC}"
            else
                echo -e "${YELLOW}未配置${NC}"
            fi
            ;;
        fish)
            if [ -L "$HOME/.config/fish" ] || [ -f "$HOME/.config/fish/config.fish" ]; then
                echo -e "${GREEN}正常${NC}"
            else
                echo -e "${RED}异常${NC}"
                ALL_LINKED=false
            fi
            ;;
        fastfetch)
            if [ -L "$HOME/.config/fastfetch" ] || [ -d "$HOME/.config/fastfetch" ]; then
                echo -e "${GREEN}正常${NC}"
            else
                echo -e "${RED}异常${NC}"
                ALL_LINKED=false
            fi
            ;;
        termux)
            if [ -L "$HOME/.termux" ] || [ -d "$HOME/.termux" ]; then
                echo -e "${GREEN}正常${NC}"
            else
                echo -e "${RED}异常${NC}"
                ALL_LINKED=false
            fi
            ;;
    esac
done

echo ""

# 显示完成信息
echo "=========================================="
if [ "$ALL_LINKED" = true ]; then
    echo -e "${GREEN}🎉 配置完成！${NC}"
else
    echo -e "${YELLOW}⚠️  配置部分完成，请检查链接状态${NC}"
fi
echo "=========================================="
echo ""
echo -e "${CYAN}📖 下一步操作：${NC}"
echo ""
echo "  1. 完全关闭 Termux 应用"
echo "  2. 重新打开 Termux"
echo "  3. 享受 Fish Shell 的便捷体验！"
echo ""
echo -e "${CYAN}📚 查看详细说明：${NC}"
echo ""
echo "  cat $SCRIPT_DIR/README.md"
echo "  ls $SCRIPT_DIR/docs/"
echo ""
echo -e "${CYAN}📦 软件包管理命令：${NC}"
echo ""
echo "  setup.sh install  - 从 packages.txt 批量安装软件"
echo "  setup.sh export   - 导出已安装软件到 packages.txt"
echo "  setup.sh help     - 显示帮助信息"
echo ""
echo -e "${CYAN}🔧 Dotfiles 管理命令：${NC}"
echo ""
echo "  dot list      - 列出所有包"
echo "  dot status    - 检查链接状态"
echo "  dot stow <包> - 链接配置包"
echo "  dot restow <包> - 重新链接配置包"
echo ""
echo -e "${CYAN}🔧 常用快捷命令：${NC}"
echo ""
echo "  ..      - 返回上级目录"
echo "  l       - 详细列表"
echo "  pkgi    - 安装包"
echo "  pkgu    - 更新系统"
echo "  gs      - git status"
echo "  c       - 清屏"
echo "  q       - 退出"
echo "  cheat   - 查看所有快捷命令"
echo ""
echo -e "${CYAN}💡 提示：${NC}"
echo ""
echo "  - 按 TAB 键自动补全命令"
echo "  - 使用快捷键栏快速输入"
echo "  - 输入 'abbr' 查看所有缩写"
echo "  - 使用 'dot cd' 进入配置仓库"
echo ""
echo "=========================================="
echo ""

# 提示重启
if [ "$ALL_LINKED" = true ]; then
    echo -e "${GREEN}安装成功！请重启 Termux 以应用所有更改。${NC}"
else
    echo -e "${YELLOW}部分配置可能未正确链接，请运行 'dot status' 检查。${NC}"
fi

echo ""
