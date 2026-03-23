# Doom Emacs Termux 移动端优化配置

本配置针对 Termux (Android 终端模拟器) 上的 Doom Emacs 进行了移动端优化，包括触屏支持、软键盘适配、国内镜像源配置等。

---

## 主要优化内容

### 1. 国内镜像源配置

#### ELPA/MELPA 镜像 (清华大学 TUNA)

- `gnu`: https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/
- `nongnu`: https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/
- `melpa`: https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/
- `org`: https://mirrors.tuna.tsinghua.edu.cn/elpa/org/

#### GitHub 镜像 (用于 Straight 包管理器)

- 使用 KGit 镜像: `https://kgithub.com/`
- 备选镜像:
  - FastGit: `https://hub.fastgit.xyz/`
  - GHProxy: `https://ghproxy.com/`

### 2. 触屏与输入优化

#### 鼠标/触摸支持

- 启用 `xterm-mouse-mode` 在终端中支持鼠标/触摸操作
- 支持点击定位光标、复制粘贴等操作

#### 软键盘优化

- 使用 `jk` 或 `jj` 快速退出插入模式 (无需按 Esc)
- 支持 `C-[` 作为 Esc 的替代
- 禁用 `C-i` 跳转歧义，避免软键盘问题

#### 快捷键优化

- 单键快捷键: `SPC w` (保存), `SPC q` (退出), `SPC f` (查找文件)
- 方向键导航支持
- 窗口导航: `SPC h/j/k/l`

### 3. 界面优化

#### 字体与显示

- 字体大小设置为 16pt (适合手机屏幕)
- 禁用行号显示 (节省屏幕空间)
- 启用当前行高亮

#### 主题

- 使用 `doom-one` 主题
- 禁用斜体 (在终端中显示更好)

### 4. 性能优化

#### 启动优化

- GC 阈值调整: 启动时 100MB，启动后 16MB
- 禁用双向文本扫描 (`bidi-inhibit-bpa`)
- 禁用光标闪烁 (节省电量)

#### 文件操作

- 禁用自动保存和备份文件 (减少磁盘 I/O)
- 禁用锁文件

### 5. 终端集成

#### 剪贴板集成

- 使用 `clipetty` 包实现与 Termux 剪贴板的集成
- 支持从 Emacs 复制到系统剪贴板

#### TTY 模块

- 启用 Doom 的 `tty` 模块优化终端体验
- 包含 `evil-terminal-cursor-changer` 等插件

---

## 文件结构

```
~/.config/doom/
├── init.el          # Doom 模块配置 (启用 tty 模块)
├── config.el        # 主配置文件 (移动端优化)
├── packages.el      # 额外包配置 (clipetty)
├── early-init.el    # 国内镜像源配置 (早期加载)
└── README-Mobile-Config.md  # 本说明文档
```

---

## 使用方法

### 首次安装

1. 确保已安装 Termux 和 Emacs:
   ```bash
   pkg install emacs git
   ```

2. 克隆 Doom Emacs:
   ```bash
   git clone https://github.com/doomemacs/doomemacs ~/.config/emacs
   ```

3. 运行安装脚本:
   ```bash
   ~/.config/emacs/bin/doom install
   ```

4. 同步配置:
   ```bash
   doom sync
   ```

### 日常更新

```bash
# 同步配置 (安装新包)
doom sync

# 升级所有包
doom upgrade
```

### 启动 Emacs

```bash
emacs
```

---

## 关键快捷键 (手机友好)

### 基础操作

| 快捷键 | 功能 |
|--------|------|
| `jk` / `jj` | 退出插入模式 (替代 Esc) |
| `C-[` | 退出插入模式 (替代 Esc) |
| `SPC f` | 查找文件 |
| `SPC w` | 保存文件 |
| `SPC q` | 关闭当前缓冲区 |
| `SPC r` | 最近文件 |

### 导航

| 快捷键 | 功能 |
|--------|------|
| `SPC h/j/k/l` | 切换窗口 (左/下/上/右) |
| `SPC d` | 打开文件浏览器 |
| `SPC j` | 跳转到当前文件目录 |

### 触摸操作

- 单击: 移动光标
- 双击: 选中单词
- 长按: 复制/粘贴菜单 (取决于终端)

---

## 故障排除

### 网络问题

如果遇到 GitHub 访问问题，可以修改 `early-init.el` 中的镜像源:

```elisp
;; 可选镜像:
(setq straight-vc-git-default-clone-url #'+straight-mirror-github-to-ghproxy)  ; GHProxy
(setq straight-vc-git-default-clone-url #'+straight-mirror-github-to-fastgit)  ; FastGit
(setq straight-vc-git-default-clone-url #'+straight-mirror-github-to-kgit)      ; KGit (默认)
```

### Git 配置

全局 Git 镜像配置:
```bash
git config --global url."https://kgithub.com/".insteadOf "https://github.com/"
```

### 性能问题

如果启动缓慢:
1. 检查网络连接 (需要下载包)
2. 运行 `doom doctor` 诊断问题
3. 考虑禁用不常用的模块

---

## 注意事项

1. **触屏支持**: Emacs 29+ 内置了触屏支持，但在 Termux 终端中主要通过鼠标模式实现
2. **软键盘**: 建议使用 Hacker's Keyboard 或类似支持功能键的键盘
3. **电量**: 禁用光标闪烁和自动保存可节省电量
4. **存储**: 禁用备份文件可减少存储占用

---

## 参考链接

- [Doom Emacs 官方文档](https://docs.doomemacs.org/)
- [Termux 官方仓库](https://github.com/termux/termux-app)
- [清华大学 TUNA 镜像](https://mirrors.tuna.tsinghua.edu.cn/)
- [KGit 镜像](https://kgithub.com/)
