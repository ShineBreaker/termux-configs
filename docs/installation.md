# 安装指南

本文档介绍如何在 Termux 上安装和部署 dotfiles 配置。

## 系统要求

- **操作系统**: Android 7.0+
- **应用**: Termux (F-Droid 或 GitHub 版本)
- **依赖**: Git, GNU Stow, Fish Shell（Oh My Fish 由安装脚本自动安装）
- **可选**: Fastfetch, Starship, zoxide, fzf

---

## 🚀 快速开始

### 方式一：自动安装（推荐）

```bash
# 1. 安装必要依赖
pkg install git stow fish

# 2. 克隆仓库到任意目录 (此处以 ~/dotfiles 为例)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles

# 3. 运行安装脚本 (脚本自动定位自身所在目录)
cd ~/dotfiles
bash setup.sh

# 4. 重启 Termux
# 完全关闭应用后重新打开
```

安装脚本会自动装好 [just](https://github.com/casey/just) 与 [Oh My Fish](https://github.com/oh-my-fish/oh-my-fish) + foreign-env（后者让 Fish 继承 Bash 登录环境）。之后在仓库目录运行 `just` 查看全部一键指令，常用：

```bash
just setup          # 完整安装
just install-emacs  # 安装 Emacs 配置 (UniEmacs)：clone 仓库、部署原生 Emacs 入口、预装字体并在 Termux 预构建插件，见 UniEmacs docs/mobile
just restow         # 修改配置后重新链接
```

### 方式二：手动安装

```bash
# 1. 安装依赖
pkg install -y git stow fish fastfetch oma

# 2. 克隆仓库 (任意目录)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles
cd ~/dotfiles

# 3. 链接所有配置包
stow -t ~ bin fish fastfetch starship atuin git helix tmux termux

# 4. 安装 Oh My Fish 与 foreign-env（让 Fish 继承 Bash 环境）
#    先下载安装器再执行，才能传入非交互参数
curl -fsSL https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install -o "$TMPDIR/omf-install.fish"
fish "$TMPDIR/omf-install.fish" --noninteractive --yes
fish -c 'omf install foreign-env'
rm -f "$TMPDIR/omf-install.fish"

# 5. 设置默认 shell
chsh -s fish

# 6. 重载 Termux 设置
termux-reload-settings

# 7. 重启 Termux
```

---

## 🔄 同步配置到新设备

```bash
# 1. 在新设备上安装依赖
pkg install git stow fish

# 2. 克隆仓库 (任意目录)
git clone https://github.com/ShineBreaker/termux-configs.git ~/dotfiles

# 3. 运行安装脚本
cd ~/dotfiles
bash setup.sh

# 4. 重启 Termux
```

---

## 📱 使用技巧

1. **自动补全**：输入命令时按 `TAB` 键
2. **历史搜索**：按 `↑` 键搜索历史命令
3. **长按复制**：长按终端文本可复制
4. **音量键**：音量+ 是 Ctrl，音量- 是 Alt

---

## 🔧 进阶功能（可选）

工具遵循"已安装则自动启用"的原则（见 `fish/.config/fish/conf.d/00-init.fish`）：

- **Starship 提示符**: `pkg install starship`，安装后自动接管提示符，使用仓库内 `starship/.config/starship.toml` 小屏优化配置；未安装时使用内置简版提示符
- **zoxide 智能跳转**: `pkg install zoxide`，安装后 `cd` 自动变为智能跳转
- **fzf 模糊查找**: `pkg install fzf`
- **Atuin 历史搜索**: `pkg install atuin`，安装后 Ctrl-R / ↑ 弹出模糊搜索（排在 fzf 之后接管）
- **现代 CLI 别名**: `pkg install eza bat dust fd`（ripgrep 已内置），装上后 `ls/cat/du/find/grep` 自动替换为现代工具，见 `conf.d/10-aliases.fish`
- **Helix 编辑器**: 已随 `packages.txt` 安装，配置启用触摸定位光标、失焦自动保存等移动端友好项
- **Git 规范**: 链接 `git` 包后全局启用 Conventional Commits 提交模板、常用别名与全局忽略（不含 user.name/email）
- **Bash 环境继承**: 安装脚本自动装好 Oh My Fish + [foreign-env](https://github.com/oh-my-fish/plugin-foreign-env)；登录 Fish 时通过 `fenv` 按 bash 优先级（`~/.bash_profile` → `~/.bash_login` → `~/.profile`）导入用户环境（见 `conf.d/zz-bash-env.fish`）
- **tmux 终端复用**: `tmux` 已随 `packages.txt` 安装，新标签页自动进入共享 `main` 会话；配置包 `tmux` 提供前缀 `Ctrl-b` 的键位（`?` 速查、`s` 选择器、`f` 模糊跳转、复制模式），详见 [tmux 配置](./tmux.md)
