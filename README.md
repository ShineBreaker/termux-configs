# Termux Dotfiles

使用 GNU Stow 管理的 Termux 配置文件仓库，专为 Android 终端优化。

> **版本**: 2.0  
> **最后更新**: 2026-03-23

## 🌟 特性

| 特性 | 说明 |
|------|------|
| 🐟 **Fish Shell** | 现代化 Shell，自动补全、语法高亮、智能提示 |
| ⌨️ **快捷键栏** | 两行手机优化的快捷键布局 |
| 📊 **Fastfetch** | 系统信息显示，自动适配屏幕宽度 |
| ⚡ **快捷命令** | 大量缩写命令，减少移动端输入负担 |
| 🔧 **Stow 管理** | 使用 GNU Stow 管理配置，易于维护和同步 |
| 📱 **移动优先** | 所有配置针对小屏幕优化 |

---

## 🚀 快速开始

### 方式一：自动安装（推荐）

```bash
# 1. 安装必要依赖
pkg install git stow fish

# 2. 克隆仓库
mkdir -p ~/Documents
cd ~/Documents
git clone https://codeberg.org/BrokenShine/Termux-configs.git dotfiles

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
git clone https://codeberg.org/BrokenShine/Termux-configs.git dotfiles
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

## 📁 仓库结构

```
~/Documents/dotfiles/
├── bash/                    # Bash 配置
│   └── .bashrc
├── fish/                    # Fish Shell 配置
│   └── .config/fish/
│       ├── config.fish      # 主配置文件
│       ├── fish_variables   # 变量存储
│       ├── functions/       # 自定义函数
│       │   ├── cheat.fish   # 命令参考
│       │   ├── dot.fish     # Dotfiles 管理
│       │   ├── termux-reload.fish
│       │   └── update.fish
│       └── conf.d/          # 配置片段
├── fastfetch/               # Fastfetch 配置
│   └── .config/fastfetch/
│       ├── config.jsonc     # 标准模式
│       └── config-compact.jsonc  # 紧凑模式
├── termux/                  # Termux 应用配置
│   └── .termux/
│       ├── termux.properties # 应用设置
│       ├── colors.properties # 颜色主题
│       └── font.ttf         # 自定义字体
├── setup.sh                 # 一键安装脚本
├── dot                      # 管理脚本 (Bash)
├── README.md                # 本文件
└── AGENTS.md                # AI Agent 文档
```

---

## 📦 配置包说明

| 包名 | 说明 | 链接目标 |
|------|------|----------|
| `bash` | Bash shell 配置 | `~/.bashrc` |
| `fish` | Fish shell 配置 | `~/.config/fish/` |
| `fastfetch` | 系统信息显示配置 | `~/.config/fastfetch/` |
| `termux` | Termux 应用设置 | `~/.termux/` |

---

## ⌨️ 快捷键栏

配置了两行手机优化的快捷键：

**第一行**：`ESC` `/` `-` `HOME` `↑` `END` `PGUP`

**第二行**：`TAB` `CTRL` `ALT` `←` `↓` `→` `PGDN`

---

## 📝 Fish 快捷命令

### 导航
| 命令 | 说明 |
|------|------|
| `..` | 返回上级目录 |
| `...` | 返回上两级目录 |
| `~` | 返回主目录 |
| `l` | 详细列表 (ls -la) |
| `ll` | 长列表 (ls -l) |
| `la` | 显示隐藏文件 |
| `lt` | 按时间排序列表 |

### 包管理
| 命令 | 说明 |
|------|------|
| `pkgi <包名>` | 安装包 |
| `pkgu` | 更新所有包 |
| `pkgs <关键词>` | 搜索包 |
| `pkgl` | 列出已安装包 |

### Git
| 命令 | 说明 |
|------|------|
| `g` | git |
| `gs` | git status |
| `ga` | git add |
| `gc` | git commit -m |
| `gp` | git push |
| `gl` | git pull |
| `gd` | git diff |

### 系统信息 (Fastfetch)
| 命令 | 说明 |
|------|------|
| `ff` | 显示系统信息（自动适配屏幕） |
| `ffmini` | 极简模式（小屏幕） |
| `fffull` | 完整模式 |
| `ffcfg` | 编辑标准配置 |
| `ffcfgmini` | 编辑极简配置 |

### 编辑配置
| 命令 | 说明 |
|------|------|
| `fishrc` | 编辑 Fish 配置 |
| `termuxrc` | 编辑 Termux 配置 |

### 其他
| 命令 | 说明 |
|------|------|
| `c` | 清屏 |
| `q` | 退出 |
| `h` | 历史记录 |
| `update` | 更新系统 |
| `termux-reload` | 重载 Termux 设置 |
| `cheat` | 查看所有快捷命令 |

### Dotfiles 管理
| 命令 | 说明 |
|------|------|
| `dot cd` | 进入 dotfiles 目录 |
| `dot list` | 列出所有配置包 |
| `dot status` | 检查链接状态 |
| `dot stow <包>` | 链接配置包 |
| `dot unstow <包>` | 取消链接 |
| `dot restow <包>` | 重新链接 |
| `dot add <包>` | 添加新配置包 |

---

## 🔧 Dotfiles 管理

### 使用 `dot` 命令

```bash
# 进入 dotfiles 目录
dot cd

# 链接配置包
dot stow fish
dot stow termux

# 取消链接
dot unstow fish

# 重新链接 (修改配置后)
dot restow fish

# 查看所有包状态
dot list

# 检查链接状态
dot status

# 添加新包
dot add helix
```

### 手动使用 Stow

```bash
cd ~/Documents/dotfiles

# 链接包
stow -t ~ <package>

# 取消链接
stow -D -t ~ <package>

# 重新链接
stow -R -t ~ <package>
```

---

## 📊 Fastfetch 系统信息

Fastfetch 已配置为在启动时自动显示系统信息，并根据屏幕宽度自动调整显示模式。

### 显示模式

| 模式 | 触发条件 | 说明 |
|------|----------|------|
| 标准模式 | 屏幕宽度 ≥ 45 字符 | 显示小 logo + 完整系统信息 |
| 紧凑模式 | 屏幕宽度 < 45 字符 | 无 logo + 核心信息 |

### 可用命令

| 命令 | 说明 |
|------|------|
| `ff` | 自动适配屏幕显示系统信息 |
| `ffmini` | 极简模式（手动触发紧凑显示） |
| `fffull` | 完整模式 |
| `ffcfg` | 编辑标准配置 |
| `ffcfgmini` | 编辑极简配置 |

---

## 🎨 自定义配置

### 修改 Fish 配置

```bash
# 方式一：直接编辑仓库中的文件
nano ~/Documents/dotfiles/fish/.config/fish/config.fish

# 然后重新链接
dot restow fish

# 方式二：使用快捷命令
fishrc
```

### 修改快捷键栏

```bash
# 编辑仓库中的配置文件
nano ~/Documents/dotfiles/termux/.termux/termux.properties

# 重新链接并重载
dot restow termux
termux-reload-settings
```

### 添加自定义别名

编辑 `~/Documents/dotfiles/fish/.config/fish/config.fish`，添加：

```fish
abbr -a 别名 '命令'
```

然后重新链接：

```bash
dot restow fish
```

### 提交更改到 Git

```bash
cd ~/Documents/dotfiles
git add .
git commit -m "描述你的修改"
git push
```

---

## 🔧 进阶功能

### 安装 Starship 提示符（可选）

```bash
pkg install starship
```

安装后自动启用美观的提示符。

### 安装 fzf 模糊查找（可选）

```bash
pkg install fzf
```

使用 `fcd` 命令快速目录跳转。

---

## 📱 使用技巧

1. **自动补全**：输入命令时按 `TAB` 键
2. **历史搜索**：按 `↑` 键搜索历史命令
3. **手势操作**：在快捷键栏上滑动可显示更多选项
4. **长按复制**：长按终端文本可复制
5. **音量键**：音量+ 是 Ctrl，音量- 是 Alt

---

## 🔄 同步配置到新设备

```bash
# 1. 在新设备上安装依赖
pkg install git stow fish

# 2. 克隆仓库
mkdir -p ~/Documents
cd ~/Documents
git clone https://codeberg.org/BrokenShine/Termux-configs.git dotfiles

# 3. 运行安装脚本
cd dotfiles
bash setup.sh

# 4. 重启 Termux
```

---

## 🆘 故障排除

### Fish 没有启动

```bash
chsh -s fish
```

然后重启 Termux。

### 快捷键栏不显示

```bash
# 重新链接配置
dot restow termux

# 重载设置
termux-reload-settings

# 或重启 Termux
```

### 恢复默认 shell

```bash
chsh -s bash
```

### Dotfiles 链接问题

**检查链接状态**：
```bash
dot status
```

**重新链接所有包**：
```bash
cd ~/Documents/dotfiles
stow -R -t ~ bash fish fastfetch termux
```

**链接冲突**：
```bash
# 如果提示文件已存在，先备份并删除
mv ~/.config/fish ~/.config/fish.bak.$(date +%Y%m%d_%H%M%S)

# 然后重新链接
dot stow fish
```

### Stow 命令未找到

```bash
pkg install stow
```

### Git 克隆失败

```bash
# 检查网络连接
ping github.com

# 使用 SSH 克隆（需要配置密钥）
git clone git@github.com:你的用户名/你的仓库.git ~/Documents/dotfiles
```

### Fish 配置错误

```bash
# 使用 Bash 启动
bash

# 进入仓库目录
cd ~/Documents/dotfiles

# 检查 Fish 配置语法
fish -n fish/.config/fish/config.fish

# 修复错误后重新链接
stow -R -t ~ fish

# 重新加载 Fish
fish
source ~/.config/fish/config.fish
```

### Fastfetch 显示异常

```bash
# 检查配置文件 JSON 语法
fastfetch --config ~/Documents/dotfiles/fastfetch/.config/fastfetch/config.jsonc

# 查看详细错误
fastfetch --config ~/Documents/dotfiles/fastfetch/.config/fastfetch/config.jsonc --debug
```

---

## 📚 文档

详细文档已移至 `docs/` 目录：

| 文档 | 说明 |
|------|------|
| [docs/index.md](./docs/index.md) | 文档首页和导航 |
| [docs/installation.md](./docs/installation.md) | 安装指南 |
| [docs/keybindings.md](./docs/keybindings.md) | 快捷键和命令参考 |
| [docs/fastfetch.md](./docs/fastfetch.md) | Fastfetch 配置说明 |
| [docs/dotfiles-management.md](./docs/dotfiles-management.md) | Dotfiles 管理指南 |
| [docs/customization.md](./docs/customization.md) | 自定义配置教程 |
| [docs/troubleshooting.md](./docs/troubleshooting.md) | 故障排除 |
| [docs/doom-emacs.md](./docs/doom-emacs.md) | Doom Emacs 配置 |

---

## 🔗 参考

- [Fish 文档](https://fishshell.com/docs/current/)
- [Termux Wiki](https://wiki.termux.com/)
- [GNU Stow 手册](https://www.gnu.org/software/stow/manual/)
- [Starship](https://starship.rs/)
- [Fastfetch 文档](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration)

---

