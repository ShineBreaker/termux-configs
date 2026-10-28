# Dotfiles 管理

本文档介绍如何使用 `dot` 命令和 GNU Stow 管理配置文件。

---

## 🔧 使用 `dot` 命令

`dot` 是一个封装了 Stow 的便捷命令。它通过 `~/.local/bin/dot` 软链接自动定位仓库，**与克隆位置无关**；也可用 `DOTFILES_DIR` 环境变量手动指定。

> 下表由 `tools/gen-docs` 从 `bin/.local/bin/dot` 的 `usage()` 生成，不要手改。

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

---

## 📦 手动使用 Stow

```bash
cd ~/dotfiles   # 你的仓库克隆位置

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

包的唯一真相源是 `data/packages.tsv`（列：包名 / 说明 / 链接目标 / 是否保留）。
`dot add` 会同时建目录并登记到该文件，推荐用它。

### 使用 `dot add` 命令

```bash
# 交互式创建新包结构，并追加一行到 data/packages.tsv
dot add nvim

# 这将创建：
# nvim/
# └── .config/
#     └── nvim/
```

### 手动创建

1. 在仓库根目录创建包目录：
   ```bash
   mkdir -p nvim/.config/nvim
   ```

2. 在 `data/packages.tsv` 追加一行：
   ```
   nvim	Neovim 配置	~/.config/nvim/	-
   ```

3. 将配置文件移动到包目录：
   ```bash
   mv ~/.config/nvim/config.toml nvim/.config/nvim/
   ```

4. 链接并同步文档：
   ```bash
   dot stow nvim
   just docs
   ```

---

## 🔍 检查链接状态

```bash
# 查看所有链接状态
dot status
```

`dot status` 对每个包显示三种状态之一：已链接、未链接、链接冲突。

---

## 🔄 重新链接所有包

```bash
cd "$(dot path)"
dot restow           # 按 data/packages.tsv 重新链接全部包
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
   cp fish/.config/fish/data/abbr.tsv fish/.config/fish/data/abbr.tsv.bak
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
