# Termux 优化配置项目 - AI Agent 工作指引

> **版本**: 2.0  
> **最后更新**: 2026-03-23  
> **项目目标**: 为 Android Termux 环境提供优化的 Fish Shell 配置，提升移动端终端使用体验

---

## 📋 目录

1. [项目概述](#项目概述)
2. [仓库结构](#仓库结构)
3. [文件清单](#文件清单)
4. [核心设计原则](#核心设计原则)
5. [工作规范](#工作规范)
6. [常见任务指南](#常见任务指南)
7. [故障排除](#故障排除)
8. [参考资源](#参考资源)

---

## 项目概述

本项目是一个基于 GNU Stow 管理的 Termux 配置文件仓库，可通过 Git 克隆快速部署。主要优化方向包括：

- **Shell 迁移**: 从 Bash 迁移到 Fish，获得更好的交互体验
- **快捷键栏**: 配置适合手机屏幕的快捷键布局
- **系统信息**: 集成 Fastfetch，智能适配屏幕宽度
- **快捷命令**: 提供大量缩写命令，减少移动端输入负担
- **视觉优化**: 针对小屏幕优化显示效果
- **可复现部署**: 通过 Git + Stow 实现配置的可迁移和可复现

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
- **可选依赖**: Fastfetch, Starship, fzf

---

## 仓库结构

### 克隆后的目录结构

```
./                    # Git 仓库根目录
├── bash/                                # Bash 配置包
│   └── .bashrc                          # Bash 配置文件
├── fish/                                # Fish 配置包
│   └── .config/fish/                    # Fish 配置目录
│       ├── config.fish                  # Fish 主配置文件
│       ├── fish_variables               # Fish 变量存储 (自动生成)
│       ├── functions/                   # 自定义函数目录
│       │   ├── cheat.fish               # 命令参考显示
│       │   ├── dot.fish                 # Dotfiles 管理
│       │   ├── termux-reload.fish       # 重载 Termux 设置
│       │   └── update.fish              # 系统更新
│       └── conf.d/                      # 配置片段目录
├── fastfetch/                           # Fastfetch 配置包
│   └── .config/fastfetch/               # Fastfetch 配置目录
│       ├── config.jsonc                 # 标准显示配置
│       └── config-compact.jsonc         # 紧凑显示配置
├── termux/                              # Termux 配置包
│   └── .termux/                         # Termux 应用配置目录
│       ├── termux.properties            # Termux 应用设置
│       ├── colors.properties            # 颜色主题
│       ├── font.ttf                     # 自定义字体
│       └── shell                        # 默认 shell 标记
├── setup.sh                             # 安装脚本
├── dot                                  # Bash 管理脚本
├── README.md                            # 使用说明
├── TERMUX_SETUP_README.md               # 用户文档
└── AGENTS.md                            # 本文件
```

### Stow 链接后的用户目录结构

```
/data/data/com.termux/files/home/
├── .bashrc -> Documents/dotfiles/bash/.bashrc
├── .config/
│   ├── fish/ -> Documents/dotfiles/fish/.config/fish/
│   └── fastfetch/ -> Documents/dotfiles/fastfetch/.config/fastfetch/
└── .termux/ -> Documents/dotfiles/termux/.termux/
```

### 配置层级

```
┌─────────────────────────────────────────────────────────────┐
│                    Git 仓库层                                │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  ~/Documents/dotfiles/                                │  │
│  │  - 所有配置文件的实际存储位置                          │  │
│  │  - 通过 Git 进行版本控制                               │  │
│  │  - 使用 Stow 创建符号链接                              │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼ (Stow 创建符号链接)
┌─────────────────────────────────────────────────────────────┐
│                    Termux 应用层                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  ~/.termux/termux.properties - 应用行为配置            │  │
│  │  - 快捷键栏布局                                        │  │
│  │  - 光标样式                                            │  │
│  │  - 外部应用权限                                        │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Fish Shell 层                             │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  ~/.config/fish/config.fish - Shell 行为配置           │  │
│  │  - 环境变量                                            │  │
│  │  - 缩写命令 (abbr)                                     │  │
│  │  - 自定义函数                                          │  │
│  │  - 提示符配置                                          │  │
│  │  - 启动欢迎消息                                        │  │
│  └───────────────────────────────────────────────────────┘  │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  functions/ - 可复用函数库                             │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    工具配置层                                │
│  ┌───────────────────────────────────────────────────────┐  │
│  │  Fastfetch - 系统信息显示                              │  │
│  │  - config.jsonc (标准模式)                             │  │
│  │  - config-compact.jsonc (紧凑模式)                     │  │
│  └───────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

---

## 文件清单

### 核心配置文件

| 文件 | 仓库路径 | 链接目标 | 用途 | 修改风险 |
|------|----------|----------|------|----------|
| `termux.properties` | `termux/.termux/termux.properties` | `~/.termux/termux.properties` | Termux 应用设置 | 中 - 影响应用行为 |
| `config.fish` | `fish/.config/fish/config.fish` | `~/.config/fish/config.fish` | Fish Shell 主配置 | 高 - 影响 Shell 启动 |
| `config.jsonc` | `fastfetch/.config/fastfetch/config.jsonc` | `~/.config/fastfetch/config.jsonc` | Fastfetch 标准配置 | 低 - 仅影响显示 |
| `config-compact.jsonc` | `fastfetch/.config/fastfetch/config-compact.jsonc` | `~/.config/fastfetch/config-compact.jsonc` | Fastfetch 紧凑配置 | 低 - 仅影响显示 |

### 函数文件

| 文件 | 仓库路径 | 链接目标 | 功能描述 |
|------|----------|----------|----------|
| `cheat.fish` | `fish/.config/fish/functions/cheat.fish` | `~/.config/fish/functions/cheat.fish` | 显示命令参考 |
| `dot.fish` | `fish/.config/fish/functions/dot.fish` | `~/.config/fish/functions/dot.fish` | Dotfiles 管理 (Stow 封装) |
| `termux-reload.fish` | `fish/.config/fish/functions/termux-reload.fish` | `~/.config/fish/functions/termux-reload.fish` | 重载 Termux 设置 |
| `update.fish` | `fish/.config/fish/functions/update.fish` | `~/.config/fish/functions/update.fish` | 更新系统包 |

### 文档文件

| 文件 | 仓库路径 | 目标读者 |
|------|----------|----------|
| `README.md` | `~/Documents/dotfiles/README.md` | 终端用户 (快速开始) |
| `TERMUX_SETUP_README.md` | `~/Documents/dotfiles/TERMUX_SETUP_README.md` | 终端用户 (详细说明) |
| `AGENTS.md` | `~/Documents/dotfiles/AGENTS.md` | AI Agent |
| `setup.sh` | `~/Documents/dotfiles/setup.sh` | 新用户安装脚本 |
| `dot` | `~/Documents/dotfiles/dot` | Bash 管理脚本 |

---

## 核心设计原则

### 1. 移动端优先 (Mobile-First)

所有配置必须考虑手机屏幕的限制：

- **屏幕宽度**: 默认终端宽度通常 < 60 字符
- **输入方式**: 虚拟键盘输入效率低，优先使用缩写
- **可读性**: 避免过长的输出行，使用紧凑格式
- **触摸友好**: 快捷键栏按钮要足够大

### 2. 可复现部署 (Reproducible Deployment)

通过 Git + Stow 实现配置的可迁移和可复现：

```bash
# 任何设备上都可以快速部署
pkg install git stow fish
mkdir -p ~/Documents
cd ~/Documents
git clone <仓库地址> dotfiles
cd dotfiles
bash setup.sh
```

### 3. 渐进增强 (Progressive Enhancement)

基础功能必须可用，高级功能优雅降级：

```fish
# 示例: Fastfetch 启动检测
if status is-interactive
    and type -q fastfetch
    and test (stty size ...) -gt 40
    fastfetch ...
else
    # 降级到简单欢迎消息
    echo "Fish Shell"
end
```

### 4. 配置即文档 (Configuration as Documentation)

- 所有缩写命令使用描述性名称
- 配置文件包含详细注释
- 提供 `cheat` 命令快速参考

### 5. 可维护性 (Maintainability)

- 使用标准 JSONC 格式配置 Fastfetch
- Fish 函数单一职责
- 避免硬编码路径，使用 `$HOME` 变量
- 所有配置集中管理在 Git 仓库中

---

## 工作规范

### 修改配置文件前

1. **进入仓库目录**
   ```bash
   cd ~/Documents/dotfiles
   ```

2. **备份原文件**
   ```bash
   cp fish/.config/fish/config.fish fish/.config/fish/config.fish.bak.$(date +%Y%m%d_%H%M%S)
   ```

3. **验证语法** (Fish)
   ```bash
   fish -n fish/.config/fish/config.fish
   ```

4. **检查依赖**
   ```bash
   type -q fastfetch  # 检查命令是否存在
   ```

### 修改配置文件时

1. **保持注释**: 保留或添加说明性注释
2. **分组组织**: 使用注释分隔不同功能区域
3. **缩进一致**: Fish 使用 4 空格缩进
4. **引号规范**: 优先使用双引号，避免转义问题

### 修改配置文件后

1. **重新链接配置**
   ```bash
   cd ~/Documents/dotfiles
   stow -R -t ~ fish
   ```

2. **测试加载**
   ```bash
   source ~/.config/fish/config.fish
   ```

3. **验证功能**
   ```bash
   # 测试新添加的函数
   function_name
   ```

4. **提交更改到 Git** (如需要)
   ```bash
   cd ~/Documents/dotfiles
   git add .
   git commit -m "描述修改内容"
   git push
   ```

5. **更新文档**
   - 修改 `TERMUX_SETUP_README.md`
   - 更新 `cheat.fish` 中的命令列表

### 添加新缩写 (abbr)

位置: `fish/.config/fish/config.fish` 的 "移动友好缩写" 区域

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

**标准配置** (`fastfetch/.config/fastfetch/config.jsonc`):
- 屏幕宽度 >= 45 字符时使用
- 显示小 logo
- 完整系统信息

**紧凑配置** (`fastfetch/.config/fastfetch/config-compact.jsonc`):
- 屏幕宽度 < 45 字符时使用
- 无 logo
- 核心信息 (OS, Device, CPU, RAM, Battery)

**修改步骤**:
1. 编辑对应的 `.jsonc` 文件
2. 验证 JSON 语法
3. 重新链接: `stow -R -t ~ fastfetch`
4. 测试显示效果: `fastfetch --config ~/.config/fastfetch/config.jsonc`

---

## 常见任务指南

### 任务 1: 克隆仓库并部署

**场景**: 在新设备上快速部署配置。

**步骤**:

1. **安装依赖**
   ```bash
   pkg install git stow fish
   ```

2. **克隆仓库**
   ```bash
   mkdir -p ~/Documents
   cd ~/Documents
   git clone <仓库地址> dotfiles
   cd dotfiles
   ```

3. **运行安装脚本**
   ```bash
   bash setup.sh
   ```

4. **重启 Termux**
   - 完全关闭应用后重新打开

### 任务 2: 添加新的快捷命令

**场景**: 用户经常使用 `git log --oneline --graph`，希望添加缩写。

**步骤**:

1. 编辑 `fish/.config/fish/config.fish`
2. 在 Git 缩写区域添加:
   ```fish
   abbr -a glg 'git log --oneline --graph'
   ```
3. 保存并重新链接:
   ```bash
   cd ~/Documents/dotfiles
   stow -R -t ~ fish
   ```
4. 更新 `fish/.config/fish/functions/cheat.fish`:
   ```fish
   echo "  glg    git log --oneline --graph"
   ```
5. 更新 `TERMUX_SETUP_README.md` 中的命令表格
6. 提交到 Git (可选)

### 任务 3: 修改 Fastfetch 显示内容

**场景**: 用户希望在 Fastfetch 中显示本地 IP 地址。

**步骤**:

1. 编辑 `fastfetch/.config/fastfetch/config.jsonc`
2. 在 `modules` 数组中添加:
   ```json
   {
     "type": "localip",
     "key": "IP"
   }
   ```
3. 重新链接配置:
   ```bash
   stow -R -t ~ fastfetch
   ```
4. 测试配置:
   ```bash
   fastfetch --config ~/.config/fastfetch/config.jsonc
   ```
5. 同步修改 `config-compact.jsonc` (如果需要)

### 任务 4: 修复启动错误

**场景**: Fish 启动时报错，提示某命令不存在。

**诊断步骤**:

1. 检查错误信息中的命令:
   ```bash
   type -q 命令名
   ```

2. 如果命令不存在，修改 `fish/.config/fish/config.fish`:
   ```fish
   # 修改前
   command_name

   # 修改后
   if type -q command_name
       command_name
   end
   ```

3. 重新链接并验证:
   ```bash
   cd ~/Documents/dotfiles
   stow -R -t ~ fish
   fish -n fish/.config/fish/config.fish
   source ~/.config/fish/config.fish
   ```

### 任务 5: 添加新的 Fish 函数

**场景**: 创建一个快速备份文件的函数。

**步骤**:

1. 创建文件 `fish/.config/fish/functions/backup.fish`:
   ```fish
   function backup
       if test -f $argv[1]
           cp $argv[1] $argv[1].bak
           echo "已备份 $argv[1]"
       else
           echo "文件不存在: $argv[1]"
           return 1
       end
   end
   ```

2. 重新链接配置:
   ```bash
   stow -R -t ~ fish
   ```

3. 测试:
   ```bash
   backup test.txt
   ```

4. 添加到 `cheat.fish` 和 `TERMUX_SETUP_README.md`

### 任务 6: 修改 Termux 快捷键栏

**场景**: 用户希望将 `-` 键替换为 `|` 键。

**步骤**:

1. 编辑 `termux/.termux/termux.properties`
2. 修改 `extra-keys`:
   ```properties
   extra-keys = [['ESC','/','|','HOME','UP','END','PGUP'], \
                 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
   ```

3. 重新链接并重载设置:
   ```bash
   stow -R -t ~ termux
   termux-reload-settings
   ```

4. 更新 `TERMUX_SETUP_README.md`

### 任务 7: 使用 dot 命令管理 dotfiles

**场景**: 使用 Stow 管理 dotfiles，需要简化操作。

**可用命令**:

```bash
# 进入 dotfiles 目录
dot cd

# 链接配置包
dot stow fish
dot stow termux

# 取消链接
dot unstow fish

# 重新链接 (修改后)
dot restow fish

# 查看所有包状态
dot list

# 检查链接状态
dot status

# 添加新包
dot add helix
```

**添加新配置包步骤**:

1. 使用 `dot add <包名>` 创建包结构
2. 将配置文件移动到包目录
3. 使用 `dot stow <包名>` 创建链接
4. 更新 `cheat.fish` 和 `TERMUX_SETUP_README.md`

### 任务 8: 同步配置到新设备

**场景**: 在另一台设备上使用相同的配置。

**步骤**:

1. **在原设备上推送最新更改**
   ```bash
   cd ~/Documents/dotfiles
   git add .
   git commit -m "更新配置"
   git push
   ```

2. **在新设备上克隆并部署**
   ```bash
   pkg install git stow fish
   mkdir -p ~/Documents
   cd ~/Documents
   git clone <仓库地址> dotfiles
   cd dotfiles
   bash setup.sh
   ```

3. **重启 Termux**

---

## 故障排除

### Fish 配置错误

**症状**: 启动 Fish 时显示错误信息

**解决**:
```bash
# 1. 使用 Bash 启动
bash

# 2. 进入仓库目录
cd ~/Documents/dotfiles

# 3. 检查 Fish 配置语法
fish -n fish/.config/fish/config.fish

# 4. 修复错误后重新链接
stow -R -t ~ fish

# 5. 重新加载 Fish
fish
source ~/.config/fish/config.fish
```

### Fastfetch 显示异常

**症状**: Fastfetch 输出格式错乱或显示错误

**解决**:
```bash
# 1. 进入仓库目录
cd ~/Documents/dotfiles

# 2. 检查配置文件 JSON 语法
fastfetch --config fastfetch/.config/fastfetch/config.jsonc

# 3. 查看详细错误
fastfetch --config fastfetch/.config/fastfetch/config.jsonc --debug

# 4. 临时禁用 Fastfetch
# 编辑 fish/.config/fish/config.fish，注释掉 fish_greeting 中的 fastfetch 调用
```

### 快捷键栏不显示

**症状**: 底部快捷键栏消失

**解决**:
```bash
# 1. 重新链接配置
cd ~/Documents/dotfiles
stow -R -t ~ termux

# 2. 重载设置
termux-reload-settings

# 3. 重启 Termux
# 完全关闭应用后重新打开

# 4. 检查配置文件权限
ls -la termux/.termux/termux.properties
```

### 缩写命令不生效

**症状**: 输入缩写后没有展开

**解决**:
```bash
# 1. 检查缩写是否已定义
abbr -a | grep 缩写名

# 2. 重新链接配置
cd ~/Documents/dotfiles
stow -R -t ~ fish

# 3. 重新加载配置
source ~/.config/fish/config.fish

# 4. 检查 Fish 版本
fish --version
```

### Stow 链接冲突

**症状**: Stow 报告目标文件已存在

**解决**:
```bash
# 1. 检查冲突
cd ~/Documents/dotfiles
dot status

# 2. 备份并删除冲突文件
mv ~/.config/fish ~/.config/fish.bak.$(date +%Y%m%d_%H%M%S)

# 3. 重新链接
dot stow fish
```

### Git 克隆失败

**症状**: 无法克隆仓库

**解决**:
```bash
# 1. 检查网络连接
ping github.com

# 2. 安装 Git
pkg install git

# 3. 使用 SSH 或 HTTPS 克隆
# HTTPS:
git clone https://github.com/用户名/仓库名.git ~/Documents/dotfiles

# SSH:
git clone git@github.com:用户名/仓库名.git ~/Documents/dotfiles
```

---

## 参考资源

### 官方文档

- [Fish Shell 文档](https://fishshell.com/docs/current/)
- [Termux Wiki](https://wiki.termux.com/)
- [Fastfetch GitHub](https://github.com/fastfetch-cli/fastfetch)
- [Fastfetch 配置 Wiki](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration)
- [GNU Stow 手册](https://www.gnu.org/software/stow/manual/)

### 配置文件模板

#### Fish 函数模板
```fish
function function_name
    # 参数验证
    if test (count $argv) -eq 0
        echo "用法: function_name <参数>"
        return 1
    end

    # 主逻辑
    set -l var $argv[1]

    # 条件判断
    if test -f $var
        echo "文件存在: $var"
    else
        echo "文件不存在: $var"
        return 1
    end
end
```

#### Fastfetch 模块模板
```json
{
  "type": "module_name",
  "key": "显示键名",
  "format": "{placeholder}"
}
```

#### Stow 包目录结构模板
```
包名/
└── .config/
    └── 工具名/
        └── 配置文件
```

### 常用命令速查

```bash
# Git
git clone <地址>              # 克隆仓库
git add .                     # 添加所有更改
git commit -m "消息"          # 提交更改
git push                      # 推送到远程
git pull                      # 拉取更新

# Stow (在仓库目录执行)
stow -t ~ <包名>              # 链接包
stow -D -t ~ <包名>           # 取消链接
stow -R -t ~ <包名>           # 重新链接

# Fish
fish -n config.fish           # 验证语法
abbr -a | grep 关键词         # 查找缩写
functions                     # 列出所有函数

# Termux
termux-reload-settings        # 重载设置
termux-setup-storage          # 设置存储访问

# Fastfetch
fastfetch --list-modules      # 列出可用模块
fastfetch --list-logos        # 列出可用 logos
fastfetch --debug             # 调试模式

# Dotfiles (dot 命令)
dot cd                        # 进入 dotfiles 目录
dot stow <包>                 # 链接配置包
dot unstow <包>               # 取消链接
dot restow <包>               # 重新链接
dot list                      # 列出所有包
dot status                    # 检查链接状态
dot add <包>                  # 添加新包
```

---

## 更新记录

| 日期 | 版本 | 修改内容 |
|------|------|----------|
| 2026-03-23 | 1.0 | 初始版本，整合 Fish、Fastfetch、快捷键栏配置 |
| 2026-03-23 | 1.1 | 添加 Stow dotfiles 管理，新增 `dot` 命令 |
| 2026-03-23 | 2.0 | 重构为 Git 仓库，支持克隆部署，更新文档结构 |

---

## 附录: 配置状态检查清单

在完成任务后，使用以下清单验证配置完整性：

- [ ] Fish 配置文件语法正确 (`fish -n` 无错误)
- [ ] Fastfetch 配置 JSON 语法正确
- [ ] 新添加的缩写已记录到 `cheat.fish`
- [ ] 新添加的函数已记录到 `cheat.fish`
- [ ] 用户文档 `TERMUX_SETUP_README.md` 已更新
- [ ] Agent 文档 `AGENTS.md` 已更新
- [ ] Stow 链接正常 (`dot status` 无错误)
- [ ] 功能已在实际环境中测试
- [ ] 移动端显示效果已验证
- [ ] Git 提交已完成 (如适用)

---

**文档结束**
