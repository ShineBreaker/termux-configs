# Termux Dotfiles 文档中心

## 项目简介

使用 GNU Stow 管理的 Termux 配置文件仓库，专为 Android 终端优化。

> **仓库可克隆到任意目录**——脚本通过自身位置或软链接自动定位仓库，无需固定路径。

## 🌟 核心特性

| 特性 | 说明 |
|------|------|
| 🐟 **Fish Shell** | 现代化 Shell，自动补全、语法高亮、智能提示 |
| 🧩 **会话复用** | 新标签页自动进入 tmux，每个标签页有可读的唯一会话名 (如 `calm-otter`)，窗口/历史共享且断开后可恢复 |
| 🧬 **Bash 环境继承** | 登录 Fish 时按 bash 优先级导入用户 profile (`~/.bash_profile` → `~/.bash_login` → `~/.profile`) |
| 🔎 **历史搜索** | Atuin 保存命令历史，Ctrl-R / ↑ 模糊搜索 |
| 🛠️ **现代 CLI** | eza / bat / dust / fd / rg 别名，装了对应包自动启用 |
| 💅 **精致提示符** | Starship 单行提示符，小屏不浪费行宽 |
| 📝 **Helix 编辑器** | 移动端友好配置，支持触摸点击定位光标；透明主题跟随终端背景 |
| 📐 **Git 规范** | Conventional Commits 提交模板 + 常用别名 |
| ⌨️ **快捷键栏** | Termux 默认快捷键栏，仅微调样式选项 |
| 🪧 **登录提示** | 自定义 MOTD：Tailscale / tmux / Emacs / Pi / 内存 / 仓库状态 |
| 📊 **Fastfetch** | 启动显示系统信息，小屏可用紧凑模式 |
| ⚡ **快捷命令** | 大量缩写命令，减少移动端输入负担 |
| 🔧 **Stow 管理** | 使用 GNU Stow 管理配置，易于维护和同步 |
| 🧭 **自动定位** | `dot` 命令通过软链接自动找到仓库，克隆位置不限 |
| ⚡ **一键指令** | `just` 封装安装、重链、Emacs 部署等常用操作 |
| 📱 **移动优先** | 所有配置针对小屏幕优化 |

## 📁 仓库结构

```
~/dotfiles/                 # 克隆到任意目录均可
├── bin/                    # dot 管理命令 → ~/.local/bin/dot
├── fish/                   # Fish Shell 配置 → ~/.config/fish/
├── fastfetch/              # Fastfetch 配置 → ~/.config/fastfetch/
├── starship/               # Starship 提示符配置 → ~/.config/starship.toml
├── atuin/                  # Atuin 命令历史配置 → ~/.config/atuin/
├── git/                    # Git 全局配置 → ~/.config/git/
├── helix/                  # Helix 编辑器配置 → ~/.config/helix/
│   └── .config/helix/      #   config.toml + languages.toml + themes/transparent.toml
├── tmux/                   # tmux 终端复用配置 → ~/.config/tmux/
│   └── .config/tmux/       #   tmux.conf + scripts/
├── termux/                 # Termux 应用配置 → ~/.termux/
├── setup.sh                # 一键安装脚本
├── justfile                # just 一键指令 (setup/install-emacs/restow ...)
├── packages.txt            # 软件包列表
└── docs/                   # 文档目录 (本目录，不参与 Stow)
```

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

## 📚 文档导航

| 文档 | 说明 |
|------|------|
| [安装指南](./installation.md) | 快速开始和手动安装步骤 |
| [快捷键与命令](./keybindings.md) | 快捷键栏说明和 Fish 快捷命令 |
| [tmux 配置](./tmux.md) | 终端复用：自动进入会话、键位与剪贴板 |
| [Fastfetch 配置](./fastfetch.md) | 系统信息显示配置和使用 |
| [Dotfiles 管理](./dotfiles-management.md) | 使用 `dot` 命令和 Stow 管理配置 |
| [自定义配置](./customization.md) | 如何修改和自定义配置 |
| [故障排除](./troubleshooting.md) | 常见问题解决方法 |

## 🔗 外部参考

- [Fish 文档](https://fishshell.com/docs/current/)
- [Termux Wiki](https://wiki.termux.com/)
- [GNU Stow 手册](https://www.gnu.org/software/stow/manual/)
- [Starship](https://starship.rs/)
- [Fastfetch 文档](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration)
