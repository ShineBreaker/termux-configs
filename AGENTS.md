# Termux 优化配置项目 - AI Agent 工作指引

> **版本**: 3.0  
> **最后更新**: 2026-08-14  
> **项目目标**: 为 Android Termux 环境提供优化的 Fish Shell 配置，提升移动端终端使用体验

---

## 项目概述

本项目是一个基于 GNU Stow 管理的 Termux 配置文件仓库，可通过 Git 克隆快速部署。主要优化方向包括：

- **Shell 迁移**: 从 Bash 迁移到 Fish，获得更好的交互体验
- **快捷键栏**: 配置适合手机屏幕的快捷键布局
- **系统信息**: 集成 Fastfetch，小屏可用紧凑模式
- **快捷命令**: 提供大量缩写命令，减少移动端输入负担
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
│       │   ├── 00-init.fish      # 工具集成 (zoxide / starship，已安装则启用)
│       │   ├── 05-env.fish       # 环境变量与 PATH
│       │   ├── 20-startup.fish   # fish_greeting (fastfetch) 与提示符
│       │   └── 99-abbr.fish      # 移动友好缩写
│       ├── fish_variables    # Fish 变量存储 (自动生成)
│       └── functions/        # 自定义函数
│           ├── cheat.fish        # 命令参考显示
│           ├── dot.fish          # dot 命令 (cd 本地处理，其余转发给 ~/.local/bin/dot)
│           ├── termux-reload.fish
│           └── update.fish
├── fastfetch/                # Fastfetch 配置包
│   └── .config/fastfetch/
│       ├── config.jsonc          # 标准显示配置
│       └── config-compact.jsonc  # 紧凑显示配置
├── termux/                   # Termux 配置包
│   └── .termux/
│       ├── termux.properties     # 应用设置 (快捷键栏等)
│       ├── colors.properties     # 颜色主题
│       └── font.ttf              # 自定义字体
├── setup.sh                  # 安装脚本 (install/export/full 子命令)
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
| 新配置包 | `setup.sh` 的 `PACKAGES`、`README.md`、`docs/index.md`、`dot` 脚本（如需排除非包目录） |
| 快捷键栏 | `docs/keybindings.md`、`README.md` |
| 安装流程 | `README.md`、`docs/installation.md`、`setup.sh` 帮助文本 |

### 添加新缩写 (abbr)

位置: `fish/.config/fish/conf.d/99-abbr.fish`

```fish
# 格式
abbr -a 缩写 '完整命令'

# 示例
abbr -a g 'git'
abbr -a gs 'git status'
```

**命名规范**:
- 导航: `..`, `...`, `~`
- 列表: `l`, `ll`, `la`, `lt`
- 包管理: `pkgi`, `pkgu`, `pkgs`, `pkgl`
- Git: `g`, `gs`, `ga`, `gc`, `gp`, `gl`, `gd`

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

1. 编辑 `termux/.termux/termux.properties` 的 `extra-keys`
2. `dot restow termux`
3. `termux-reload-settings`，必要时重启 Termux

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

添加新配置包后，如果仓库新增了不参与 Stow 的顶层目录，需把它加入 `bin/.local/bin/dot` 的 `NON_PACKAGES` 数组。

### setup.sh 子命令

```bash
bash setup.sh           # 完整安装 (默认)
bash setup.sh install   # 从 packages.txt 批量安装
bash setup.sh export    # 导出已安装软件到 packages.txt
bash setup.sh help      # 帮助
```

---

## 常见任务指南

### 任务 1: 克隆仓库并部署

```bash
pkg install git stow fish
git clone <仓库地址> ~/dotfiles   # 任意目录均可
cd ~/dotfiles
bash setup.sh
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

---

## 附录: 配置状态检查清单

完成任务后验证：

- [ ] Fish 配置语法正确 (`fish -n` 无错误)
- [ ] Fastfetch 配置 JSON 语法正确
- [ ] 新缩写/函数已记录到 `cheat.fish` 和文档
- [ ] `dot status` 无冲突
- [ ] 功能已在实际环境中测试
- [ ] 移动端显示效果已验证
- [ ] Git 提交已完成 (如适用)

---

**文档结束**
