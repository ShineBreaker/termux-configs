# Termux 优化配置项目 - AI Agent 工作指引

> **版本**: 3.12  
> **最后更新**: 2026-10-19  
> **项目目标**: 为 Android Termux 环境提供优化的 Fish Shell 配置，提升移动端终端使用体验

---

## 项目概述

本项目是一个基于 GNU Stow 管理的 Termux 配置文件仓库，可通过 Git 克隆快速部署。主要优化方向包括：

- **Shell 迁移**: 从 Bash 迁移到 Fish，获得更好的交互体验
- **环境继承**: 登录 Fish 时通过 Oh My Fish 的 foreign-env 插件 (`fenv`) 继承 Bash 环境
- **命令历史**: Atuin 保存历史，Ctrl-R / ↑ 模糊搜索，弥补手机输入成本
- **现代 CLI**: eza / bat / dust / fd / rg 别名，装上对应包自动启用，未装时保留原命令
- **编辑器**: Helix 配置启用触摸定位光标、失焦自动保存等移动端友好项，透明主题跟随终端背景
- **Git 规范**: Conventional Commits 提交模板 + 常用别名 + 全局忽略（不含身份）
- **快捷键栏**: 使用 Termux 默认键栏，仅微调样式选项
- **系统信息**: 集成 Fastfetch，小屏可用紧凑模式
- **快捷命令**: 提供大量缩写命令，减少移动端输入负担
- **一键指令**: 提供 `just` 一键指令，封装安装、重链与 Emacs 部署等常用操作
- **可复现部署**: 通过 Git + Stow 实现配置的可迁移和可复现
- **自动定位**: 所有脚本通过自身位置定位仓库，**克隆到任意目录均可工作**

### 目标用户

- 在 Android 手机上使用 Termux 的开发者
- 需要移动端 Linux 环境的用户
- 追求高效终端操作的用户
- 需要在多台设备间同步配置的用户

### 环境要求

- **操作系统**: Android 7.0+
- **应用**: Termux (F-Droid 或 GitHub 版本)
- **Shell**: Fish 4.5.0+
- **依赖工具**: Git, GNU Stow
- **可选依赖**: Fastfetch, Starship, zoxide, fzf

---

## 仓库结构

```
./                            # Git 仓库根目录，克隆位置不限
├── bin/                      # dot 管理命令包
│   └── .local/bin/dot        # → ~/.local/bin/dot (readlink 自动定位仓库)
├── fish/                     # Fish 配置包
│   └── .config/fish/
│       ├── config.fish       # 主配置入口 (说明性注释)
│       ├── conf.d/           # 按功能拆分的配置片段 (按文件名顺序加载)
│       │   ├── 00-init.fish      # 工具集成 (zoxide / starship / fzf / atuin，已安装则启用)
│       │   ├── 05-env.fish       # 环境变量与 PATH
│       │   ├── 10-aliases.fish   # 现代 CLI 别名 (eza / bat / dust / fd / rg)
│       │   ├── 15-tmux.fish      # 自动进入 tmux (main 分组共享 / tab 独立)
│       │   ├── 20-startup.fish   # fish_greeting (fastfetch) 与提示符
│       │   ├── 99-abbr.fish      # 移动友好缩写
│       │   └── zz-bash-env.fish  # 继承 Bash 登录环境 (fenv，须排在 omf.fish 之后)
│       ├── completions/      # 自定义补全
│       └── functions/        # 自定义函数
│           ├── cheat.fish        # 命令参考显示
│           ├── dot.fish          # dot 命令 (cd 本地处理，其余转发给 ~/.local/bin/dot)
│           ├── retry.fish        # 失败自动重试
│           ├── run.fish          # 当前目录 justfile 派发
│           ├── termux-reload.fish
│           └── update.fish
├── fastfetch/                # Fastfetch 配置包
│   └── .config/fastfetch/
│       ├── config.jsonc          # 标准显示配置
│       └── config-compact.jsonc  # 紧凑显示配置
├── starship/                 # Starship 提示符配置包
│   └── .config/starship.toml
├── atuin/                    # Atuin 命令历史配置包
│   └── .config/atuin/config.toml
├── git/                      # Git 全局配置包 (提交模板/别名/忽略)
│   └── .config/git/
├── helix/                    # Helix 编辑器配置包
│   └── .config/helix/
│       ├── config.toml          # 编辑器行为与主题选择
│       ├── languages.toml       # formatter (fish/clang)
│       └── themes/transparent.toml  # 透明背景主题
├── tmux/                     # tmux 终端复用配置包 (前缀 C-b)
│   └── .config/tmux/
│       ├── tmux.conf             # 键位、状态栏、复制模式
│       └── scripts/              # tab-name / new-tab / which-key / window-jump / 剪贴板脚本
├── termux/                   # Termux 配置包
│   └── .termux/
│       ├── termux.properties     # 应用设置
│       ├── colors.properties     # 颜色主题
│       ├── font.ttf              # 自定义字体
│       └── motd.sh               # 登录提示 (Tailscale/tmux/Agents/内存/仓库)
├── setup.sh                  # 安装脚本 (install/export/full 子命令)
├── justfile                  # just 一键指令 (setup/install-emacs/restow 等)
├── packages.txt              # 软件包列表
├── docs/                     # 用户文档 (不参与 Stow)
├── README.md                 # 使用说明
└── AGENTS.md                 # 本文件
```

### 配置包与链接目标

| 包名 | 仓库路径 | 链接目标 | 修改风险 |
|------|----------|----------|----------|
| `bin` | `bin/.local/bin/dot` | `~/.local/bin/dot` | 中 - dot 命令失效 |
| `fish` | `fish/.config/fish/` | `~/.config/fish/` | 高 - 影响 Shell 启动 |
| `fastfetch` | `fastfetch/.config/fastfetch/` | `~/.config/fastfetch/` | 低 - 仅影响显示 |
| `starship` | `starship/.config/starship.toml` | `~/.config/starship.toml` | 低 - 仅影响提示符 |
| `atuin` | `atuin/.config/atuin/` | `~/.config/atuin/` | 低 - 仅影响历史搜索 |
| `git` | `git/.config/git/` | `~/.config/git/` | 中 - 影响 Git 行为 (不含身份) |
| `helix` | `helix/.config/helix/` | `~/.config/helix/` | 低 - 仅影响编辑器 |
| `tmux` | `tmux/.config/tmux/` | `~/.config/tmux/` | 低 - 仅影响 tmux 会话 |
| `termux` | `termux/.termux/` | `~/.termux/` | 中 - 影响应用行为 |

`docs/`、`*.md`、`packages.txt` 已列入 `.stow-local-ignore`，不会被链接。

---

## 核心设计原则

### 1. 移动端优先 (Mobile-First)

- **屏幕宽度**: 默认终端宽度通常 < 60 字符，避免过长的输出行
- **输入方式**: 虚拟键盘输入效率低，优先使用缩写
- **触摸友好**: 快捷键栏按钮要足够大

### 2. 位置无关 (Location-Independent)

**禁止在脚本中硬编码仓库路径**。定位方式：

- `setup.sh`: 使用 `BASH_SOURCE` 推导脚本所在目录
- `dot` 命令: 对 `$0` 做 `readlink -f`，剥去 `/bin/.local/bin/dot` 后缀得到仓库根；可用 `DOTFILES_DIR` 环境变量覆盖

### 3. 渐进增强 (Progressive Enhancement)

基础功能必须可用，可选工具优雅降级：

```fish
# 00-init.fish: 已安装则启用，未安装无报错
type -q zoxide; and zoxide init fish | source
type -q starship; and starship init fish | source
```

### 4. 配置即文档 (Configuration as Documentation)

- 所有缩写命令使用描述性名称
- 配置文件包含指引性注释
- 提供 `cheat` 命令快速参考

### 5. 单一实现 (Single Source of Truth)

- `dot` 命令逻辑只在 `bin/.local/bin/dot` 一处实现；fish 侧 `dot.fish` 仅做必要的 `cd` 转发
- `justfile` 仅做入口封装：安装/导出转发 `setup.sh`，链接状态转发 `dot`，Emacs 安装转发 UniEmacs 自带的 `just emacs`，不重复实现逻辑
- 文档与代码不一致时，以代码为准并修正文档

---

## 工作规范

### 修改配置文件前

1. 进入仓库目录 (`dot cd` 或手动)
2. 备份原文件（如需要）
3. 验证语法：`fish -n fish/.config/fish/conf.d/<文件>.fish`

### 修改配置文件时

1. **保持注释**: 保留或添加说明性注释
2. **分组组织**: 使用注释分隔不同功能区域
3. **缩进一致**: Fish 使用 4 空格缩进
4. **引号规范**: 优先使用双引号

### 修改配置文件后

1. 重新链接: `dot restow <包>`
2. 启动新 Fish 会话验证（`fish`）
3. 验证功能：执行相关函数/命令
4. 更新文档（见下）

### 文档同步要求

修改配置后，同步检查更新：

| 改动 | 需要更新的文档 |
|------|----------------|
| 新缩写 | `cheat.fish`、`docs/keybindings.md`、`README.md` 命令表 |
| 新函数 | `cheat.fish`、`docs/keybindings.md`、`README.md` |
| 新配置包 | `README.md`、`docs/index.md`（`setup.sh` 已动态发现配置包，无需维护包列表；新增不参与 Stow 的顶层目录需同时加入 `setup.sh` 与 `bin/.local/bin/dot` 的 `NON_PACKAGES`） |
| 快捷键栏 | `docs/keybindings.md`、`README.md` |
| 安装流程 | `README.md`、`docs/installation.md`、`setup.sh` 帮助文本 |
| Termux MOTD | `README.md`、`docs/customization.md`、`docs/troubleshooting.md` |
| tmux 自动进入 | `README.md`、`docs/keybindings.md`、`docs/customization.md`、`docs/troubleshooting.md`、`cheat.fish` |
| tmux 标签页命名/分组 | `docs/tmux.md`、`docs/keybindings.md`、`docs/customization.md`、`docs/troubleshooting.md`、`README.md`、`cheat.fish`、`motd.sh` |
| tmux 键位/脚本 | `docs/tmux.md`、`docs/keybindings.md`、`cheat.fish` |
| just 指令 | `README.md` 指令表、`docs/keybindings.md`、`cheat.fish` |

### 添加新缩写 (abbr)

位置: `fish/.config/fish/conf.d/99-abbr.fish`

```fish
# 格式
abbr -a 缩写 '完整命令'

# 示例
abbr -a g 'git'
abbr -a push 'git push'
```

**命名规范**:
- 导航: `..`, `...`, `~`
- 列表: `l`, `ll`, `la`, `lt`
- 包管理: `pkgi`, `pkgu`, `pkgs`, `pkgl`
- Git: 直接用子命令词本身 —— `status`, `add`, `commit`, `commitall`, `push`, `pull`,
  `fetch`, `diff`, `log`, `clone`（不再用 `gs` / `gp` / `gl` 这类两字母组合）

### 添加新函数

位置: `fish/.config/fish/functions/`

```fish
# 文件名: function_name.fish
function function_name
    # 参数检查
    if test -z "$argv[1]"
        echo "用法: function_name <参数>"
        return 1
    end

    # 功能实现
    echo "正在处理 $argv[1]"
end
```

### 修改 Fastfetch 配置

- **标准配置** (`config.jsonc`): 小 logo + 完整系统信息
- **紧凑配置** (`config-compact.jsonc`): 无 logo + 核心信息，`ffmini` 触发

修改后: `dot restow fastfetch`，测试 `fastfetch --config ~/.config/fastfetch/config.jsonc`

### 修改 Termux 快捷键栏

当前使用 Termux 默认快捷键栏，`extra-keys` 未自定义。如需自定义：

1. 编辑 `termux/.termux/termux.properties` 的 `extra-keys`
2. `dot restow termux`
3. `termux-reload-settings`，必要时重启 Termux

### Fish 继承 Bash 环境 (Oh My Fish + fenv)

**机制**: `setup.sh` 自动安装 Oh My Fish（fish 插件管理器）与 `foreign-env` 插件；
后者提供 `fenv` 命令，`conf.d/zz-bash-env.fish` 在登录会话中按 bash 优先级
（`~/.bash_profile` → `~/.bash_login` → `~/.profile`）执行 `fenv source`，
把 Bash 用户登录环境导入 Fish。

**范围**:

- 系统级环境无需继承：`login` 脚本已导出 `PREFIX`/`TMPDIR`/`LD_PRELOAD`，
  `$PREFIX/etc/fish/conf.d/start-services.fish` 已提供 `SVDIR`/`LOGDIR`。
- `~/.bashrc` 不导入：它是交互式 bash 配置，而 `fenv` 以非交互方式执行
  （通常会被 .bashrc 顶部的交互判断提前 return）；需让 Fish 继承的变量请放进登录 profile。

**维护注意**:

- `conf.d/omf.fish` 由 OMF 安装器运行时写入（经折叠链接落到仓库内），已列入
  `.gitignore`，不要手工维护或入库。
- 新增启动片段时若需用到 `fenv`，文件名必须以 `zz-` 开头，才能按字母序排在
  `omf.fish` 之后加载（conf.d 按文件名排序）。
- OMF 安装器依赖 `which`，已在 `packages.txt` 中；`setup.sh` 的 `ensure_omf()`
  失败时只告警不中断，不影响 Fish 其余功能。

### 使用 dot 命令管理 dotfiles

```bash
dot cd            # 进入仓库目录
dot path          # 输出仓库路径
dot stow <包>     # 链接配置包
dot unstow <包>   # 取消链接
dot restow <包>   # 重新链接
dot list          # 列出所有包及状态
dot status        # 检查链接状态 (已链接/未链接/冲突)
dot add <包>      # 添加新包 (交互式)
```

添加新配置包后，如果仓库新增了不参与 Stow 的顶层目录，需把它加入 `bin/.local/bin/dot` 与 `setup.sh` 的 `NON_PACKAGES` 数组。

### setup.sh 子命令

```bash
bash setup.sh           # 完整安装 (默认)
bash setup.sh install   # 从 packages.txt 批量安装
bash setup.sh export    # 导出已安装软件到 packages.txt
bash setup.sh help      # 帮助
```

### 修改 justfile

`justfile` 是常用操作的一键入口，只做转发（见设计原则 5）。新增指令时：

1. 配方注释第一行即 `just --list` 的说明文本，保持一句话、清晰易懂
2. 同步更新 `README.md` 指令表、`docs/keybindings.md` 与 `cheat.fish`
3. 用 `just --list` 与 `just --dry-run <指令>` 验证

---

## 常见任务指南

### 任务 1: 克隆仓库并部署

```bash
pkg install git stow fish
git clone <仓库地址> ~/dotfiles   # 任意目录均可
cd ~/dotfiles
bash setup.sh                 # 自动装好 just，之后可 just 一键操作
# 重启 Termux
```

### 任务 2: 添加新的快捷命令

1. 编辑 `fish/.config/fish/conf.d/99-abbr.fish` 添加缩写
2. `dot restow fish`
3. 按上方「文档同步要求」更新文档
4. 提交到 Git (可选)

### 任务 3: 修改 Fastfetch 显示内容

1. 编辑 `fastfetch/.config/fastfetch/config.jsonc`，在 `modules` 数组添加模块
2. `dot restow fastfetch`
3. 测试显示效果
4. 视需要同步修改 `config-compact.jsonc`

### 任务 4: 修复启动错误

1. 检查错误信息中的命令是否存在
2. 不存在则加 `type -q` 保护:
   ```fish
   if type -q command_name
       command_name
   end
   ```
3. `fish -n` 验证语法，重启 Fish

### 任务 5: 添加新的 Fish 函数

1. 创建 `fish/.config/fish/functions/<函数名>.fish`
2. `dot restow fish`
3. 启动新会话测试
4. 更新 `cheat.fish` 和文档

### 任务 6: 同步配置到新设备

同任务 1。仓库位置无关，克隆到任意目录即可。

---

## 故障排除

### Fish 配置错误

```bash
bash                 # 使用 Bash 启动
dot cd               # 进入仓库 (或手动 cd 到克隆位置)
fish -n fish/.config/fish/conf.d/*.fish   # 检查语法
stow -R -t ~ fish    # 修复后重新链接
fish                 # 重启 Fish
```

### dot 命令找不到仓库

`dot` 依赖 `~/.local/bin/dot` 软链接定位仓库：

```bash
dot stow bin                       # 确认 bin 包已链接
set -Ux DOTFILES_DIR ~/dotfiles    # 或手动指定位置 (fish)
```

### Fastfetch 显示异常

```bash
fastfetch --config ~/.config/fastfetch/config.jsonc --debug
```

### Fish 没有继承 Bash 环境

```bash
# 1. 检查 fenv 是否可用 (由 Oh My Fish 的 foreign-env 插件提供)
fish -c 'type -q fenv; and echo 正常; or echo 缺失'

# 2. 检查 foreign-env 插件是否存在
ls "$HOME/.local/share/omf/pkg/foreign-env"

# 3. 确认用户 profile 存在 (bash 登录按顺序取第一个:
#    ~/.bash_profile > ~/.bash_login > ~/.profile)
ls ~/.bash_profile ~/.bash_login ~/.profile

# 4. 缺失时重跑完整安装，自动补装 Oh My Fish 与 foreign-env
bash setup.sh
```

### Stow 链接冲突

```bash
dot status                                  # 查看冲突
mv ~/.config/fish ~/.config/fish.bak.$(date +%Y%m%d_%H%M%S)
dot stow fish
```

---

## 参考资源

### 官方文档

- [Fish Shell 文档](https://fishshell.com/docs/current/)
- [Termux Wiki](https://wiki.termux.com/)
- [Fastfetch GitHub](https://github.com/fastfetch-cli/fastfetch)
- [Fastfetch 配置 Wiki](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration)
- [GNU Stow 手册](https://www.gnu.org/software/stow/manual/)

### 常用命令速查

```bash
# Git
git status / git add / git commit / git push / git pull

# Stow (在仓库目录执行)
stow -t ~ <包名>          # 链接包
stow -D -t ~ <包名>       # 取消链接
stow -R -t ~ <包名>       # 重新链接

# Fish
fish -n <文件>            # 验证语法
abbr -a | grep 关键词     # 查找缩写
functions                 # 列出所有函数

# Termux
termux-reload-settings    # 重载设置
termux-setup-storage      # 设置存储访问

# Fastfetch
fastfetch --list-modules  # 列出可用模块
fastfetch --debug         # 调试模式
```

---

## 更新记录

| 日期 | 版本 | 修改内容 |
|------|------|----------|
| 2026-03-23 | 1.0 | 初始版本，整合 Fish、Fastfetch、快捷键栏配置 |
| 2026-03-23 | 1.1 | 添加 Stow dotfiles 管理，新增 `dot` 命令 |
| 2026-03-23 | 2.0 | 重构为 Git 仓库，支持克隆部署 |
| 2026-08-14 | 3.0 | 移除 Doom Emacs；脚本位置无关化；dot 命令单一实现；文档对齐仓库现实 |
| 2026-10-18 | 3.1 | 新增 justfile 一键指令（setup/install-emacs/restow 等）；setup.sh 自动安装 just |
| 2026-10-18 | 3.2 | Fish 经 Oh My Fish + foreign-env (fenv) 继承 Bash 登录环境；setup.sh 自动安装 OMF 与插件，packages.txt 补充 which |
| 2026-10-18 | 3.3 | fenv 按 bash 登录优先级继承用户 profile (`~/.bash_profile` → `~/.bash_login` → `~/.profile`)；确认系统级环境由 Termux fish 包自身提供 |
| 2026-10-18 | 3.4 | 移植主机配置: Atuin 历史搜索、现代 CLI 别名 (eza/bat/dust/fd/rg)、Starship 小屏提示符、retry 重试函数、Git 规范提交换板、Helix 移动端编辑器配置 |
| 2026-10-18 | 3.5 | 对齐桌面使用习惯: cm/cmall/push/clone/ee/catr 缩写、cp/rm 确认、run 函数；Helix 透明主题与 languages.toml |
| 2026-10-18 | 3.6 | 新增 tmux 自动进入 (`conf.d/15-tmux.fish`)：默认共享 main 会话，TMUX_AUTO 可切 tab 独立或禁用 |
| 2026-10-18 | 3.7 | 新增 `tmux` 配置包：移植 Guix-configs 键位 (前缀改为 C-b)、`?` 速查与 `f` fzf 窗口跳转；剪贴板用 OSC52 + 可选 Termux:API (不阻塞) |
| 2026-10-18 | 3.8 | 修复 tmux 顶栏条件样式含逗号导致渲染出字面 `bold]` 的问题；状态栏与终端标题加客户端短号 (`main·N`) 区分标签页；`TMUX_AUTO=tab` 改用自动短名 |
| 2026-10-18 | 3.9 | tmux 状态栏右侧改为时间 + 内存占用 (`mem-status`)，移除无意义的 hostname/终端尺寸 |
| 2026-10-18 | 3.10 | 新增自定义 Termux 登录提示 `motd.sh`：显示 Tailscale/tmux/Emacs·Pi/内存/dotfiles 状态；静态信息带 1 天缓存 |
| 2026-10-19 | 3.11 | tmux 标签页改为「main 分组会话 + 可读唯一会话名」：新增 `scripts/tab-name`（形容词-动物命名、自动回收零客户端分组会话）与 `scripts/new-tab`（前缀 C 新建标签页）；状态栏/终端标题改用 `#S`、新增前缀 `N` 改名；`window-jump` 按 window_id 去重；MOTD 改列已附着的标签页名 |
| 2026-10-19 | 3.12 | Git 缩写统一为子命令词形式（`push` / `pull` / `status` 等），移除 `gs` / `ga` / `gc` / `gp` / `gl` / `gd` / `cm` / `cmall`；git 别名 `st` / `lg` 改为 `graph` 并去掉 `st` |

---

## 附录: 配置状态检查清单

完成任务后验证：

- [ ] Fish 配置语法正确 (`fish -n` 无错误)
- [ ] Fastfetch 配置 JSON 语法正确
- [ ] 新缩写/函数已记录到 `cheat.fish` 和文档
- [ ] justfile 改动已通过 `just --list` 验证，指令表已同步文档
- [ ] Fish 环境继承可用 (`fish -c 'type -q fenv'` 通过)
- [ ] `dot status` 无冲突
- [ ] 功能已在实际环境中测试
- [ ] 移动端显示效果已验证
- [ ] Git 提交已完成 (如适用)

---

**文档结束**
