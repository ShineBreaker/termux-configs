# Termux Dotfiles

使用 GNU Stow 管理的 Termux 配置文件仓库，专为 Android 终端优化。

> **仓库可克隆到任意目录**，所有脚本自动定位自身位置，无需固定路径。

## 🌟 特性

| 特性 | 说明 |
|------|------|
| 🐟 **Fish Shell** | 现代化 Shell，自动补全、语法高亮、智能提示 |
| 🧩 **会话复用** | 新标签页自动进入 tmux，每个标签页有可读的唯一会话名 (如 `calm-otter`)，窗口/历史共享且断开后可恢复 |
| 🧬 **Bash 环境继承** | 登录 Fish 时按 bash 优先级导入用户 profile (`~/.bash_profile` → `~/.bash_login` → `~/.profile`) |
| 🔎 **历史搜索** | Atuin 保存命令历史，Ctrl-R / ↑ 模糊搜索，弥补手机输入成本 |
| 🛠️ **现代 CLI** | eza / bat / dust / fd / rg 别名，装了对应包自动启用 |
| 💅 **精致提示符** | Starship 单行提示符，小屏不浪费行宽 |
| 📝 **Helix 编辑器** | 移动端友好的编辑器配置，支持触摸点击定位光标 |
| 📐 **Git 规范** | Conventional Commits 提交模板 + 常用别名 |
| ⌨️ **快捷键栏** | Termux 默认快捷键栏，仅微调样式选项 |
| 🪧 **登录提示** | 自定义 MOTD：Tailscale / tmux / Emacs / Pi / 内存 / 仓库状态 |
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
stow -t ~ bin fish fastfetch starship atuin git helix tmux termux

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
│       │   ├── 00-init.fish      # 工具集成 (zoxide / starship / fzf / atuin)
│       │   ├── 05-env.fish       # 环境变量与 PATH
│       │   ├── 10-aliases.fish   # 现代 CLI 别名 (eza / bat / dust / fd / rg)
│       │   ├── 15-tmux.fish      # 自动进入 tmux (main 分组共享 / tab 独立)
│       │   ├── 20-startup.fish   # 欢迎消息与提示符
│       │   ├── 99-abbr.fish      # 移动友好缩写
│       │   └── zz-bash-env.fish  # 继承 Bash 登录环境 (fenv，omf 提供)
│       ├── completions/    # 自定义补全
│       └── functions/      # 自定义函数
│           ├── cheat.fish        # 命令参考
│           ├── dot.fish          # dot 命令 (转发 cd，其余给 ~/.local/bin/dot)
│           ├── retry.fish        # 失败自动重试
│           ├── run.fish          # 当前目录 justfile 派发
│           ├── termux-reload.fish
│           └── update.fish
├── fastfetch/              # Fastfetch 配置
│   └── .config/fastfetch/
│       ├── config.jsonc          # 标准模式
│       └── config-compact.jsonc  # 紧凑模式
├── starship/               # Starship 提示符配置
│   └── .config/starship.toml
├── atuin/                  # Atuin 命令历史配置
│   └── .config/atuin/config.toml
├── git/                    # Git 全局配置 (提交模板/别名/忽略)
│   └── .config/git/
├── helix/                  # Helix 编辑器配置
│   └── .config/helix/
│       ├── config.toml           # 编辑器行为
│       ├── languages.toml        # formatter (fish/clang)
│       └── themes/transparent.toml  # 透明背景主题
├── tmux/                   # tmux 终端复用配置
│   └── .config/tmux/
│       ├── tmux.conf             # 键位与外观 (前缀 C-b)
│       └── scripts/              # tab-name / new-tab / which-key / window-jump / 剪贴板
├── termux/                 # Termux 应用配置
│   └── .termux/
│       ├── termux.properties     # 应用设置
│       ├── colors.properties     # 颜色主题
│       ├── font.ttf              # 自定义字体
│       └── motd.sh               # 登录提示 (Tailscale/tmux/Agents/内存/仓库)
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
| `starship` | Starship 提示符配置 | `~/.config/starship.toml` |
| `atuin` | 命令历史搜索配置 | `~/.config/atuin/` |
| `git` | Git 全局配置 (不含身份) | `~/.config/git/` |
| `helix` | Helix 编辑器配置 | `~/.config/helix/` |
| `tmux` | tmux 终端复用配置 (前缀 C-b) | `~/.config/tmux/` |
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
| `ll` | 详细列表 (ls -la) |
| `la` | 同 l (ls -la) |
| `lt` | 按时间排序列表 |
| `cd` | zoxide 智能跳转 (已安装 zoxide 时) |

### 现代 CLI 别名 (装上对应包后自动启用)
| 别名 | 对应工具 | 说明 |
|------|----------|------|
| `ls` | eza | 目录优先、彩色列表 (l/ll/la/lt 同步生效) |
| `cat` | bat | 语法高亮的 cat |
| `du` | dust | 直观的磁盘占用树 |
| `find` | fd | 更快的文件查找 |
| `grep` | rg | 更快的文本搜索 |
| `catr` | cat | 绕过 bat 使用系统 cat |

安全默认（与桌面一致）：`cp` / `rm` 自动加 `-i` 确认，避免误覆盖/误删。

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
| `cm` | git commit (打开模板) |
| `cmall` | git commit --all |
| `push` | git push |
| `clone` | git clone |

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
| `helixrc` | 编辑 Helix 配置 |
| `starshiprc` | 编辑 Starship 提示符 |
| `atuinrc` | 编辑 Atuin 历史搜索 |
| `gitrc` | 编辑 Git 全局配置 |
| `ee` | 终端内打开 Emacs (`emacsclient --tty`) |

编辑命令使用 `$EDITOR`（按 hx→nano→vi 自动降级，见 `05-env.fish`）。

### 其他
| 命令 | 说明 |
|------|------|
| `c` | 清屏 |
| `q` | 退出 |
| `h` | 历史记录 |
| `enter` | SSH 登录电脑 (`tailscale ssh brokenshine@brokenshine-laptop`) |
| `retry <命令>` | 命令失败时自动重试 (网络抖动) |
| `run [参数]` | 运行当前目录的 justfile |
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
| `just install-pi` | 安装/升级 Pi 编码助手（官方托管安装器） |
| `just install-tailscale` | 安装/升级 Tailscale（bropines/tailscale-termux-cli，Android 免 root） |
| `just export` | 导出已安装软件到 packages.txt |
| `just install-emacs` | 安装 Emacs 配置（UniEmacs）：clone 到 `~/.config/emacs`、部署原生 Emacs 入口、预装字体并在 Termux 预构建插件 |
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

- **Starship 提示符**: `pkg install starship`，安装后自动接管提示符，使用仓库内 `starship/.config/starship.toml` 小屏优化配置；未安装时使用内置简版提示符
- **zoxide 智能跳转**: `pkg install zoxide`，安装后 `cd` 自动变为智能跳转
- **fzf 模糊查找**: `pkg install fzf`
- **Atuin 历史搜索**: `pkg install atuin`，安装后 Ctrl-R / ↑ 弹出模糊搜索（排在 fzf 之后接管）
- **现代 CLI 别名**: `pkg install eza bat dust fd`（ripgrep 已内置），装上后 `ls/cat/du/find/grep` 自动替换为现代工具，见 `conf.d/10-aliases.fish`
- **Helix 编辑器**: 已随 `packages.txt` 安装，配置启用触摸定位光标、失焦自动保存等移动端友好项；主题 `transparent` 跟随终端背景，`languages.toml` 为 fish/clang 启用保存即格式化
- **tmux 会话复用**: `tmux` 已随 `packages.txt` 安装；新标签页自动进入 tmux，每个标签页拿到一个人类可读且唯一的会话名（如 `calm-otter`，由 `scripts/tab-name` 生成，显示在状态栏左上角与终端标题）。默认这些标签页是 `main` 的分组会话：窗口与历史共享、各自独立选中窗口，关掉标签页/重启 Termux 后仍在；状态栏右侧显示时间与内存占用。配置包 `tmux` 提供移动端键位（前缀 `Ctrl-b`）：`?` 帮助浮窗、`s` 会话/窗口选择器、`f` fzf 跨会话跳转、`C` 新建标签页、`N` 重命名标签页、`\`/`-` 分屏、`y` 复制（OSC52 / Termux:API）。`TMUX_AUTO=0 fish` 跳过自动进入，`TMUX_AUTO=tab fish` 每个标签页完全独立，`TMUX_TAB_NAME=work fish` 指定标签页名；详见 [tmux 配置](docs/tmux.md)
- **Git 规范**: 链接 `git` 包后全局启用 Conventional Commits 提交模板、常用别名与全局忽略（不含 user.name/email）
- **Bash 环境继承**: 安装脚本自动装好 [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) 与 [foreign-env](https://github.com/oh-my-fish/plugin-foreign-env)；登录 Fish 时用 `fenv` 按 bash 优先级依次尝试 `~/.bash_profile`/`~/.bash_login`/`~/.profile` 导入用户环境（系统级环境已由 Termux 自身提供），未安装时静默跳过（见 `conf.d/zz-bash-env.fish`）

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
stow -R -t ~ bin fish fastfetch starship atuin git helix tmux termux
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

# 确认用户 profile 存在 (bash 登录按顺序取第一个: ~/.bash_profile > ~/.bash_login > ~/.profile)
ls ~/.bash_profile ~/.bash_login ~/.profile

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
