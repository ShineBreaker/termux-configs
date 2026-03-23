# Termux Dotfiles 文档中心

> **版本**: 2.0  
> **最后更新**: 2026-03-23

## 项目简介

使用 GNU Stow 管理的 Termux 配置文件仓库，专为 Android 终端优化。

## 🌟 核心特性

| 特性 | 说明 |
|------|------|
| 🐟 **Fish Shell** | 现代化 Shell，自动补全、语法高亮、智能提示 |
| ⌨️ **快捷键栏** | 两行手机优化的快捷键布局 |
| 📊 **Fastfetch** | 系统信息显示，自动适配屏幕宽度 |
| ⚡ **快捷命令** | 大量缩写命令，减少移动端输入负担 |
| 🔧 **Stow 管理** | 使用 GNU Stow 管理配置，易于维护和同步 |
| 📱 **移动优先** | 所有配置针对小屏幕优化 |

## 📁 仓库结构

```
~/Documents/dotfiles/
├── bash/                    # Bash 配置
├── fish/                    # Fish Shell 配置
├── fastfetch/               # Fastfetch 配置
├── termux/                  # Termux 应用配置
├── doom/                    # Doom Emacs 配置
├── setup.sh                 # 一键安装脚本
├── dot                      # 管理脚本
└── docs/                    # 文档目录
```

## 📦 配置包说明

| 包名 | 说明 | 链接目标 |
|------|------|----------|
| `bash` | Bash shell 配置 | `~/.bashrc` |
| `fish` | Fish shell 配置 | `~/.config/fish/` |
| `fastfetch` | 系统信息显示配置 | `~/.config/fastfetch/` |
| `termux` | Termux 应用设置 | `~/.termux/` |
| `doom` | Doom Emacs 配置 | `~/.config/doom/` |

## 📚 文档导航

| 文档 | 说明 |
|------|------|
| [安装指南](./installation.md) | 快速开始和手动安装步骤 |
| [快捷键与命令](./keybindings.md) | 快捷键栏布局和 Fish 快捷命令 |
| [Fastfetch 配置](./fastfetch.md) | 系统信息显示配置和使用 |
| [Dotfiles 管理](./dotfiles-management.md) | 使用 `dot` 命令和 Stow 管理配置 |
| [自定义配置](./customization.md) | 如何修改和自定义配置 |
| [故障排除](./troubleshooting.md) | 常见问题解决方法 |
| [Doom Emacs](./doom-emacs.md) | Doom Emacs 移动端优化配置 |

## 🔗 外部参考

- [Fish 文档](https://fishshell.com/docs/current/)
- [Termux Wiki](https://wiki.termux.com/)
- [GNU Stow 手册](https://www.gnu.org/software/stow/manual/)
- [Starship](https://starship.rs/)
- [Fastfetch 文档](https://github.com/fastfetch-cli/fastfetch/wiki/Configuration)
