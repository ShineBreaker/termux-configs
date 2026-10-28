# Termux 优化配置项目 - AI Agent 工作指引

> **版本**: 4.0  
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

> 本节由 `tools/gen-docs` 从实际文件系统与 `data/packages.tsv` 生成，不要手改。

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

### 配置包与链接目标

> 下表由 `tools/gen-docs` 从 `data/packages.tsv` 生成，不要手改；新增包只改该文件。

<!-- gen:packages-risk -->
| 包名 | 说明 | 链接目标 | 修改风险 |
|------|------|------|------|
| `bin` | dot 管理命令 (~/.local/bin/dot) | `~/.local/bin/dot` | 中 - dot 命令失效 |
| `fish` | Fish Shell 配置 | `~/.config/fish/` | 高 - 影响 Shell 启动 |
| `fastfetch` | 系统信息显示配置 | `~/.config/fastfetch/` | 低 - 仅影响显示 |
| `starship` | Starship 提示符配置 | `~/.config/starship.toml` | 低 - 仅影响提示符 |
| `atuin` | Atuin 命令历史搜索配置 | `~/.config/atuin/` | 低 - 仅影响历史搜索 |
| `git` | Git 全局配置 (提交模板/别名/忽略，不含身份) | `~/.config/git/` | 中 - 影响 Git 行为 (不含身份) |
| `helix` | Helix 编辑器配置 | `~/.config/helix/` | 低 - 仅影响编辑器 |
| `tmux` | tmux 终端复用配置 (前缀 C-b) | `~/.config/tmux/` | 低 - 仅影响 tmux 会话 |
| `termux` | Termux 应用设置 (含登录 MOTD) | `~/.termux/` | 中 - 影响应用行为 |
<!-- /gen -->

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

### 5. 单一真相源 (Single Source of Truth)

**核心约定：任何信息只允许有一个家。改东西时先查下表，只动一个文件，再跑 `just docs`。**

| 想改什么 | 唯一真相源 | 消费方（自动同步） |
|----------|------------|--------------------|
| Stow 配置包 | `data/packages.tsv` | `setup.sh`、`bin/.local/bin/dot`、`docs/` 包表、仓库结构树 |
| 非 Stow 顶层目录 | `.non-packages` | `setup.sh`、`bin/.local/bin/dot` |
| Fish 缩写 | `fish/.config/fish/data/abbr.tsv` | `conf.d/99-abbr.fish`（运行时）、`cheat`、README、`docs/keybindings.md` |
| Fish 别名 | `fish/.config/fish/data/alias.tsv` | `conf.d/10-aliases.fish`（运行时）、`cheat`、README、`docs/keybindings.md` |
| Fish 函数说明 | `functions/*.fish` 的 `function -d "..."` | `cheat`、`docs/keybindings.md` |
| just 一键指令 | `justfile` 的配方注释 | `cheat`、README、`docs/keybindings.md`（`just docs` 时解析） |
| dot 子命令 | `bin/.local/bin/dot` 的 `usage()` | `cheat`、README、`docs/dotfiles-management.md` |
| tmux 键位 | `tmux.conf` 的 `#@ 分组 \| 按键 \| 说明` 注解 | 前缀 `?` 的 `which-key`（运行时）、`docs/tmux.md` |
| tmux 脚本用途 | 各脚本头部的 `# desc:` | `docs/tmux.md` 脚本表 |
| 已安装软件 | `packages.txt` | `setup.sh install/export` |

- 生成器：`tools/gen-docs`；`just docs` 重新生成，`just check` 校验是否最新。
- 生成内容位于 `<!-- gen:NAME --> … <!-- /gen -->` 标记之间，**禁止手改**。
- 其余没有标记的正文（说明、教程、故障排除）仍需人工维护，改动数据文件时顺手检查。
- `dot` 命令逻辑只在 `bin/.local/bin/dot` 一处实现；fish 侧 `dot.fish` 仅做必要的 `cd` 转发。
- `justfile` 只做入口封装：安装/导出转发 `setup.sh`，链接/文档转发 `dot` 与 `tools/gen-docs`，Emacs 安装转发 UniEmacs 自带的 `just emacs`。
- 文档与代码不一致时，以代码（数据文件）为准并修正文档。

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

1. 若改了数据文件：`just docs`（同步生成的表格与 `cheat`）
2. 重新链接: `dot restow <包>`（或 `dot restow` 全部）
3. 启动新 Fish 会话验证（`fish`）
4. 验证功能：执行相关函数/命令
5. `just check` 确认生成内容与数据源一致

### 文档更新规则

- **有生成标记的表格**：只改数据文件，然后 `just docs`，不要手改表格。
- **纯正文/教程**：不受生成器覆盖，数据变化时人工检查下列文件：
  - 安装流程：`README.md`、`docs/installation.md`、`setup.sh` 帮助文本
  - Termux MOTD：`README.md`、`docs/customization.md`、`docs/troubleshooting.md`
  - tmux 自动进入 / 标签页命名：`README.md`、`docs/keybindings.md`、`docs/customization.md`、`docs/troubleshooting.md`、`motd.sh`
  - 快捷键栏：`README.md`、`docs/keybindings.md`

### 添加新缩写 (abbr) / 别名 (alias)

唯一真相源:
- 缩写 `fish/.config/fish/data/abbr.tsv`
- 别名 `fish/.config/fish/data/alias.tsv`（别名在管道/命令替换也生效，替换系统命令时用）

格式（制表符分隔，行首 `#` 为注释）:

```
# 缩写: 分类 / 缩写 / 展开 / 说明 / 条件
🔀 Git	graph	git log --oneline --graph	图形化历史	-
# 别名: 别名 / 展开 / 说明 / 条件
ls	eza --group-directories-first	增强版 ls	eza
```

条件列: `-` 始终启用；`命令名` 已安装才启用；`!命令名` 未安装才启用。
`conf.d/99-abbr.fish`、`conf.d/10-aliases.fish` 只是加载器，不要往里写定义。

改完执行：`dot restow fish`（运行时生效）→ `just docs`（cheat 与文档同步）。

**命名规范**:
- 导航: `..`, `...`, `~`
- 列表: `l`, `ll`, `la`, `lt`
- 包管理: `pkgi`, `pkgu`, `pkgs`, `pkgl`
- Git: 直接用子命令词本身 —— `status`, `add`, `commit`, `commitall`, `push`, `pull`,
  `fetch`, `diff`, `log`, `clone`（不再用 `gs` / `gp` / `gl` 这类两字母组合）

### 添加新函数

位置: `fish/.config/fish/functions/`。定义行必须写 `-d "说明"`，`cheat` 与文档
会从该描述自动收录，不必再手改任何列表。

```fish
# 文件名: function_name.fish
function function_name -d "一句话说明"
    # 参数检查
    if test -z "$argv[1]"
        echo "用法: function_name <参数>"
        return 1
    end

    # 功能实现
    echo "正在处理 $argv[1]"
end
```

改完执行：`dot restow fish` → `just docs`。

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
dot path            # 输出仓库路径
dot stow [包...]    # 链接 (缺省=全部包)
dot unstow [包...]  # 取消链接 (缺省=全部包)
dot restow [包...]  # 重新链接 (缺省=全部包)
dot list            # 列出所有包及说明
dot status          # 检查链接状态 (已链接/未链接/冲突)
dot add <包>        # 交互式添加新包并登记到 data/packages.tsv
dot docs            # 重新生成文档与 cheat (tools/gen-docs)
```

新增不参与 Stow 的顶层目录：写入 `.non-packages`（`setup.sh` 与 `dot` 都读它）。
新增配置包：`dot add <包>`，或 `mkdir` + 在 `data/packages.tsv` 加一行。

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
2. 运行 `just docs` —— README、`docs/keybindings.md` 与 `cheat` 的指令表会从 justfile 自动同步
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

1. 在 `fish/.config/fish/data/abbr.tsv`（或 `alias.tsv`）加一行
2. `dot restow fish`（运行时生效）
3. `just docs`（cheat 与文档表格自动同步）
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

1. 创建 `fish/.config/fish/functions/<函数名>.fish`，定义行写 `-d "说明"`
2. `dot restow fish`
3. 启动新会话测试
4. `just docs`（cheat 与文档自动收录该函数）

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
| 2026-10-19 | 4.0 | 统一真相源：缩写/别名改为 `fish/.config/fish/data/*.tsv` 数据驱动，包清单改为 `data/packages.tsv`，非包目录集中在 `.non-packages`；新增 `tools/gen-docs` + `just docs`/`just check`，README/docs/AGENTS 的表格与 `cheat` 全部由数据生成；tmux 键位以 `tmux.conf` 的 `#@` 注解为源，`which-key` 运行时读取 |

---

## 附录: 配置状态检查清单

完成任务后验证：

- [ ] 数据文件改动后已运行 `just docs`
- [ ] `just check` 通过（生成文档与数据源一致）
- [ ] Fish 配置语法正确 (`fish -n` 无错误)
- [ ] Fastfetch 配置 JSON 语法正确
- [ ] justfile 改动已通过 `just --list` 验证
- [ ] Fish 环境继承可用 (`fish -c 'type -q fenv'` 通过)
- [ ] `dot status` 无冲突
- [ ] 功能已在实际环境中测试
- [ ] 移动端显示效果已验证
- [ ] Git 提交已完成 (如适用)

---

**文档结束**
