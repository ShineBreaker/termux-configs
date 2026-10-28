# 自定义配置

本文档介绍如何修改和自定义 dotfiles 配置。

> 所有示例中 `dot cd` 进入仓库；编辑命令使用 `$EDITOR`（按 hx→nano→vi 自动降级，见 `conf.d/05-env.fish`）。

---

## 🐟 修改 Fish 配置

### 方式一：使用快捷命令

```bash
fishrc
```

打开配置入口文件，各功能的实际位置见文件内注释。

**改之前先看这张表——多数改动只需动一个文件：**

| 想改什么 | 只改这个文件 | 生效方式 |
|----------|--------------|----------|
| 缩写 | `fish/.config/fish/data/abbr.tsv` | `dot restow fish` + `just docs` |
| 别名 (现代 CLI) | `fish/.config/fish/data/alias.tsv` | `dot restow fish` + `just docs` |
| Fish 函数 | `fish/.config/fish/functions/*.fish` | `dot restow fish` + `just docs` |
| 配置包 | `data/packages.tsv` (+ 新建目录) | `just docs` |
| just 指令 | `justfile` | `just docs` |
| tmux 键位 | `tmux/.config/tmux/tmux.conf` 的 `#@` 注解 | `dot restow tmux` + `just docs` |
| 文档表格 / cheat | 以上数据文件（生成） | `just docs` |

`conf.d/99-abbr.fish` 与 `conf.d/10-aliases.fish` 现在只是**加载器**（读上表里的
`data/*.tsv`），不要直接往里加定义，否则 `cheat` 与文档不会同步。

### 方式二：直接编辑仓库文件

```bash
dot cd
$EDITOR fish/.config/fish/data/abbr.tsv   # 例：加一条缩写

dot restow fish      # 重新链接，运行时生效
just docs            # 同步 README/docs/cheat
```

---

## 🧩 调整 tmux 会话复用

`conf.d/15-tmux.fish` 会在交互式 Fish 启动时自动接入 tmux。每个标签页会拿到一个
人类可读、在 server 内唯一的会话名（如 `calm-otter`，由 `scripts/tab-name` 生成），
状态栏左上角与终端标题都显示它。默认这些标签页是 `main` 的分组会话：窗口和历史
共享，但各自的当前窗口独立，窗口内容在关掉标签页/重启后仍然在。

```bash
# 临时绕过自动进入 (只想开一个普通 Fish)
TMUX_AUTO=0 fish

# 临时改为每标签页完全独立 (窗口不共享)
TMUX_AUTO=tab fish

# 临时指定本标签页的名字
TMUX_TAB_NAME=work fish

# 永久改为每标签页独立 (写入 fish universal 变量)
set -Ux TMUX_AUTO tab

# 恢复默认 (共享 main 的窗口)
set -Ue TMUX_AUTO
```

| TMUX_AUTO 取值 | 行为 |
|----------------|------|
| 未设置 / `main` | 每标签页一个分组会话，共享 `main` 的窗口/历史 |
| `tab` / `per-tab` | 每个标签页新建完全独立的会话，可用会话列表切换 |
| `0` / `off` / `false` / `no` | 不自动进入 tmux |

命名与改名：

| 需求 | 做法 |
|------|------|
| 换个词库/前缀 | 编辑 `~/.config/tmux/scripts/tab-name` 里的词数组 |
| tmux 内新建标签页 | 前缀 `C` |
| 给当前标签页改名 | 前缀 `N` |
| 看所有标签页 | `tmux ls` |

修改后重新链接并开新标签页验证：

```bash
dot restow fish
```

### 自定义 tmux 键位与外观

```bash
dot cd
$EDITOR tmux/.config/tmux/tmux.conf   # 前缀、分屏、状态栏等
dot restow tmux
```

已在 tmux 内时，改完按 `前缀 + r` 立即重载。前缀键保留 `Ctrl-b`（桌面端为
`C-x`）；完整键位表与剪贴板说明见 [tmux 配置](./tmux.md)。

---

## ⌨️ 修改快捷键栏

```bash
# 编辑仓库中的配置文件
dot cd
$EDITOR termux/.termux/termux.properties

# 重新链接并重载
dot restow termux
termux-reload-settings
```

### 快捷键栏配置格式

当前使用 Termux 默认键栏，以下为自定义示例：

```properties
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'], \
              ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
```

可用按键：
- `ESC`, `TAB`, `HOME`, `END`, `PGUP`, `PGDN`
- `UP`, `DOWN`, `LEFT`, `RIGHT`
- `CTRL`, `ALT`, `FN`
- `/`, `-`, `|`, 等符号键

---

## 🪧 自定义 Termux 登录提示 (MOTD)

Termux 的 `login` 会优先执行 `~/.termux/motd.sh`，存在时不再显示
`$PREFIX/etc/motd` 的默认欢迎语。本项目把自定义 MOTD 放在
`termux/.termux/motd.sh`，由 Stow 链接：

```bash
dot cd
$EDITOR termux/.termux/motd.sh   # 编辑内容
dot restow termux                # 重新链接
```

当前 MOTD 显示：Termux 版本 / Android / 设备、Tailscale IP、tmux 标签页名、
Emacs · Pi 版本、内存占用、dotfiles 仓库状态与时间。修改后直接开新标签页验证。

静态信息（设备、工具版本、仓库路径）会缓存在 `~/.cache/termux-motd-cache`，
TTL 1 天或 `$TERMUX_VERSION` 变化时重建；删除该文件可强制刷新。

临时不看 MOTD：

```bash
touch ~/.hushlogin            # 持久关闭
TERMUX_HUSHLOGIN=1 fish       # 单次关闭
```

---

## ➕ 添加自定义缩写 / 别名

缩写写在 `fish/.config/fish/data/abbr.tsv`，别名写在
`fish/.config/fish/data/alias.tsv`；两者格式相同（制表符分隔）：

```
<分类>	<名字>	<展开>	<说明>	<条件>     # 缩写
<名字>	<展开>	<说明>	<条件>              # 别名
```

示例（加一行即可）：

```
🔀 Git	gco	git checkout	检出分支	-
🔀 Git	graph	git log --oneline --graph	图形化历史	-
```

说明：

- 条件列 `-` = 始终启用；填命令名 = 该命令已安装才启用；`!命令名` = 未安装才启用。
- 别名在管道 / 命令替换同样生效；缩写只在命令行首展开，纯提速用缩写。

然后重新链接并同步文档：

```bash
dot restow fish
just docs
```

---

## 🎨 自定义 Fastfetch

### 编辑标准配置

```bash
ffcfg
```

或手动编辑（仓库中 `fastfetch/.config/fastfetch/config.jsonc`）：

```bash
dot cd
$EDITOR fastfetch/.config/fastfetch/config.jsonc
```

### 添加新模块

在 `modules` 数组中添加：

```json
{
  "type": "localip",
  "key": "IP"
}
```

### 重新链接

```bash
dot restow fastfetch
```

---

## 🖊️ 自定义 Helix

| 文件 | 作用 |
|------|------|
| `config.toml` | 编辑器行为 (鼠标、自动保存、状态栏等) |
| `languages.toml` | formatter / language-server (默认 fish/clang) |
| `themes/transparent.toml` | 透明背景主题，继承内置 `base16_transparent` |

```bash
helixrc              # 打开主配置
$EDITOR $(dot path)/helix/.config/helix/languages.toml
$EDITOR $(dot path)/helix/.config/helix/themes/transparent.toml

dot restow helix     # 重新链接
```

Helix 在启动时读取配置，改完重开 `hx` 即生效。

---

## 📝 提交更改到 Git

```bash
dot cd
git add .
git commit -m "描述你的修改"
git push
```

---

## 🔧 修改配置的最佳实践

### 1. 备份原文件

```bash
cp fish/.config/fish/data/abbr.tsv fish/.config/fish/data/abbr.tsv.bak.$(date +%Y%m%d_%H%M%S)
```

### 2. 验证语法

**Fish:**
```bash
fish -n fish/.config/fish/conf.d/99-abbr.fish   # 加载器语法
```

**JSON:**
```bash
fastfetch --config fastfetch/.config/fastfetch/config.jsonc
```

### 3. 测试加载

```bash
fish   # 启动新 Fish 会话验证
```

### 4. 同步文档（不再手改文档表格）

```bash
just docs          # 从数据文件重新生成 README / docs / cheat
just check         # 校验生成结果是否最新
```

---

## 🆕 添加新 Fish 函数

创建文件 `fish/.config/fish/functions/函数名.fish`，并在定义行写上 `-d "说明"`
（`cheat` 与文档会从 `-d` 描述自动收录，无需再手改任何列表）：

```fish
function 函数名 -d "一句话说明"
    # 参数检查
    if test -z "$argv[1]"
        echo "用法: 函数名 <参数>"
        return 1
    end

    # 功能实现
    echo "正在处理 $argv[1]"
end
```

然后重新链接并同步文档：

```bash
dot restow fish
just docs
```

---

## 📋 配置状态检查清单

在完成任务后，验证配置完整性：

- [ ] Fish 配置文件语法正确 (`fish -n` 无错误)
- [ ] Fastfetch 配置 JSON 语法正确
- [ ] 数据文件改动后已运行 `just docs`（cheat 与文档自动同步）
- [ ] `just check` 通过（生成文档与数据源一致）
- [ ] Stow 链接正常 (`dot status` 无错误)
- [ ] 功能已在实际环境中测试
- [ ] 移动端显示效果已验证
- [ ] Git 提交已完成 (如适用)
