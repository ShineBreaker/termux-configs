# Dotfiles 管理

本文档介绍如何使用 `dot` 命令和 GNU Stow 管理配置文件。

---

## 🔧 使用 `dot` 命令

`dot` 是一个封装了 Stow 的便捷命令，简化了 dotfiles 管理操作。

### 常用命令

```bash
# 进入 dotfiles 目录
dot cd

# 链接配置包
dot stow fish
dot stow termux

# 取消链接
dot unstow fish

# 重新链接 (修改配置后)
dot restow fish

# 查看所有包状态
dot list

# 检查链接状态
dot status

# 添加新包
dot add helix
```

---

## 📦 手动使用 Stow

```bash
cd ~/Documents/dotfiles

# 链接包
stow -t ~ <package>

# 取消链接
stow -D -t ~ <package>

# 重新链接
stow -R -t ~ <package>
```

### 常用选项

| 选项 | 说明 |
|------|------|
| `-t ~` | 指定目标目录为用户主目录 |
| `-D` | 删除（取消链接） |
| `-R` | 重新链接（先删除再链接） |
| `-n` | 模拟运行（不实际执行） |
| `-v` | 显示详细信息 |

---

## 📁 添加新配置包

### 使用 `dot add` 命令

```bash
# 创建新包结构
dot add helix

# 这将创建：
# helix/
# └── .config/
#     └── helix/
```

### 手动创建

1. 在仓库根目录创建包目录：
   ```bash
   mkdir -p helix/.config/helix
   ```

2. 将配置文件移动到包目录：
   ```bash
   mv ~/.config/helix/config.toml helix/.config/helix/
   ```

3. 创建链接：
   ```bash
   dot stow helix
   ```

---

## 🔍 检查链接状态

```bash
# 查看所有链接状态
dot status

# 或使用 Stow 模拟运行
stow -n -v -t ~ fish
```

---

## 🔄 重新链接所有包

```bash
cd ~/Documents/dotfiles
stow -R -t ~ bash fish fastfetch termux
```

---

## ❌ 解决链接冲突

如果 Stow 报告目标文件已存在：

```bash
# 1. 检查冲突
dot status

# 2. 备份并删除冲突文件
mv ~/.config/fish ~/.config/fish.bak.$(date +%Y%m%d_%H%M%S)

# 3. 重新链接
dot stow fish
```

---

## 💡 最佳实践

1. **始终在仓库目录操作**
   ```bash
   dot cd
   ```

2. **修改前先备份**
   ```bash
   cp fish/.config/fish/config.fish fish/.config/fish/config.fish.bak
   ```

3. **修改后重新链接**
   ```bash
   dot restow fish
   ```

4. **定期提交到 Git**
   ```bash
   git add .
   git commit -m "描述修改内容"
   git push
   ```
