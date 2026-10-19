#!/data/data/com.termux/files/usr/bin/bash
# 自定义 Termux 登录提示 (MOTD)。
#
# Termux 的 login 会优先执行 ~/.termux/motd.sh，存在时不再显示
# $PREFIX/etc/motd 的默认欢迎语。这里改成与本仓库 (termux-configs) 相关的
# 基础设施信息：Tailscale、tmux、Emacs / Pi、内存、dotfiles 仓库状态。
#
# 性能：每次新会话登录都会执行。设备/工具版本/仓库路径等静态信息缓存到
# ~/.cache/termux-motd-cache（TTL 1 天，或 $TERMUX_VERSION 变化时重建），
# 热路径只用 bash 内建；只有 tailscale / tmux / git 是真实外部进程。
# 删除缓存可强制重建。

set -u

DIM=$'\e[2m'; BOLD=$'\e[1m'; CYAN=$'\e[36m'; GREEN=$'\e[32m'; NC=$'\e[0m'

kv() { # kv <key> <value>，value 为空则不打印
    [ -n "$2" ] && printf '  %s%-10s%s %s\n' "$DIM" "$1" "$NC" "$2"
}

# ---- 静态信息缓存 ----
cache="${XDG_CACHE_HOME:-$HOME/.cache}/termux-motd-cache"
want_version="${TERMUX_VERSION:-unknown}"

build_cache() {
    local android device agents repo ev pv pi_pkg
    android=$(getprop ro.build.version.release 2>/dev/null)
    device=$(getprop ro.product.marketname 2>/dev/null)
    agents=""
    if command -v emacs >/dev/null 2>&1; then
        ev=$(timeout 1 emacs --version 2>/dev/null | head -n1 | awk '{print $3}')
        [ -n "$ev" ] && agents="Emacs $ev"
    fi
    pi_pkg=$(ls "$HOME"/.pi/agent/install/releases/*/node_modules/@earendil-works/pi-coding-agent/package.json 2>/dev/null | head -n1)
    if [ -n "$pi_pkg" ] && [ -f "$pi_pkg" ]; then
        pv=$(grep -m1 '"version"' "$pi_pkg" 2>/dev/null | tr -dc '0-9.')
        agents="${agents:+$agents · }Pi $pv"
    fi
    repo=""
    [ -x "$HOME/.local/bin/dot" ] && repo=$("$HOME/.local/bin/dot" path 2>/dev/null)
    {
        printf 'version\t%s\n' "$want_version"
        printf 'built\t%s\n' "$(printf '%(%s)T' -1)"
        printf 'android\t%s\n' "$android"
        printf 'device\t%s\n' "$device"
        printf 'agents\t%s\n' "$agents"
        printf 'repo\t%s\n' "$repo"
    } > "$cache" 2>/dev/null
}

parse_cache() {
    android=""; device=""; agents=""; repo=""
    cached_version=""; built="0"
    while IFS=$'\t' read -r k v; do
        case "$k" in
            version) cached_version=$v ;;
            built)   built=$v ;;
            android) android=$v ;;
            device)  device=$v ;;
            agents)  agents=$v ;;
            repo)    repo=$v ;;
        esac
    done <<< "$1"
}

now=$(printf '%(%s)T' -1)
cache_data=""
[ -r "$cache" ] && cache_data=$(<"$cache")
parse_cache "$cache_data"
if [ "$cached_version" != "$want_version" ] || [ $((now - built)) -gt 86400 ]; then
    build_cache
    cache_data=""
    [ -r "$cache" ] && cache_data=$(<"$cache")
    parse_cache "$cache_data"
fi

# ---- 标题 ----
printf '\n  %sTermux%s %s' "$BOLD$CYAN" "$NC" "$want_version"
[ -n "$android" ] && printf ' %s· Android %s%s' "$DIM" "$android" "$NC"
[ -n "$device" ] && printf ' %s· %s%s' "$DIM" "$device" "$NC"
printf '\n\n'

# ---- Tailscale ----
if command -v tailscale >/dev/null 2>&1; then
    ts_ip=$(timeout 1 tailscale ip -4 2>/dev/null | head -n1)
    kv Tailscale "$ts_ip"
fi

# ---- tmux 标签页 (只列已附着的会话名；main×N 表示还有旧标签页直接挂在 main 上) ----
if command -v tmux >/dev/null 2>&1; then
    tmux_info=$(timeout 1 tmux list-clients -F '#{client_session}' 2>/dev/null \
        | awk '{ n[$0]++ } END { for (s in n) printf "%s%s", (c++ ? " " : ""), (n[s] > 1 ? s "×" n[s] : s) }')
    kv tmux "$tmux_info"
fi

# ---- Emacs / Pi (来自缓存) ----
kv Agents "$agents"

# ---- 内存占用 (bash 内建读 /proc/meminfo，不额外起进程) ----
mem_total=0; mem_avail=0
while read -r key val _; do
    case "$key" in
        MemTotal:)     mem_total=$val ;;
        MemAvailable:) mem_avail=$val ;;
    esac
done < /proc/meminfo
if [ "$mem_total" -gt 0 ]; then
    kv Memory "RAM $(( (mem_total - mem_avail) * 100 / mem_total ))%"
fi

# ---- dotfiles 仓库状态 ----
if [ -n "$repo" ] && [ -d "$repo/.git" ]; then
    git_out=$(timeout 1 git -C "$repo" status --porcelain --branch 2>/dev/null)
    branch=${git_out%%$'\n'*}
    branch=${branch#\#\# }
    branch=${branch%%...*}
    dirty=0
    while IFS= read -r line; do
        case "$line" in
            ''|'##'*) ;;
            *) dirty=$((dirty + 1)) ;;
        esac
    done <<< "$git_out"
    if [ -n "$branch" ]; then
        if [ "$dirty" -eq 0 ]; then
            kv Dotfiles "$branch (clean)"
        else
            kv Dotfiles "$branch ($dirty changed)"
        fi
    fi
fi

# ---- 时间 (bash printf，不额外起进程) ----
printf -v now_str '%(%Y-%m-%d %H:%M)T' -1
kv Time "$now_str"

printf '\n  %scheat%s 快捷命令   %sC-b ?%s tmux 键位\n\n' "$GREEN" "$NC" "$CYAN" "$NC"
