# 自定义配置

本文档介绍如何修改和自定义 dotfiles 配置。

---

## 🐟 修改 Fish 配置

### 方式一：直接编辑仓库文件

```bash
# 编辑配置文件
nano ~/Documents/dotfiles/fish/.config/fish/config.fish

# 重新链接
dot restow fish
```

### 方式二：使用快捷命令

```bash
fishrc
```

这将直接在编辑器中打开配置文件。

---

## ⌨️ 修改快捷键栏

```bash
# 编辑仓库中的配置文件
nano ~/Documents/dotfiles/termux/.termux/termux.properties

# 重新链接并重载
dot restow termux
termux-reload-settings
```

### 快捷键栏配置格式

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

编辑 `~/Documents/dotfiles/fish/.config/fish/config.fish`，添加：

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

或手动编辑：

```bash
nano ~/Documents/dotfiles/fastfetch/.config/fastfetch/config.jsonc
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

## 📝 提交更改到 Git

```bash
cd ~/Documents/dotfiles
git add .
git commit -m "描述你的修改"
git push
```

---

## 🔧 修改配置的最佳实践

### 1. 备份原文件

```bash
cp fish/.config/fish/config.fish fish/.config/fish/config.fish.bak.$(date +%Y%m%d_%H%M%S)
```

### 2. 验证语法

**Fish:**
```bash
fish -n fish/.config/fish/config.fish
```

**JSON:**
```bash
fastfetch --config fastfetch/.config/fastfetch/config.jsonc
```

### 3. 测试加载

```bash
source ~/.config/fish/config.fish
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
