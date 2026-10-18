# Termux Dotfiles

使用 GNU Stow 管理的 Termux 配置文件仓库，专为 Android 终端优化。

> **仓库可克隆到任意目录**，所有脚本自动定位自身位置，无需固定路径。

## 🌟 特性

| 特性 | 说明 |
|------|------|
| 🐟 **Fish Shell** | 现代化 Shell，自动补全、语法高亮、智能提示 |
| 🧬 **Bash 环境继承** | 登录 Fish 时自动导入 Bash 环境 (`~/.profile`)，无需手动 source |
| ⌨️ **快捷键栏** | Termux 默认快捷键栏，仅微调样式选项 |
| 📊 **Fastfetch** | 启动显示系统信息，小屏可用紧凑模式 |
| ⚡ **快捷命令** | 大量缩写命令，减少移动端输入负担 |
| 🔧 **Stow 管理** | 使用 GNU Stow 管理配置，易于维护和同步 |
| 🧭 **自动定位** | `dot` 命令通过软链接自动找到仓库，克隆位置不限 |
| ⚡ **一键指令** | `just` 封装安装、重链、Emacs 部署等常用操作 |
| 📱 **移动优先** | 所有配置针对小屏幕优化 |

---

## 🚀 快速开始

### 方式一：自动安装（推荐）

```bash
# 1. 安装必要依赖
pkg install git stow fish

# 2. 克隆仓库到任意目录 (此处以 ~/dotfiles 为例)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles

# 3. 运行安装脚本 (自动装好 just 与 Oh My Fish，之后可 just 一键操作)
cd ~/dotfiles
bash setup.sh

# 4. 重启 Termux
# 完全关闭应用后重新打开
```

### 方式二：手动安装

```bash
# 1. 安装依赖
pkg install -y git stow fish fastfetch

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

## 📁 仓库结构

```
~/dotfiles/                 # 克隆到任意目录均可
├── bin/                    # dot 管理命令
│   └── .local/bin/dot      # 链接到 ~/.local/bin/dot
├── fish/                   # Fish Shell 配置
│   └── .config/fish/
│       ├── config.fish     # 主配置入口 (说明见文件内注释)
│       ├── conf.d/         # 按功能拆分的配置片段
│       │   ├── 00-init.fish      # 工具集成 (zoxide / starship / fzf)
│       │   ├── 05-env.fish       # 环境变量与 PATH
│       │   ├── 20-startup.fish   # 欢迎消息与提示符
│       │   ├── 99-abbr.fish      # 移动友好缩写
│       │   └── zz-bash-env.fish  # 继承 Bash 登录环境 (fenv，omf 提供)
│       └── functions/      # 自定义函数
│           ├── cheat.fish        # 命令参考
│           ├── dot.fish          # dot 命令 (转发 cd，其余给 ~/.local/bin/dot)
│           ├── termux-reload.fish
│           └── update.fish
├── fastfetch/              # Fastfetch 配置
│   └── .config/fastfetch/
│       ├── config.jsonc          # 标准模式
│       └── config-compact.jsonc  # 紧凑模式
├── termux/                 # Termux 应用配置
│   └── .termux/
│       ├── termux.properties     # 应用设置
│       ├── colors.properties     # 颜色主题
│       └── font.ttf              # 自定义字体
├── setup.sh                # 一键安装脚本
├── justfile                # just 一键指令 (setup/install-emacs/restow ...)
├── packages.txt            # 软件包列表 (setup.sh install/export)
├── docs/                   # 详细文档
└── README.md               # 本文件
```

---

## 📦 配置包说明

| 包名 | 说明 | 链接目标 |
|------|------|----------|
| `bin` | `dot` 管理命令 | `~/.local/bin/dot` |
| `fish` | Fish shell 配置 | `~/.config/fish/` |
| `fastfetch` | 系统信息显示配置 | `~/.config/fastfetch/` |
| `termux` | Termux 应用设置 | `~/.termux/` |

---

## ⌨️ 快捷键栏

使用 Termux 默认单行快捷键栏，仅微调样式选项（如按键图标风格、按钮文字大小写）。

如需自定义按键布局，可参考 Termux wiki 的 extra-keys 配置：https://wiki.termux.com/wiki/Touch_Keyboard

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
| `la` | 同 l (ls -la) |
| `lt` | 按时间排序列表 |
| `cd` | zoxide 智能跳转 (已安装 zoxide 时) |

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
| `ff` | 显示系统信息 |
| `ffmini` | 紧凑模式（小屏幕） |
| `fffull` | 完整模式 |
| `ffcfg` | 编辑标准配置 |
| `ffcfgmini` | 编辑紧凑配置 |

### 编辑配置
| 命令 | 说明 |
|------|------|
| `fishrc` | 编辑 Fish 配置入口 |
| `termuxrc` | 编辑 Termux 配置 |

编辑命令使用 `$EDITOR`（按 hx→nano→vi 自动降级，见 `05-env.fish`）。

### 其他
| 命令 | 说明 |
|------|------|
| `c` | 清屏 |
| `q` | 退出 |
| `h` | 历史记录 |
| `update` | 更新系统 |
| `termux-reload` | 重载 Termux 设置 |
| `cheat` | 查看所有快捷命令 |

---

## ⚡ 一键指令 (just)

安装脚本会顺带装好 [just](https://github.com/casey/just)。在仓库目录运行 `just` 即可查看全部指令：

| 指令 | 说明 |
|------|------|
| `just setup` | 完整安装：装软件 + 链接配置 + 设置 Fish |
| `just install` | 从 packages.txt 批量安装软件 |
| `just export` | 导出已安装软件到 packages.txt |
| `just install-emacs` | 安装 Emacs 配置（UniEmacs）：clone 到 `~/.config/emacs` 并补全依赖 |
| `just restow` | 重新链接所有配置包（修改配置后） |
| `just status` | 检查所有配置包的链接状态 |

> `just` 只是便捷入口，各指令逻辑分别由 `setup.sh` 与 `dot` 命令实现。

---

## 🔧 Dotfiles 管理

`dot` 命令封装了 Stow，通过 `~/.local/bin/dot` 软链接自动定位仓库，**与克隆位置无关**。也可用 `DOTFILES_DIR` 环境变量手动指定仓库位置。

```bash
# 进入 dotfiles 目录
dot cd

# 输出仓库路径 (用于脚本)
dot path

# 链接配置包
dot stow fish
dot stow termux

# 取消链接
dot unstow fish

# 重新链接 (修改配置后)
dot restow fish

# 查看所有包及链接状态
dot list

# 检查链接状态 (已链接 / 未链接 / 冲突)
dot status

# 添加新包
dot add nvim
```

### 手动使用 Stow

```bash
cd ~/dotfiles   # 你的仓库克隆位置

# 链接包
stow -t ~ <package>

# 取消链接
stow -D -t ~ <package>

# 重新链接
stow -R -t ~ <package>
```

---

## 📊 Fastfetch 系统信息

启动 Fish 时自动显示系统信息。

### 显示模式

| 模式 | 说明 |
|------|------|
| 标准模式 | 启动时自动使用，小 logo + 完整系统信息 |
| 紧凑模式 | 无 logo + 核心信息，小屏幕手动使用 `ffmini` 触发 |

---

## 🎨 自定义配置

### 修改 Fish 配置

```bash
# 方式一：使用快捷命令 (打开配置入口，各功能见文件内注释)
fishrc

# 方式二：直接编辑仓库中的文件
dot cd               # 进入仓库
$EDITOR fish/.config/fish/conf.d/99-abbr.fish

# 然后重新链接
dot restow fish
```

### 修改快捷键栏

```bash
termuxrc                    # 编辑 Termux 配置
dot restow termux           # 重新链接
termux-reload-settings      # 重载设置
```

### 添加自定义别名

编辑仓库中的 `fish/.config/fish/conf.d/99-abbr.fish`，添加：

```fish
abbr -a 别名 '命令'
```

然后 `dot restow fish`。

### 提交更改到 Git

```bash
dot cd
git add .
git commit -m "描述你的修改"
git push
```

---

## 🔧 进阶功能

工具遵循"已安装则自动启用"的原则（见 `conf.d/00-init.fish`）：

- **Starship 提示符**: `pkg install starship`，安装后自动接管提示符；未安装时使用内置简版提示符
- **zoxide 智能跳转**: `pkg install zoxide`，安装后 `cd` 自动变为智能跳转
- **fzf 模糊查找**: `pkg install fzf`
- **Bash 环境继承**: 安装脚本自动装好 [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) 与 [foreign-env](https://github.com/oh-my-fish/plugin-foreign-env)；登录 Fish 时用 `fenv source ~/.profile` 导入 Bash 环境（见 `conf.d/zz-bash-env.fish`），未安装时静默跳过

---

## 📱 使用技巧

1. **自动补全**：输入命令时按 `TAB` 键
2. **历史搜索**：按 `↑` 键搜索历史命令
3. **长按复制**：长按终端文本可复制
4. **音量键**：音量+ 是 Ctrl，音量- 是 Alt

---

## 🔄 同步配置到新设备

```bash
# 1. 在新设备上安装依赖
pkg install git stow fish

# 2. 克隆仓库 (任意目录)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles

# 3. 运行安装脚本 (自动装好 just 与 Oh My Fish，之后可 just 一键操作)
cd ~/dotfiles
bash setup.sh

# 4. 重启 Termux
```

---

## ⬆️ 更新已部署设备

```bash
dot cd          # 进入仓库
git pull        # 拉取最新配置
dot list        # 查看包链接状态

# 重新链接全部包 (配置文件有变动时)
just restow     # 未安装 just 时先执行: pkg install just
```

若拉取的更新移除了 `termux/.termux/shell`（默认 shell 标记已不再入库），
重启后回到 bash 时执行 `chsh -s fish` 恢复，或重跑 `bash setup.sh`。

---

## 🆘 故障排除

### Fish 没有启动

```bash
chsh -s fish
```

然后重启 Termux。

### 快捷键栏不显示

```bash
dot restow termux
termux-reload-settings
```

### 恢复默认 shell

```bash
chsh -s bash
```

### Dotfiles 链接问题

```bash
# 检查链接状态
dot status

# 重新链接所有包
cd "$(dot path)"
stow -R -t ~ bin fish fastfetch termux
```

**链接冲突**（提示文件已存在）：

```bash
# 先备份并删除冲突文件
mv ~/.config/fish ~/.config/fish.bak.$(date +%Y%m%d_%H%M%S)

# 然后重新链接
dot stow fish
```

### dot 命令找不到仓库

`dot` 依赖 `~/.local/bin/dot` 软链接定位仓库。确认 `bin` 包已链接：

```bash
dot stow bin
```

或手动指定位置：`set -Ux DOTFILES_DIR ~/dotfiles`

### Stow 命令未找到

```bash
pkg install stow
```

### Git 克隆失败

```bash
# 检查网络连接
ping github.com

# 使用 SSH 克隆（需要配置密钥）
git clone git@github.com:ShineBreaker/termux-configs.git ~/dotfiles
```

### Fish 配置错误

```bash
# 1. 使用 Bash 启动
bash

# 2. 检查配置语法 (配置拆分在 conf.d/)
cd "$(dot path)"
fish -n fish/.config/fish/conf.d/*.fish

# 3. 修复错误后重启 Fish
fish
```

### Fastfetch 显示异常

```bash
# 检查配置文件 JSON 语法
fastfetch --config ~/.config/fastfetch/config.jsonc

# 查看详细错误
fastfetch --config ~/.config/fastfetch/config.jsonc --debug
```

### Fish 没有继承 Bash 环境

```bash
# 检查 fenv 是否可用
fish -c 'type -q fenv; and echo 正常; or echo 缺失'

# 缺失时重跑完整安装，自动补装 Oh My Fish 与 foreign-env
bash setup.sh
```

---

## 📚 文档

详细文档在 `docs/` 目录：

| 文档 | 说明 |
|------|------|
| [docs/index.md](./docs/index.md) | 文档首页和导航 |
| [docs/installation.md](./docs/installation.md) | 安装指南 |
| [docs/keybindings.md](./docs/keybindings.md) | 快捷键和命令参考 |
| [docs/fastfetch.md](./docs/fastfetch.md) | Fastfetch 配置说明 |
| [docs/dotfiles-management.md](./docs/dotfiles-management.md) | Dotfiles 管理指南 |
| [docs/customization.md](./docs/customization.md) | 自定义配置教程 |
| [docs/troubleshooting.md](./docs/troubleshooting.md) | 故障排除 |

---

## 🔗 参考

- [Fish 文档](https://fishshell.com/docs/current/)
- [Termux Wiki](https://wiki.termux.com/)
- [GNU Stow 手册](https://www.gnu.org/software/stow/manual/)
- [Starship](https://starship.rs/)
- [Fastfetch 文档](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration)
