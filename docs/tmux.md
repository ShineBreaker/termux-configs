# tmux 配置

本项目的 tmux 配置移植自桌面端 Guix-configs 的 tmux 使用习惯，按移动端做了裁剪：
保留键位与工作流，去掉依赖桌面环境的侧边栏（Guile 长驻进程）、Wayland 剪贴板
（`wl-copy`/`wl-paste`）与 herdr 会话选择器。**前缀键保留 tmux 默认的 `Ctrl-b`**
（桌面用 `C-x`）。

- 配置包: `tmux` → `~/.config/tmux/`
- 主配置: `~/.config/tmux/tmux.conf`
- 自动进入: `conf.d/15-tmux.fish`（见下）
- 脚本: `~/.config/tmux/scripts/`

---

## 🚀 自动进入会话

Termux 每个新标签页启动交互式 Fish 时，若已在 tmux 外，会自动接入 tmux：

| `TMUX_AUTO` | 行为 |
|-------------|------|
| 未设置 / `main` | 所有标签页复用 `main` 会话（已存在则 attach） |
| `tab` / `per-tab` | 每个标签页新建独立会话 |
| `0` / `off` / `false` / `no` | 不自动进入，保留普通 Fish |

```bash
TMUX_AUTO=0 fish    # 临时开一个普通 Fish
TMUX_AUTO=tab fish  # 临时每标签页独立
```

详见 `docs/customization.md` 的「调整 tmux 会话复用」。

---

## 🪟 多标签页如何区分

所有标签页共享同一个 `main` 会话，状态栏左侧会显示 `main·<N>`：`<N>` 是当前标签页
对应的 tmux 客户端短号（`#{b:client_tty}`，即 `/dev/pts/N` 的 N）。它不是一个 0/1/2 的
标签计数器，而是 Termux/Android 分配的 PTY 号，所以可能跳号（如 0、2、4）或重用；
只要标签页开着，这个号就固定不变，且同时打开的标签页不会重复。终端标题也会变成
`main·N:窗口`。

状态栏右侧显示当前时间 (`HH:MM`) 与内存占用 (`RAM xx%`)，取代了没意义的默认 hostname；
时间由 tmux 原生 strftime 展开，内存由 `scripts/mem-status` 读 `/proc/meminfo` 计算。

---

## ⌨️ 前缀键与常用绑定

前缀键为 `Ctrl-b`，Termux 上为**音量+ 与 `b` 同按**。按 `Ctrl-b` 后状态栏左侧
会出现 `[PREFIX]` 提示。

| 按键 | 操作 |
|------|------|
| 前缀 `r` | 重新加载 `tmux.conf` |
| 前缀 `?` | 快捷键速查浮窗 |
| 前缀 `\` | 左右分屏（保持当前路径） |
| 前缀 `-` | 上下分屏（保持当前路径） |
| 前缀 `h` `j` `k` `l` | 切换窗格（Vi 风格） |
| 前缀 `c` / `C` | 新建窗口 / 新建会话 |
| 前缀 `x` / `X` / `K` | 关闭窗格 / 窗口 / 会话 |
| 前缀 `s` | 会话·窗口浮窗选择器（`choose-tree`） |
| 前缀 `f` | fzf 跨会话模糊跳转窗口 |
| 前缀 `[` / `Esc` | 进入复制模式 |
| 前缀 `p` | 粘贴 |
| 前缀 `d` | 脱离会话（留在后台） |
| 前缀 `z` | 放大 / 还原当前窗格 |
| 前缀 `0`-`9` | 切换到对应窗口 |

无需前缀：

| 按键 | 操作 |
|------|------|
| `Alt+←→↑↓` | 切换窗格（Termux 音量- = Alt） |
| `Ctrl+←→↑↓` | 调整窗格大小（Termux 音量+ = Ctrl） |
| `Alt+1`~`Alt+5` | 快速切换窗口 |
| `Alt+Shift+H` | 进入复制模式（向上回滚） |
| `Alt+Shift+F` | 搜索回滚内容 |
| `Alt+Shift+/` | 打开 tmux 命令提示符 |
| `Shift+Insert` | 粘贴 |

复制模式（`prefix` + `[` 进入）：

| 按键 | 操作 |
|------|------|
| `v` | 开始选择 |
| `y` / `Enter` | 复制并退出复制模式 |
| `Esc` | 取消 |
| 鼠标拖拽结束 | 复制选中文本 |

---

## 📋 剪贴板

复制时：

1. tmux 先把内容写入自身 paste buffer（供粘贴使用）；
2. 由于 `set -s set-clipboard on`，tmux 会尝试用 **OSC52** 把内容写入外层
   Termux 终端剪贴板；
3. 若安装了 **Termux:API 应用**（`com.termux.api`），`scripts/clipboard-copy`
   还会调用 `termux-clipboard-set` 额外写入 Android 剪贴板。

粘贴时 `scripts/paste-clipboard` 优先读取 Android 剪贴板，读不到则粘贴 tmux 缓冲。

> **注意**：只装了 `termux-api` 包、没装配套 App 时，`termux-clipboard-*` 会
> 无限阻塞。脚本用 `scripts/termux-api-ready` 先探测（结果缓存到
> `~/.cache/tmux-clipboard-api`），不可用时直接跳过，**不会卡住复制/粘贴**。
> 装了 Termux:API App 后删除缓存让其重新探测：
>
> ```bash
> rm -f ~/.cache/tmux-clipboard-api
> ```

---

## 🧰 脚本

`~/.config/tmux/scripts/`（首行均带 SPDX 许可，移植自 Guix-configs）：

| 脚本 | 用途 |
|------|------|
| `which-key` | 前缀 `?` 的快捷键速查浮窗 |
| `window-jump` | 前缀 `f`，fzf 列出所有会话的窗口并跳转 |
| `clipboard-copy` | 复制钩子：写 Android 剪贴板（可选），永不阻塞 |
| `paste-clipboard` | 粘贴钩子：Android 剪贴板 → tmux 缓冲 → 粘贴 |
| `termux-api-ready` | 探测 Termux:API App 是否可用（带缓存） |

`window-jump` 需要 `fzf`（已随 `packages.txt` 安装）。

---

## 🎨 自定义

```bash
dot cd
$EDITOR tmux/.config/tmux/tmux.conf   # 编辑配置
dot restow tmux                        # 重新链接
```

改完后在 tmux 里按 `前缀 + r` 即可重载，无需重启会话。

想改回桌面端的 `C-x` 前缀，把这两行改掉即可：

```tmux
set -g prefix C-b
bind C-b send-prefix
```

---

## ❓ 未移植的桌面功能

这些依赖桌面环境，移动端未包含（如需可自行添加）：

- **侧边栏**：Guile 长驻渲染进程 + 浮动 pane，桌面用 `B` 开关；
- **Wayland 剪贴板**：`wl-copy`/`wl-paste`，已用 OSC52 / termux-clipboard 替代；
- **herdr 会话选择器**：`99-selector.fish` 在 foot/kitty 启动时弹 fzf 菜单；
- **`tmuxifier`** 会话布局。
