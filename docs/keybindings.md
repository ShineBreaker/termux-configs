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

安全默认（与桌面一致）：`cp` / `rm` 自动加 `-i` 确认。

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
| `status` | git status -sb (简洁状态) |
| `add` | git add |
| `commit` | git commit (打开模板) |
| `commitall` | git commit --all |
| `push` | git push |
| `pull` | git pull |
| `fetch` | git fetch |
| `diff` | git diff (系统 diff 用 `command diff`) |
| `log` | git log |
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

### tmux 会话复用

新标签页会自动进入 tmux。每个标签页是一个独立会话，会话名由 `scripts/tab-name`
自动生成（如 `calm-otter`），显示在状态栏左上角和终端标题里；默认它们共享 `main`
的窗口与历史（分组会话），断开或重启 Termux 后仍在。前缀键为 `Ctrl-b`（Termux 上
为音量+ 与 `b` 同按）。完整键位与配置见 [tmux 配置](./tmux.md)。

| 操作 | 按键 |
|------|------|
| 前缀键 | `Ctrl-b`（音量+ 与 `b` 同按） |
| 帮助浮窗 | 前缀键后按 `?` |
| 重新加载配置 | 前缀键后按 `r` |
| 左右 / 上下分屏 | 前缀键后按 `\` / `-` |
| 切换窗格 | 前缀键后按 `h` `j` `k` `l`，或 `Alt+←→↑↓` |
| 新建窗口 / 标签页 | 前缀键后按 `c` / `C` |
| 重命名当前标签页 | 前缀键后按 `N` |
| 关闭窗格 / 窗口 / 会话 | 前缀键后按 `x` / `X` / `K` |
| 切换窗口 | `0`-`9`，或 `Alt+1`~`Alt+5` |
| 会话·窗口浮窗选择器 | 前缀键后按 `s` |
| fzf 跨会话跳转窗口 | 前缀键后按 `f` |
| 复制模式 | 前缀键后按 `[` 或 `Esc` |
| 粘贴 | 前缀键后按 `p` |
| 临时脱离会话 (保留在后台) | 前缀键后按 `d` |

复制模式下：`v` 开始选择，`y` / `Enter` 复制并退出，`Esc` 取消。复制会写入 tmux 缓冲并尝试 OSC52；若已装 Termux:API 应用，还会同步到 Android 剪贴板。

模式控制 (详见 `docs/customization.md`)：`TMUX_AUTO=0 fish` 跳过自动进入，`TMUX_AUTO=tab fish` 让每个标签页独立，`TMUX_TAB_NAME=work fish` 指定本标签页名字。

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

### just 一键指令
| 命令 | 说明 |
|------|------|
| `just` | 查看全部一键指令 |
| `just setup` | 完整安装 |
| `just install` | 从 packages.txt 装软件 |
| `just install-pi` | 安装/升级 Pi 编码助手 |
| `just install-tailscale` | 安装/升级 Tailscale (Android 免 root) |
| `just export` | 导出软件清单 |
| `just install-emacs` | 安装 Emacs 配置 (UniEmacs)：clone 仓库、部署原生 Emacs 入口、预装字体并预构建插件 |
| `just restow` | 重新链接全部配置包 |
| `just status` | 检查链接状态 |

---

## 💡 使用提示

- 所有缩写命令在 Fish 中会自动展开
- 使用 `cheat` 命令可以随时查看此参考
- 命令支持 Tab 自动补全
- 装了 Atuin 后，按 `Ctrl-R` 或 `↑` 可模糊搜索历史命令（Termux 音量+ 即 Ctrl）
