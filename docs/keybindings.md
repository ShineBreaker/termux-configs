# 快捷键与命令

本文档介绍 Termux 快捷键栏和 Fish Shell 的快捷命令。

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

### Dotfiles 管理
| 命令 | 说明 |
|------|------|
| `dot cd` | 进入 dotfiles 目录 |
| `dot path` | 输出仓库路径 |
| `dot list` | 列出所有配置包 |
| `dot status` | 检查链接状态 |
| `dot stow <包>` | 链接配置包 |
| `dot unstow <包>` | 取消链接 |
| `dot restow <包>` | 重新链接 |
| `dot add <包>` | 添加新配置包 |

---

## 💡 使用提示

- 所有缩写命令在 Fish 中会自动展开
- 使用 `cheat` 命令可以随时查看此参考
- 命令支持 Tab 自动补全
