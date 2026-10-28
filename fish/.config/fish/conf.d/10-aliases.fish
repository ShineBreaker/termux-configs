# 现代 CLI 别名 —— 数据驱动，勿在此文件里直接写 alias 定义。
#
# 真相源: data/alias.tsv (别名 / 展开 / 说明 / 条件)
# 这里用 alias 而非 abbr: 别名在管道、命令替换等场景同样生效。
# 仅在交互式 fish 会话中定义，不影响其他 shell 的脚本。
# 注意: ls 别名会接管 99-abbr.fish 中 l/ll/la/lt 展开后的 ls 调用。

set -l alias_data (status dirname)/../data/alias.tsv

if not status is-interactive
    return 0
end

if not test -r "$alias_data"
    echo "10-aliases.fish: 缺少别名数据文件 $alias_data" >&2
    return 1
end

for line in (command cat -- "$alias_data")
    # 跳过注释与空行
    string match -qr '^\s*(#|$)' -- "$line"; and continue

    set -l fields (string split \t -- "$line")
    if test (count $fields) -lt 4
        echo "10-aliases.fish: 跳过格式错误的行: $line" >&2
        continue
    end

    set -l condition (string trim -- "$fields[4]")
    if test -n "$condition"; and test "$condition" != '-'
        if string match -q '!*' -- "$condition"
            type -q (string sub -s 2 -- "$condition"); and continue
        else
            type -q "$condition"; or continue
        end
    end

    alias (string trim -- "$fields[1]") (string trim -- "$fields[2]")
end
