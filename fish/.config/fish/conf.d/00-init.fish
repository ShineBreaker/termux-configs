# 工具集成 (已安装则自动启用)
if status is-interactive
    type -q zoxide; and zoxide init fish | source
    type -q starship; and starship init fish | source
    type -q fzf_key_bindings; and fzf_key_bindings
    # atuin 放在 fzf 之后: 已安装时由 atuin 接管 Ctrl-R / ↑ 的历史搜索
    type -q atuin; and atuin init fish | source
end
