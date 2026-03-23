# Fastfetch 系统信息

Fastfetch 是一个快速、高度可定制的系统信息工具，类似于 Neofetch 但速度更快。

---

## 📊 显示模式

Fastfetch 已配置为在启动时自动显示系统信息，并根据屏幕宽度自动调整显示模式。

| 模式 | 触发条件 | 说明 |
|------|----------|------|
| 标准模式 | 屏幕宽度 ≥ 45 字符 | 显示小 logo + 完整系统信息 |
| 紧凑模式 | 屏幕宽度 < 45 字符 | 无 logo + 核心信息 |

---

## 🎮 可用命令

| 命令 | 说明 |
|------|------|
| `ff` | 自动适配屏幕显示系统信息 |
| `ffmini` | 极简模式（手动触发紧凑显示） |
| `fffull` | 完整模式 |
| `ffcfg` | 编辑标准配置 |
| `ffcfgmini` | 编辑极简配置 |

---

## ⚙️ 配置文件

### 标准配置

**路径**: `~/Documents/dotfiles/fastfetch/.config/fastfetch/config.jsonc`

适用于屏幕宽度 ≥ 45 字符，显示小 logo 和完整系统信息。

### 紧凑配置

**路径**: `~/Documents/dotfiles/fastfetch/.config/fastfetch/config-compact.jsonc`

适用于小屏幕，无 logo，只显示核心信息（OS, Device, CPU, RAM, Battery）。

---

## 🔧 自定义配置

### 修改显示内容

编辑 `~/Documents/dotfiles/fastfetch/.config/fastfetch/config.jsonc`，在 `modules` 数组中添加或删除模块：

```json
{
  "type": "localip",
  "key": "IP"
}
```

### 重新链接配置

```bash
cd ~/Documents/dotfiles
stow -R -t ~ fastfetch
```

### 测试配置

```bash
fastfetch --config ~/.config/fastfetch/config.jsonc
```

---

## 📋 可用模块

使用以下命令查看所有可用模块：

```bash
fastfetch --list-modules
```

常用模块：
- `title` - 标题
- `separator` - 分隔线
- `os` - 操作系统
- `host` - 设备信息
- `kernel` - 内核版本
- `uptime` - 运行时间
- `packages` - 包数量
- `shell` - Shell 信息
- `display` - 显示信息
- `de` - 桌面环境
- `wm` - 窗口管理器
- `cpu` - CPU 信息
- `gpu` - GPU 信息
- `memory` - 内存信息
- `disk` - 磁盘信息
- `battery` - 电池信息
- `localip` - 本地 IP
- `break` - 空行
- `colors` - 颜色测试

---

## 🐛 故障排除

### 显示异常

```bash
# 检查配置文件 JSON 语法
fastfetch --config ~/Documents/dotfiles/fastfetch/.config/fastfetch/config.jsonc

# 查看详细错误
fastfetch --config ~/Documents/dotfiles/fastfetch/.config/fastfetch/config.jsonc --debug
```

### 临时禁用

编辑 `~/Documents/dotfiles/fish/.config/fish/config.fish`，注释掉 `fish_greeting` 中的 fastfetch 调用。
