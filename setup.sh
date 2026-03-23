#!/bin/bash
# Termux 优化配置安装脚本
# 使用 Stow 管理 dotfiles
# 支持 Git 克隆部署

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# 仓库目录
DOTFILES_DIR="$HOME/Documents/dotfiles"

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

# 显示欢迎信息
clear
echo "=========================================="
echo -e "${CYAN}🚀 Termux 优化配置安装脚本${NC}"
echo "=========================================="
echo ""
echo "本脚本将自动完成以下操作："
echo "  1. 安装必要软件 (OMA包管理器, GitUI, Emacs, Stow, Fish, Fastfetch)"
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

# 检查是否在正确的目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$SCRIPT_DIR" != "$DOTFILES_DIR" ]; then
    print_error "请在正确的目录运行此脚本"
    echo ""
    echo "正确的使用方式："
    echo ""
    echo "方式一：克隆仓库后运行"
    echo "  mkdir -p ~/Documents"
    echo "  cd ~/Documents"
    echo "  git clone <仓库地址> dotfiles"
    echo "  cd dotfiles"
    echo "  bash setup.sh"
    echo ""
    echo "方式二：如果已在 ~/Documents/dotfiles 目录"
    echo "  cd ~/Documents/dotfiles"
    echo "  bash setup.sh"
    echo ""
    exit 1
fi

cd "$DOTFILES_DIR"
print_success "已进入仓库目录: $DOTFILES_DIR"
echo ""

# 步骤 1: 安装必要软件
print_step "1" "安装必要软件..."
echo ""

# 安装 oma
if ! command -v git &> /dev/null; then
    print_info "正在安装 OMA包管理器..."
    pkg install -y oma
    if [ $? -eq 0 ]; then
        print_success "OMA包管理器 安装成功"
    else
        print_error "OMA包管理器 安装失败"
        exit 1
    fi
else
    print_success "OMA包管理器 已安装"
fi

# 安装 GitUI
if ! command -v git &> /dev/null; then
    print_info "正在安装 GitUI..."
    oma install -y gitui
    if [ $? -eq 0 ]; then
        print_success "GitUI 安装成功"
    else
        print_error "GitUI 安装失败"
        exit 1
    fi
else
    print_success "Emacs 已安装"
fi

# 安装 Emacs
if ! command -v git &> /dev/null; then
    print_info "正在安装 Emacs..."
    oma install -y emacs
    if [ $? -eq 0 ]; then
        print_success "Emacs 安装成功"
    else
        print_error "Emacs 安装失败"
        exit 1
    fi
else
    print_success "Emacs 已安装"
fi

# 安装 Stow
if ! command -v stow &> /dev/null; then
    print_info "正在安装 Stow..."
    oma install -y stow
    if [ $? -eq 0 ]; then
        print_success "Stow 安装成功"
    else
        print_error "Stow 安装失败"
        exit 1
    fi
else
    print_success "Stow 已安装"
fi

# 安装 Fish
if ! command -v fish &> /dev/null; then
    print_info "正在安装 Fish Shell..."
    oma install -y fish
    if [ $? -eq 0 ]; then
        print_success "Fish 安装成功"
    else
        print_error "Fish 安装失败"
        exit 1
    fi
else
    print_success "Fish 已安装"
fi

# 安装 Fastfetch (可选)
if ! command -v fastfetch &> /dev/null; then
    print_info "正在安装 Fastfetch..."
    oma install -y fastfetch 2>/dev/null || print_warning "Fastfetch 安装失败，将跳过"
else
    print_success "Fastfetch 已安装"
fi

# 安装 Doom Emacs (可选)
if ! command -v fastfetch &> /dev/null; then
    print_info "正在安装 Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs 2>/dev/null || print_warning "Doom Emacs 安装失败，将跳过"
else
    print_success "Doom Emacs 已安装"
fi

echo ""

# 步骤 2: 备份现有配置
print_step "2" "备份现有配置..."
echo ""

BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 备份现有配置
if [ -f "$HOME/.bashrc" ]; then
    print_info "备份 .bashrc"
    cp "$HOME/.bashrc" "$BACKUP_DIR/"
fi

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
rm -rf "$HOME/.bashrc" 2>/dev/null || true
rm -rf "$HOME/.config/fish" 2>/dev/null || true
rm -rf "$HOME/.config/fastfetch" 2>/dev/null || true
rm -rf "$HOME/.termux" 2>/dev/null || true

# 使用 Stow 链接所有包
print_info "链接配置文件..."
echo ""

PACKAGES=(bash fish fastfetch termux)
LINKED_COUNT=0

for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        echo -n "  链接 $pkg ... "
        if stow -v -t ~ "$pkg" 2>&1 | grep -q "LINK"; then
            echo -e "${GREEN}成功${NC}"
            ((LINKED_COUNT++))
        else
            echo -e "${GREEN}成功${NC} (已链接)"
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
    echo "/data/data/com.termux/files/usr/bin/fish" > "$HOME/.termux/shell"
    print_success "已创建 shell 标记文件"
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
        bash)
            if [ -L "$HOME/.bashrc" ]; then
                echo -e "${GREEN}正常${NC}"
            else
                echo -e "${RED}异常${NC}"
                ALL_LINKED=false
            fi
            ;;
        fish)
            if [ -L "$HOME/.config/fish/config.fish" ]; then
                echo -e "${GREEN}正常${NC}"
            else
                echo -e "${RED}异常${NC}"
                ALL_LINKED=false
            fi
            ;;
        fastfetch)
            if [ -L "$HOME/.config/fastfetch/config.jsonc" ] || [ -d "$HOME/.config/fastfetch" ]; then
                echo -e "${GREEN}正常${NC}"
            else
                echo -e "${RED}异常${NC}"
                ALL_LINKED=false
            fi
            ;;
        termux)
            if [ -L "$HOME/.termux/termux.properties" ] || [ -d "$HOME/.termux" ]; then
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
echo "  cat ~/Documents/dotfiles/README.md"
echo "  cat ~/Documents/dotfiles/TERMUX_SETUP_README.md"
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
