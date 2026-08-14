# 工具集成 (已安装则自动启用)
if status is-interactive
    type -q zoxide; and zoxide init fish | source
    type -q starship; and starship init fish | source
end
