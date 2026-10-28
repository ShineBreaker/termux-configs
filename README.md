# Termux Dotfiles

使用 GNU Stow 管理的 Termux 配置文件仓库，专为 Android 终端优化。

> **仓库可克隆到任意目录**，所有脚本自动定位自身位置，无需固定路径。

## 🌟 特性

> 下表由 `tools/gen-docs` 从 `data/features.tsv` 生成，不要手改。

<!-- gen:features -->
| 特性 | 说明 |
|------|------|
| 🐟 Fish Shell | 现代化 Shell，自动补全、语法高亮、智能提示 |
| 🧩 会话复用 | 新标签页自动进入 tmux，每个标签页有可读的唯一会话名 (如 `calm-otter`)，窗口/历史共享且断开后可恢复 |
| 🧬 Bash 环境继承 | 登录 Fish 时按 bash 优先级导入用户 profile (`~/.bash_profile` → `~/.bash_login` → `~/.profile`) |
| 🔎 历史搜索 | Atuin 保存命令历史，Ctrl-R / ↑ 模糊搜索，弥补手机输入成本 |
| 🛠️ 现代 CLI | eza / bat / dust / fd / rg 别名，装了对应包自动启用 |
| 💅 精致提示符 | Starship 单行提示符，小屏不浪费行宽 |
| 📝 Helix 编辑器 | 移动端友好配置，支持触摸点击定位光标；透明主题跟随终端背景 |
| 📐 Git 规范 | Conventional Commits 提交模板 + 常用别名 + 全局忽略 (不含身份) |
| ⌨️ 快捷键栏 | Termux 默认快捷键栏，仅微调样式选项 |
| 🪧 登录提示 | 自定义 MOTD：Tailscale / tmux / Emacs / Pi / 内存 / 仓库状态 |
| 📊 Fastfetch | 启动显示系统信息，小屏可用紧凑模式 |
| ⚡ 快捷命令 | 大量缩写命令，减少移动端输入负担 |
| 🔧 Stow 管理 | 使用 GNU Stow 管理配置，易于维护和同步 |
| 🧭 自动定位 | `dot` 命令通过软链接自动找到仓库，克隆位置不限 |
| ⚡ 一键指令 | `just` 封装安装、重链、文档生成等常用操作 |
| 📱 移动优先 | 所有配置针对小屏幕优化 |
<!-- /gen -->

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
stow -t ~ bin        # 先链接 bin，dot 命令才可用
dot stow             # 按 data/packages.tsv 链接全部包

# 4. 设置默认 shell
chsh -s fish

# 5. 重载 Termux 设置
termux-reload-settings

# 6. 重启 Termux
```

---

## 📁 仓库结构

> 由 `tools/gen-docs` 从实际文件系统与 `data/packages.tsv` 生成，不要手改。

<!-- gen:tree -->
```
~/dotfiles/  # 克隆到任意目录均可
├── bin/          # dot 管理命令 (~/.local/bin/dot)
│   └── .local/
│       └── bin/
│           └── dot
├── fish/         # Fish Shell 配置
│   └── .config/
│       └── fish/
│           ├── completions/
│           │   ├── retry.fish
│           │   └── run.fish
│           ├── conf.d/
│           │   ├── 00-init.fish
│           │   ├── 05-env.fish
│           │   ├── 10-aliases.fish
│           │   ├── 15-tmux.fish
│           │   ├── 20-startup.fish
│           │   ├── 99-abbr.fish
│           │   └── zz-bash-env.fish
│           ├── data/
│           │   ├── abbr.tsv
│           │   └── alias.tsv
│           ├── functions/
│           │   ├── cheat.fish
│           │   ├── dot.fish
│           │   ├── retry.fish
│           │   ├── run.fish
│           │   ├── termux-reload.fish
│           │   └── update.fish
│           └── config.fish
├── fastfetch/    # 系统信息显示配置
│   └── .config/
│       └── fastfetch/
│           ├── config-compact.jsonc
│           └── config.jsonc
├── starship/     # Starship 提示符配置
│   └── .config/
│       └── starship.toml
├── atuin/        # Atuin 命令历史搜索配置
│   └── .config/
│       └── atuin/
│           └── config.toml
├── git/          # Git 全局配置 (提交模板/别名/忽略，不含身份)
│   └── .config/
│       └── git/
│           ├── config
│           ├── gitmessage
│           └── ignore
├── helix/        # Helix 编辑器配置
│   └── .config/
│       └── helix/
│           ├── themes/
│           │   └── transparent.toml
│           ├── config.toml
│           └── languages.toml
├── tmux/         # tmux 终端复用配置 (前缀 C-b)
│   └── .config/
│       └── tmux/
│           ├── scripts/
│           │   ├── clipboard-copy
│           │   ├── mem-status
│           │   ├── new-tab
│           │   ├── paste-clipboard
│           │   ├── tab-name
│           │   ├── termux-api-ready
│           │   ├── which-key
│           │   └── window-jump
│           └── tmux.conf
├── termux/       # Termux 应用设置 (含登录 MOTD)
│   └── .termux/
│       ├── colors.properties
│       ├── font.ttf
│       ├── motd.sh
│       └── termux.properties
├── data/         # Stow 包清单 (单一真相源)
│   ├── features.tsv
│   ├── optional.tsv
│   └── packages.tsv
├── tools/        # gen-docs 文档生成器
│   └── gen-docs
├── docs/         # 详细文档
├── setup.sh     # 一键安装脚本
├── justfile     # just 一键指令 (setup / docs / restow ...)
├── packages.txt # 软件包列表 (setup.sh install/export)
├── .non-packages # 不参与 Stow 的顶层目录
└── README.md    # 本文件
```
<!-- /gen -->

---

## 📦 配置包说明

<!-- gen:packages -->
| 包名 | 说明 | 链接目标 |
|------|------|------|
| `bin` | dot 管理命令 (~/.local/bin/dot) | `~/.local/bin/dot` |
| `fish` | Fish Shell 配置 | `~/.config/fish/` |
| `fastfetch` | 系统信息显示配置 | `~/.config/fastfetch/` |
| `starship` | Starship 提示符配置 | `~/.config/starship.toml` |
| `atuin` | Atuin 命令历史搜索配置 | `~/.config/atuin/` |
| `git` | Git 全局配置 (提交模板/别名/忽略，不含身份) | `~/.config/git/` |
| `helix` | Helix 编辑器配置 | `~/.config/helix/` |
| `tmux` | tmux 终端复用配置 (前缀 C-b) | `~/.config/tmux/` |
| `termux` | Termux 应用设置 (含登录 MOTD) | `~/.termux/` |
<!-- /gen -->

---

## ⌨️ 快捷键栏

使用 Termux 默认单行快捷键栏，仅微调样式选项（如按键图标风格、按钮文字大小写）。

如需自定义按键布局，可参考 Termux wiki 的 extra-keys 配置：https://wiki.termux.com/wiki/Touch_Keyboard

---

## 📝 Fish 快捷命令

> 以下表格由 `tools/gen-docs` 从 `fish/.config/fish/data/abbr.tsv` 与 `alias.tsv` 生成，
> 不要手改；改数据文件后运行 `just docs`。

### 缩写

<!-- gen:abbr -->
**📂 导航**

| 命令 | 展开 | 说明 |
|------|------|------|
| `..` | `cd ..` | 返回上级目录 |
| `...` | `cd ../..` | 返回上两级目录 |
| `~` | `cd ~` | 返回主目录 |
| `l` | `ls -la` | 详细列表 |
| `ll` | `ls -la` | 详细列表 (含隐藏文件) |
| `la` | `ls -la` | 同 l |
| `lt` | `ls -l --sort=modified` | 按时间排序 (eza) |
| `lt` | `ls -lt` | 按时间排序 (系统 ls) |
| `cd` | `z` | zoxide 智能跳转 |

**📦 包管理**

| 命令 | 展开 | 说明 |
|------|------|------|
| `pkgi` | `oma install` | 安装包 |
| `pkgu` | `oma update && pkg upgrade` | 更新所有包 |
| `pkgs` | `oma search` | 搜索包 |
| `pkgl` | `oma list` | 列出已安装包 |

**🔀 Git**

| 命令 | 展开 | 说明 |
|------|------|------|
| `g` | `git` | git |
| `status` | `git status -sb` | 简洁状态 |
| `add` | `git add` | 暂存 |
| `commit` | `git commit` | 提交 (打开模板) |
| `commitall` | `git commit --all` | 提交全部改动 |
| `push` | `git push` | 推送 |
| `pull` | `git pull` | 拉取 |
| `fetch` | `git fetch` | 获取远端 |
| `diff` | `git diff` | 差异 (系统 diff 用 command diff) |
| `log` | `git log` | 历史 |
| `clone` | `git clone` | 克隆 |

**📊 系统信息**

| 命令 | 展开 | 说明 |
|------|------|------|
| `ff` | `fastfetch` | 显示系统信息 |
| `ffmini` | `fastfetch --config ~/.config/fastfetch/config-compact.jsonc` | 紧凑模式 (小屏幕) |
| `fffull` | `fastfetch --config ~/.config/fastfetch/config.jsonc` | 标准模式 |
| `ffcfg` | `$EDITOR ~/.config/fastfetch/config.jsonc` | 编辑标准配置 |
| `ffcfgmini` | `$EDITOR ~/.config/fastfetch/config-compact.jsonc` | 编辑紧凑配置 |

**📝 编辑配置**

| 命令 | 展开 | 说明 |
|------|------|------|
| `fishrc` | `$EDITOR ~/.config/fish/config.fish` | 编辑 Fish 配置入口 |
| `termuxrc` | `$EDITOR ~/.termux/termux.properties` | 编辑 Termux 配置 |
| `helixrc` | `$EDITOR ~/.config/helix/config.toml` | 编辑 Helix 配置 |
| `starshiprc` | `$EDITOR ~/.config/starship.toml` | 编辑 Starship 提示符 |
| `atuinrc` | `$EDITOR ~/.config/atuin/config.toml` | 编辑 Atuin 历史搜索 |
| `gitrc` | `$EDITOR ~/.config/git/config` | 编辑 Git 全局配置 |
| `ee` | `emacsclient --tty --alternate-editor=""` | 终端内打开 Emacs |

**⚡ 其他**

| 命令 | 展开 | 说明 |
|------|------|------|
| `c` | `clear` | 清屏 |
| `q` | `exit` | 退出 |
| `h` | `history` | 历史记录 |

**🌐 远程**

| 命令 | 展开 | 说明 |
|------|------|------|
| `enter` | `tailscale ssh brokenshine@brokenshine-laptop` | SSH 登录电脑 |
<!-- /gen -->

### 现代 CLI 别名 (装上对应包后自动启用)

<!-- gen:alias -->
| 别名 | 对应工具 | 说明 |
|------|------|------|
| `ls` | `eza --group-directories-first` | 增强版 ls (目录优先/彩色/git 状态) |
| `cat` | `bat` | 语法高亮的 cat |
| `du` | `dust` | 直观的磁盘占用树 |
| `find` | `fd` | 更快的文件查找 |
| `grep` | `rg` | 更快的文本搜索 |
| `catr` | `command cat` | 绕过 bat 使用系统 cat |
| `cp` | `cp -i` | 覆盖前确认 (安全默认) |
| `rm` | `rm -i` | 删除前确认 (安全默认) |
<!-- /gen -->

---

## ⚡ 一键指令 (just)

安装脚本会顺带装好 [just](https://github.com/casey/just)。在仓库目录运行 `just` 即可查看全部指令：

<!-- gen:just -->
| 指令 | 说明 |
|------|------|
| `just setup` | 完整安装: 装软件 → 链接配置 → 设置 Fish（同 bash setup.sh） |
| `just install` | 从 packages.txt 批量安装软件 |
| `just export` | 导出已安装软件到 packages.txt |
| `just install-pi` | 安装 Pi 编码助手（官方托管安装器，可重复执行以升级） |
| `just install-tailscale` | 安装 Tailscale（bropines/tailscale-termux-cli，Android 免 root；可重复执行以升级） |
| `just install-emacs` | 安装 Emacs 配置（UniEmacs）: clone 仓库、部署原生 Emacs 入口、预装字体并在 Termux 预构建插件 |
| `just restow` | 重新链接所有配置包（修改配置后执行） |
| `just status` | 检查所有配置包的链接状态 |
| `just docs` | 从数据文件重新生成 README/docs 表格与 cheat（改数据文件后执行） |
| `just check` | 校验生成文档与数据源是否同步（提交前/CI） |
<!-- /gen -->

> `just` 只是便捷入口，各指令逻辑分别由 `setup.sh` 与 `dot` 命令实现。

---

## 🔧 Dotfiles 管理

`dot` 命令封装了 Stow，通过 `~/.local/bin/dot` 软链接自动定位仓库，**与克隆位置无关**。
也可用 `DOTFILES_DIR` 环境变量手动指定仓库位置。下表由 `tools/gen-docs` 从
`bin/.local/bin/dot` 的 `usage()` 生成，不要手改：

<!-- gen:dot -->
| 命令 | 说明 |
|------|------|
| `dot path` | 输出仓库路径 |
| `dot cd` | 进入仓库目录 (fish 用户提供；其他 shell 用 cd $(dot path)) |
| `dot add <包名>` | 添加新包 (交互式，并登记到 data/packages.tsv) |
| `dot stow [包名...]` | 创建符号链接 (缺省=全部包) |
| `dot unstow [包名...]` | 移除符号链接 (缺省=全部包) |
| `dot restow [包名...]` | 重新创建符号链接 (缺省=全部包) |
| `dot list` | 列出所有包及链接状态 |
| `dot status` | 检查链接状态 |
| `dot docs` | 从数据文件重新生成文档与 cheat (tools/gen-docs) |
<!-- /gen -->

手动 Stow、添加新包、解决冲突等详见 [Dotfiles 管理](./docs/dotfiles-management.md)。

---

## 📊 Fastfetch 系统信息

启动 Fish 时自动显示系统信息：标准模式（小 logo + 完整信息）自动启用，
`ffmini` 切紧凑模式（无 logo，小屏友好）。模块说明与自定义见
[Fastfetch 配置](./docs/fastfetch.md)。

---

## 🎨 自定义配置

### 单一真相源：改哪里

| 想改什么 | 只改这个文件 | 生效方式 |
|----------|--------------|----------|
| 缩写 | `fish/.config/fish/data/abbr.tsv` | `dot restow fish` + `just docs` |
| 别名 (现代 CLI) | `fish/.config/fish/data/alias.tsv` | `dot restow fish` + `just docs` |
| 快捷命令参考 / 文档表格 | 同上（自动生成） | `just docs` |
| Fish 函数 | `fish/.config/fish/functions/*.fish` | `dot restow fish` + `just docs` |
| 配置包 | `data/packages.tsv` (+ 新建目录) | `just docs` |
| just 指令 | `justfile` | `just docs` |
| tmux 键位 | `tmux/.config/tmux/tmux.conf` 的 `#@` 注解 | `dot restow tmux` + `just docs` |
| Termux 设置 / MOTD | `termux/.termux/` | `dot restow termux` + `termux-reload-settings` |

> `tools/gen-docs` 负责把数据渲染到 README、`docs/` 与 `cheat` 命令；
> `just check` 可校验文档是否与数据源同步。**不要手改生成出来的表格。**

具体步骤（修改 Fish、快捷键栏、Fastfetch、Helix、MOTD 等）见
[自定义配置](./docs/customization.md)。通用流程：

```bash
dot cd                                    # 进入仓库
$EDITOR <上表里的那一个文件>               # 只改一个
dot restow <对应包>                        # 运行时生效
just docs                                 # 同步文档与 cheat
```

提交更改：

```bash
git add . && git commit -m "描述你的修改" && git push
```

---

## 🔧 进阶功能

工具遵循"已安装则自动启用"的原则（见 `conf.d/00-init.fish`）。下表由 `tools/gen-docs`
从 `data/optional.tsv` 生成，不要手改：

<!-- gen:optional -->
- **Starship 提示符**: `pkg install starship`，安装后自动接管提示符，使用仓库内 `starship/.config/starship.toml` 小屏优化配置；未安装时使用内置简版提示符
- **zoxide 智能跳转**: `pkg install zoxide`，安装后 `cd` 自动变为智能跳转
- **fzf 模糊查找**: `pkg install fzf`
- **Atuin 历史搜索**: `pkg install atuin`，安装后 Ctrl-R / ↑ 弹出模糊搜索 (排在 fzf 之后接管)
- **现代 CLI 别名**: `pkg install eza bat dust fd` (ripgrep 已内置)，装上后 `ls/cat/du/find/grep` 自动替换为现代工具，见 `fish/.config/fish/data/alias.tsv`
- **Helix 编辑器**: 已随 `packages.txt` 安装；配置启用触摸定位光标、失焦自动保存等移动端友好项，主题 `transparent` 跟随终端背景，`languages.toml` 为 fish/clang 启用保存即格式化
- **Git 规范**: 链接 `git` 包后全局启用 Conventional Commits 提交模板、常用别名与全局忽略 (不含 user.name/email)
- **Bash 环境继承**: 安装脚本自动装好 [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) 与 [foreign-env](https://github.com/oh-my-fish/plugin-foreign-env)；登录 Fish 时用 `fenv` 按 bash 优先级 (`~/.bash_profile` → `~/.bash_login` → `~/.profile`) 导入用户环境 (见 `conf.d/zz-bash-env.fish`)
- **tmux 终端复用**: `tmux` 已随 `packages.txt` 安装；新标签页自动进入 tmux，每个标签页拿到可读的唯一会话名 (如 `calm-otter`)。配置包 `tmux` 提供前缀 `Ctrl-b` 的键位 (`?` 速查、`s` 选择器、`f` 模糊跳转、复制模式)，`TMUX_AUTO=0 fish` 跳过自动进入。详见 [tmux 配置](./tmux.md)
<!-- /gen -->

---

## 📱 使用技巧

1. **自动补全**：输入命令时按 `TAB` 键
2. **历史搜索**：按 `↑` 键搜索历史命令
3. **长按复制**：长按终端文本可复制
4. **音量键**：音量+ 是 Ctrl，音量- 是 Alt

---

## 🔄 同步到新设备 / 更新

```bash
# 新设备: 装依赖 → 克隆 → 安装
pkg install git stow fish
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles
cd ~/dotfiles && bash setup.sh        # 重启 Termux

# 已部署设备: 拉取更新 → 重新链接
dot cd && git pull && dot restow
```

完整步骤（手动安装、Oh My Fish、排错）见 [安装指南](./docs/installation.md)。

---

## 🆘 故障排除

| 症状 | 快速处理 |
|------|----------|
| Fish 没启动 | `chsh -s fish` 后重启 Termux |
| 快捷键栏不显示 | `dot restow termux && termux-reload-settings` |
| 缩写在当前会话不生效 | 新开标签页；仍无效看下节「缩写不生效」 |
| 链接冲突 | `dot status` 看冲突，备份后 `dot restow <包>` |
| `dot` 找不到仓库 | `dot stow bin`，或设 `DOTFILES_DIR` |
| 没有继承 Bash 环境 | `fish -c 'type -q fenv'`，失败则重跑 `bash setup.sh` |

完整排查（Fish 配置错误、tmux 剪贴板、Fastfetch、Git、Termux 应用等）见
[故障排除](./docs/troubleshooting.md)。

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
