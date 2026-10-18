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
