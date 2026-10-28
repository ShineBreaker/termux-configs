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

# 2. 进入仓库目录，检查配置语法 (配置拆分在 conf.d/)
dot cd
fish -n fish/.config/fish/conf.d/*.fish

# 3. 修复错误后重新链接
stow -R -t ~ fish

# 4. 重新启动 Fish
fish
```

### 缩写命令不生效

**症状**: 输入缩写后没有展开

**解决**:
```bash
# 1. 检查缩写是否已定义
abbr -a | grep 缩写名

# 2. 重新链接配置
dot restow fish

# 3. 重新启动 Fish 会话
fish

# 4. 检查 Fish 版本
fish --version
```

### Fish 没有继承 Bash 环境

**症状**: 在用户 profile (`~/.bash_profile`/`~/.bash_login`/`~/.profile`) 中导出的变量在 Fish 里看不到

**解决**:
```bash
# 1. 检查 fenv 是否可用 (由 Oh My Fish 的 foreign-env 插件提供)
fish -c 'type -q fenv; and echo 正常; or echo 缺失'

# 2. 检查 foreign-env 插件是否存在
ls "$HOME/.local/share/omf/pkg/foreign-env"

# 3. 确认用户 profile 存在 (bash 登录按顺序取第一个:
#    ~/.bash_profile > ~/.bash_login > ~/.profile)
ls ~/.bash_profile ~/.bash_login ~/.profile

# 4. 缺失时重跑完整安装，自动补装 Oh My Fish 与 foreign-env
bash setup.sh
```

---

## 🧩 tmux 相关问题

### 开新标签页没有自动进入 tmux

```bash
# 1. 确认已安装 tmux
pkg install tmux

# 2. 确认未被临时禁用 (TMUX_AUTO=0)
fish -c 'set -q TMUX_AUTO; and echo "TMUX_AUTO=$TMUX_AUTO"; or echo "未设置"'

# 3. 临时绕过时不会再自动进入，属于预期行为
TMUX_AUTO=0 fish
```

### 想临时回到普通 Fish

```bash
TMUX_AUTO=0 fish
```

### 不小心脱离了 tmux (标签页已关闭)

```bash
# 查看后台会话 (窗口内容都在 main 里)
tmux ls
# 重新接入共享窗口的 main
tmux attach -t main
```

因为每个标签页都是 `main` 的分组会话，窗口本身跟着 `main` 活，随便 attach 一个
（或直接开新标签页）就能回到同一套窗口。

### 多个标签页分不清谁是谁

每个标签页的会话名就是标识符（如 `calm-otter`、`bold-fox`），显示在状态栏左上角
和终端标题里。若名字被改乱了，用 `tmux ls` 看清单，或在当前标签页按前缀 `N` 改名；
若看不到，确认 `status-left` 未被自定义覆盖。

### 每个标签页都创建了新会话

默认行为就是“每标签页一个分组会话”（共享 `main` 的窗口），不是故障。只有 `tab`
模式才会让每个标签页完全独立；想回到默认：

```bash
set -Ue TMUX_AUTO
```

### `tmux ls` 里有一堆没在用的会话名

分组会话在客户端断开后由下一次开标签页（`scripts/tab-name`）回收；若想立即清，
直接手动跑一次取名脚本即可（它的副作用就是清理，输出丢弃）：

```bash
bash ~/.config/tmux/scripts/tab-name >/dev/null
tmux ls        # 只剩 main 与正在用的标签页
```

### 复制后 Android 剪贴板没有内容

复制会先写入 tmux 缓冲并尝试 OSC52；若想同时写入系统剪贴板，需要安装
[Termux:API](https://wiki.termux.com/wiki/Termux:API) **配套 App**（仅有
`termux-api` 包不够）。脚本只探测一次并缓存结果，装上 App 后清缓存重试：

```bash
rm -f ~/.cache/tmux-clipboard-api
```

### tmux 配置改了不生效

tmux 配置在 **server 启动时**读取一次。已有 server 在跑（例如之前手动开过
会话）时，新配置不会自动生效：

```bash
# 在 tmux 内按前缀 + r 重载，或手动 source
tmux source-file ~/.config/tmux/tmux.conf
```

若改了 `prefix` 等客户端级选项，重载后可能需要 `prefix + :` 确认新前缀。
彻底重来（会丢失所有会话）：`tmux kill-server`，然后开新标签页重新进入。

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
ls -la ~/.termux/termux.properties
```

---

## 📊 Fastfetch 问题

### Fastfetch 显示异常

**症状**: Fastfetch 输出格式错乱或显示错误

**解决**:
```bash
# 1. 检查配置文件 JSON 语法
fastfetch --config ~/.config/fastfetch/config.jsonc

# 2. 查看详细错误
fastfetch --config ~/.config/fastfetch/config.jsonc --debug

# 3. 临时禁用 Fastfetch
# 卸载即自动回退 (配置有 type -q 保护，无报错)；或注释掉
# fish/.config/fish/conf.d/20-startup.fish 中 fish_greeting 的 fastfetch 调用
```

---

## 🔧 Stow 相关问题

### Stow 链接冲突

**症状**: Stow 报告目标文件已存在

**解决**:
```bash
# 1. 检查冲突
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

## 🧭 dot 命令问题

### dot 命令找不到仓库

`dot` 依赖 `~/.local/bin/dot` 软链接定位仓库。确认 `bin` 包已链接：

```bash
dot stow bin
```

或手动指定位置：

```fish
set -Ux DOTFILES_DIR ~/dotfiles
```

### dot 命令未找到

确认 `~/.local/bin` 在 PATH 中（`05-env.fish` 已自动添加），并检查链接：

```bash
ls -la ~/.local/bin/dot
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

# 3. 使用 SSH 克隆（需要配置密钥）
git clone git@github.com:ShineBreaker/termux-configs.git ~/dotfiles
```

---

## 🔄 恢复默认设置

### 恢复默认 shell

```bash
chsh -s bash
```

### 重新链接所有包

```bash
cd "$(dot path)"
dot restow           # 按 data/packages.tsv 重新链接全部包
```

### 完全卸载

```bash
# 1. 切换回 Bash
chsh -s bash

# 2. 取消所有链接
cd "$(dot path)"
dot unstow           # 按 data/packages.tsv 取消全部链接

# 3. 删除仓库（可选）
rm -rf ~/dotfiles
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

### 登录提示 (MOTD) 不显示或信息不对

Termux 的 `login` 优先执行 `~/.termux/motd.sh`，不显示通常是因为：

```bash
# 1. 确认链接与可执行位
ls -la ~/.termux/motd.sh

# 2. 看是否被 hushlogin 关掉
ls ~/.hushlogin 2>/dev/null && echo "hushlogin 存在，MOTD 已关闭"
echo "$TERMUX_HUSHLOGIN"

# 3. 静态信息有 1 天缓存，强制刷新
rm -f ~/.cache/termux-motd-cache

# 4. 直接运行看输出
bash ~/.termux/motd.sh
```

想关掉 MOTD：`touch ~/.hushlogin`（或单次 `TERMUX_HUSHLOGIN=1 fish`）。

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
