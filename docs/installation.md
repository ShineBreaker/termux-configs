# 安装指南

本文档介绍如何在 Termux 上安装和部署 dotfiles 配置。

## 系统要求

- **操作系统**: Android 7.0+
- **应用**: Termux (F-Droid 或 GitHub 版本)
- **依赖**: Git, GNU Stow, Fish Shell
- **可选**: Fastfetch, Starship, zoxide, fzf

---

## 🚀 快速开始

### 方式一：自动安装（推荐）

```bash
# 1. 安装必要依赖
pkg install git stow fish

# 2. 克隆仓库到任意目录 (此处以 ~/dotfiles 为例)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles

# 3. 运行安装脚本 (脚本自动定位自身所在目录)
cd ~/dotfiles
bash setup.sh

# 4. 重启 Termux
# 完全关闭应用后重新打开
```

### 方式二：手动安装

```bash
# 1. 安装依赖
pkg install -y git stow fish fastfetch oma

# 2. 克隆仓库 (任意目录)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles
cd ~/dotfiles

# 3. 链接所有配置包
stow -t ~ bin fish fastfetch termux

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

# 2. 克隆仓库 (任意目录)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles

# 3. 运行安装脚本
cd ~/dotfiles
bash setup.sh

# 4. 重启 Termux
```

---

## 📱 使用技巧

1. **自动补全**：输入命令时按 `TAB` 键
2. **历史搜索**：按 `↑` 键搜索历史命令
3. **长按复制**：长按终端文本可复制
4. **音量键**：音量+ 是 Ctrl，音量- 是 Alt

---

## 🔧 进阶功能（可选）

工具遵循"已安装则自动启用"的原则（见 `fish/.config/fish/conf.d/00-init.fish`）：

- **Starship 提示符**: `pkg install starship`，安装后自动接管提示符；未安装时使用内置简版提示符
- **zoxide 智能跳转**: `pkg install zoxide`，安装后 `cd` 自动变为智能跳转
- **fzf 模糊查找**: `pkg install fzf`
