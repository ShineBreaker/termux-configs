# 快捷键与命令

本文档介绍 Termux 快捷键栏和 Fish Shell 的快捷命令。

---

## ⌨️ 快捷键栏

使用 Termux 默认单行快捷键栏，仅微调样式选项（如按键图标风格、按钮文字大小写）。

如需自定义按键布局，可参考 Termux wiki 的 extra-keys 配置：https://wiki.termux.com/wiki/Touch_Keyboard

---

## 📝 Fish 快捷命令

> 本节由 `tools/gen-docs` 从 `fish/.config/fish/data/*.tsv`、`justfile`、`bin/.local/bin/dot`
> 生成，不要手改；改数据文件后运行 `just docs`。

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

### 函数

<!-- gen:functions -->
| 函数 | 说明 |
|------|------|
| `dot` |  |
| `retry` | 命令失败时自动重试 |
| `run` | 按当前目录构建文件派发: justfile→just |
| `termux-reload` |  |
| `update` |  |
<!-- /gen -->

### Dotfiles 管理

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

### just 一键指令

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

### tmux 会话复用

新标签页会自动进入 tmux。每个标签页是一个独立会话，会话名由 `scripts/tab-name`
自动生成（如 `calm-otter`），显示在状态栏左上角和终端标题里；默认它们共享 `main`
的窗口与历史（分组会话），断开或重启 Termux 后仍在。完整键位与配置见
[tmux 配置](./tmux.md)。

<!-- gen:tmux-keys -->
前缀键为 `Ctrl-b`（Termux 上为音量+ 与 `b` 同按）。

**基础**

| 按键 | 操作 |
|------|------|
| `r` | 重新加载配置 |
| `?` | 快捷键速查 (本浮窗) |
| `[ 或 Esc` | 进入复制模式 |

**窗格**

| 按键 | 操作 |
|------|------|
| `\` | 左右分屏 (保持当前路径) |
| `-` | 上下分屏 (保持当前路径) |
| `h j k l` | 切换窗格 (Vi 风格) |
| `z` | 放大 / 还原当前窗格 |

**窗口·会话**

| 按键 | 操作 |
|------|------|
| `c` | 新建窗口 |
| `C` | 新建标签页 (自动取名) |
| `N` | 重命名当前标签页 |
| `x` | 关闭窗格 |
| `X` | 关闭窗口 |
| `K` | 关闭会话 |
| `d` | 脱离会话 (留在后台) |
| `0-9` | 切换到对应窗口 |
| `s` | 会话·窗口浮窗选择器 |
| `f` | fzf 跨会话模糊跳转窗口 |

**粘贴**

| 按键 | 操作 |
|------|------|
| `p` | 粘贴 (Android 剪贴板 → tmux 缓冲) |

无需前缀：

| 按键 | 操作 |
|------|------|
| `Alt+←→↑↓` | 切换窗格 (Termux 音量- = Alt) |
| `Ctrl+←→↑↓` | 调整窗格大小 (Termux 音量+ = Ctrl) |
| `Alt+1~5` | 快速切换窗口 |
| `Alt+Shift+H` | 进入复制模式 (向上回滚) |
| `Alt+Shift+F` | 搜索回滚内容 |
| `Alt+Shift+/` | 打开 tmux 命令提示符 |
| `Shift+Insert` | 粘贴 |
<!-- /gen -->

复制模式下：`v` 开始选择，`y` / `Enter` 复制并退出，`Esc` 取消。复制会写入 tmux
缓冲并尝试 OSC52；若已装 Termux:API 应用，还会同步到 Android 剪贴板。

模式控制 (详见 `docs/customization.md`)：`TMUX_AUTO=0 fish` 跳过自动进入，
`TMUX_AUTO=tab fish` 让每个标签页独立，`TMUX_TAB_NAME=work fish` 指定本标签页名字。

---

## 💡 使用提示

- 所有缩写命令在 Fish 中会自动展开
- 使用 `cheat` 命令可以随时查看此参考
- 命令支持 Tab 自动补全
- 装了 Atuin 后，按 `Ctrl-R` 或 `↑` 可模糊搜索历史命令（Termux 音量+ 即 Ctrl）
