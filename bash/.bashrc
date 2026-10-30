# ~/.bashrc — Termux 登录会话的 shell 兜底
#
# 背景：Termux 应用开启新会话时执行的是 `bash -l`。若没人接管，终端里出现的
# 就是 bash 而不是 fish。Termux 的 $PREFIX/etc/profile 会在「登录 shell」里
# source 本文件，因此在这里 exec fish 就能让交互式登录会话直接进入 fish。
#
# 切换条件（两者都要满足）：
#   1. 交互式（PS1 已设置）：非交互调用不能被劫持 —— 例如 fish 的 fenv 会
#      非交互地跑 bash 采集环境变量，若这里也 exec fish 就会互相套娃；
#   2. 登录 shell（shopt -q login_shell）：手动敲 `bash` 仍是 bash，保留
#      「用 bash 排查 fish 配置」这条逃生通道（见 docs/troubleshooting.md）。
#
# Termux 的 fish 已在 $PREFIX/bin 里，直接用 `fish` 即可（无需硬编码路径）。

if [ -n "${PS1:-}" ] && shopt -q login_shell 2>/dev/null; then
    if command -v fish >/dev/null 2>&1; then
        exec fish -l
    fi
fi
