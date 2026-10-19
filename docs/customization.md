# 自定义配置

本文档介绍如何修改和自定义 dotfiles 配置。

> 所有示例中 `dot cd` 进入仓库；编辑命令使用 `$EDITOR`（按 hx→nano→vi 自动降级，见 `conf.d/05-env.fish`）。

---

## 🐟 修改 Fish 配置

### 方式一：使用快捷命令

```bash
fishrc
```

打开配置入口文件，各功能的实际位置见文件内注释：

| 文件 | 功能 |
|------|------|
| `conf.d/00-init.fish` | 工具集成 (zoxide / starship / fzf / atuin) |
| `conf.d/05-env.fish` | 环境变量与 PATH |
| `conf.d/10-aliases.fish` | 现代 CLI 别名 (eza / bat / dust / fd / rg) |
| `conf.d/15-tmux.fish` | 自动进入 tmux 会话 (main 共享 / tab 独立) |
| `conf.d/20-startup.fish` | 欢迎消息与提示符 |
| `conf.d/99-abbr.fish` | 移动友好缩写 |
| `functions/` | 自定义函数 (含 `retry`) |

### 方式二：直接编辑仓库文件

```bash
dot cd
$EDITOR fish/.config/fish/conf.d/99-abbr.fish

# 重新链接
dot restow fish
```

---

## 🧩 调整 tmux 会话复用

`conf.d/15-tmux.fish` 会在交互式 Fish 启动时自动接入 tmux，默认所有标签页共享名为 `main` 的会话。

```bash
# 临时绕过自动进入 (只想开一个普通 Fish)
TMUX_AUTO=0 fish

# 临时改为每标签页独立会话
TMUX_AUTO=tab fish

# 永久改为每标签页独立 (写入 fish universal 变量)
set -Ux TMUX_AUTO tab

# 恢复默认共享 main
set -Ue TMUX_AUTO
```

| TMUX_AUTO 取值 | 行为 |
|----------------|------|
| 未设置 / `main` | 所有标签页复用 `main` 会话 (已存在则 attach) |
| `tab` / `per-tab` | 每个标签页新建独立会话，可用会话列表切换 |
| `0` / `off` / `false` / `no` | 不自动进入 tmux |

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

当前 MOTD 显示：Termux 版本 / Android / 设备、Tailscale IP、tmux 会话、
Emacs · Pi 版本、内存占用、dotfiles 仓库状态与时间。修改后直接开新标签页验证。

静态信息（设备、工具版本、仓库路径）会缓存在 `~/.cache/termux-motd-cache`，
TTL 1 天或 `$TERMUX_VERSION` 变化时重建；删除该文件可强制刷新。

临时不看 MOTD：

```bash
touch ~/.hushlogin            # 持久关闭
TERMUX_HUSHLOGIN=1 fish       # 单次关闭
```

---

## ➕ 添加自定义别名

编辑 `fish/.config/fish/conf.d/99-abbr.fish`，添加：

```fish
abbr -a 别名 '命令'
```

示例：

```fish
abbr -a gco 'git checkout'
abbr -a gb 'git branch'
abbr -a glg 'git log --oneline --graph'
```

然后重新链接：

```bash
dot restow fish
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
cp fish/.config/fish/conf.d/99-abbr.fish fish/.config/fish/conf.d/99-abbr.fish.bak.$(date +%Y%m%d_%H%M%S)
```

### 2. 验证语法

**Fish:**
```bash
fish -n fish/.config/fish/conf.d/99-abbr.fish
```

**JSON:**
```bash
fastfetch --config fastfetch/.config/fastfetch/config.jsonc
```

### 3. 测试加载

```bash
fish   # 启动新 Fish 会话验证
```

### 4. 更新文档

- 修改 `docs/` 中的相关文档
- 更新 `cheat.fish` 中的命令列表

---

## 🆕 添加新 Fish 函数

创建文件 `fish/.config/fish/functions/函数名.fish`：

```fish
function 函数名
    # 参数检查
    if test -z "$argv[1]"
        echo "用法: 函数名 <参数>"
        return 1
    end

    # 功能实现
    echo "正在处理 $argv[1]"
end
```

然后重新链接：

```bash
dot restow fish
```

---

## 📋 配置状态检查清单

在完成任务后，验证配置完整性：

- [ ] Fish 配置文件语法正确 (`fish -n` 无错误)
- [ ] Fastfetch 配置 JSON 语法正确
- [ ] 新添加的缩写已记录到 `cheat.fish`
- [ ] 新添加的函数已记录到 `cheat.fish`
- [ ] 用户文档已更新
- [ ] Stow 链接正常 (`dot status` 无错误)
- [ ] 功能已在实际环境中测试
- [ ] 移动端显示效果已验证
- [ ] Git 提交已完成 (如适用)
