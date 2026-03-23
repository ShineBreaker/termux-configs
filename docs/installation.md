# 安装指南

本文档介绍如何在 Termux 上安装和部署 dotfiles 配置。

## 系统要求

- **操作系统**: Android 7.0+
- **应用**: Termux (F-Droid 或 GitHub 版本)
- **依赖**: Git, GNU Stow, Fish Shell
- **可选**: Fastfetch, Starship, fzf

---

## 🚀 快速开始

### 方式一：自动安装（推荐）

```bash
# 1. 安装必要依赖
pkg install git stow fish

# 2. 克隆仓库
mkdir -p ~/Documents
cd ~/Documents
git clone https://github.com/你的用户名/你的仓库.git dotfiles

# 3. 进入仓库目录
cd dotfiles

# 4. 运行安装脚本
bash setup.sh

# 5. 重启 Termux
# 完全关闭应用后重新打开
```

### 方式二：手动安装

```bash
# 1. 安装依赖
pkg install -y git stow fish fastfetch

# 2. 克隆仓库
mkdir -p ~/Documents
cd ~/Documents
git clone https://github.com/你的用户名/你的仓库.git dotfiles
cd dotfiles

# 3. 链接所有配置包
stow -t ~ bash fish fastfetch termux

# 4. 设置默认 shell
chsh -s fish

# 5. 重载 Termux 设置
termux-reload-settings

# 6. 重启 Termux
```

---

## 🔄 同步配置到新设备

```bash
# 1. 在新设备上安装依赖
pkg install git stow fish

# 2. 克隆仓库
mkdir -p ~/Documents
cd ~/Documents
git clone https://github.com/你的用户名/你的仓库.git dotfiles

# 3. 运行安装脚本
cd dotfiles
bash setup.sh

# 4. 重启 Termux
```

---

## 📱 使用技巧

1. **自动补全**：输入命令时按 `TAB` 键
2. **历史搜索**：按 `↑` 键搜索历史命令
3. **手势操作**：在快捷键栏上滑动可显示更多选项
4. **长按复制**：长按终端文本可复制
5. **音量键**：音量+ 是 Ctrl，音量- 是 Alt

---

## 🔧 进阶功能（可选）

### 安装 Starship 提示符

```bash
pkg install starship
```

安装后自动启用美观的提示符。

### 安装 fzf 模糊查找

```bash
pkg install fzf
```

使用 `fcd` 命令快速目录跳转。
