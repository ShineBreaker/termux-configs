# 故障排除

本文档介绍常见问题的解决方法。

---

## 🐟 Fish 相关问题

### Fish 没有启动

```bash
chsh -s fish
```

然后重启 Termux。

### Fish 配置错误

**症状**: 启动 Fish 时显示错误信息

**解决**:
```bash
# 1. 使用 Bash 启动
bash

# 2. 进入仓库目录
cd ~/Documents/dotfiles

# 3. 检查 Fish 配置语法
fish -n fish/.config/fish/config.fish

# 4. 修复错误后重新链接
stow -R -t ~ fish

# 5. 重新加载 Fish
fish
source ~/.config/fish/config.fish
```

### 缩写命令不生效

**症状**: 输入缩写后没有展开

**解决**:
```bash
# 1. 检查缩写是否已定义
abbr -a | grep 缩写名

# 2. 重新链接配置
cd ~/Documents/dotfiles
stow -R -t ~ fish

# 3. 重新加载配置
source ~/.config/fish/config.fish

# 4. 检查 Fish 版本
fish --version
```

---

## ⌨️ 快捷键栏问题

### 快捷键栏不显示

```bash
# 重新链接配置
dot restow termux

# 重载设置
termux-reload-settings

# 或重启 Termux
```

### 检查配置文件权限

```bash
ls -la termux/.termux/termux.properties
```

---

## 📊 Fastfetch 问题

### Fastfetch 显示异常

**症状**: Fastfetch 输出格式错乱或显示错误

**解决**:
```bash
# 1. 进入仓库目录
cd ~/Documents/dotfiles

# 2. 检查配置文件 JSON 语法
fastfetch --config fastfetch/.config/fastfetch/config.jsonc

# 3. 查看详细错误
fastfetch --config fastfetch/.config/fastfetch/config.jsonc --debug

# 4. 临时禁用 Fastfetch
# 编辑 fish/.config/fish/config.fish，注释掉 fish_greeting 中的 fastfetch 调用
```

---

## 🔧 Stow 相关问题

### Stow 链接冲突

**症状**: Stow 报告目标文件已存在

**解决**:
```bash
# 1. 检查冲突
cd ~/Documents/dotfiles
dot status

# 2. 备份并删除冲突文件
mv ~/.config/fish ~/.config/fish.bak.$(date +%Y%m%d_%H%M%S)

# 3. 重新链接
dot stow fish
```

### Stow 命令未找到

```bash
pkg install stow
```

---

## 🌐 Git 相关问题

### Git 克隆失败

**症状**: 无法克隆仓库

**解决**:
```bash
# 1. 检查网络连接
ping github.com

# 2. 安装 Git
pkg install git

# 3. 使用 SSH 或 HTTPS 克隆
# HTTPS:
git clone https://github.com/用户名/仓库名.git ~/Documents/dotfiles

# SSH:
git clone git@github.com:用户名/仓库名.git ~/Documents/dotfiles
```

---

## 🔄 恢复默认设置

### 恢复默认 shell

```bash
chsh -s bash
```

### 重新链接所有包

```bash
cd ~/Documents/dotfiles
stow -R -t ~ bash fish fastfetch termux
```

### 完全卸载

```bash
# 1. 切换回 Bash
chsh -s bash

# 2. 取消所有链接
cd ~/Documents/dotfiles
stow -D -t ~ bash fish fastfetch termux

# 3. 删除仓库（可选）
cd ~
rm -rf ~/Documents/dotfiles
```

---

## 📱 Termux 应用问题

### 应用崩溃或无响应

1. 强制停止 Termux 应用
2. 清除应用数据（会删除所有数据，谨慎操作）
3. 重新安装 Termux

### 存储权限问题

```bash
termux-setup-storage
```

---

## 💡 通用诊断步骤

1. **检查错误信息** - 仔细阅读错误输出
2. **验证语法** - 使用 `fish -n` 或 JSON 验证器
3. **检查链接** - 使用 `dot status` 或 `ls -la`
4. **查看日志** - 使用 `--debug` 或 `-v` 选项
5. **搜索文档** - 查阅官方文档和 Wiki

---

## 🔗 参考资源

- [Fish 文档](https://fishshell.com/docs/current/)
- [Termux Wiki](https://wiki.termux.com/)
- [GNU Stow 手册](https://www.gnu.org/software/stow/manual/)
- [Fastfetch GitHub](https://github.com/fastfetch-cli/fastfetch)
