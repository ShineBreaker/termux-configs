# Fish 缩写 —— 数据驱动，勿在此文件里直接写 abbr 定义。
#
# 真相源: data/abbr.tsv (分类 / 缩写 / 展开 / 说明 / 条件)
# 本文件只负责把表格变成 abbr，因此新增缩写只需改表格一处：
#   $EDITOR (status dirname)/../data/abbr.tsv
#   dot restow fish        # 运行时生效
#   just docs              # 文档表格同步
#
# 条件列实现渐进增强:
#   命令名   已安装才定义 (如 zoxide 缺失时 cd 保持原义)
#   !命令名  未安装才定义 (与上一行成对，如 lt 在 eza/ls 间切换)

set -l abbr_data (status dirname)/../data/abbr.tsv

if not test -r "$abbr_data"
    echo "99-abbr.fish: 缺少缩写数据文件 $abbr_data" >&2
    return 1
end

for line in (command cat -- "$abbr_data")
    # 跳过注释与空行
    string match -qr '^\s*(#|$)' -- "$line"; and continue

    set -l fields (string split \t -- "$line")
    if test (count $fields) -lt 5
        echo "99-abbr.fish: 跳过格式错误的行: $line" >&2
        continue
    end

    set -l condition (string trim -- "$fields[5]")
    if test -n "$condition"; and test "$condition" != '-'
        if string match -q '!*' -- "$condition"
            type -q (string sub -s 2 -- "$condition"); and continue
        else
            type -q "$condition"; or continue
        end
    end

    abbr -a --description=(string trim -- "$fields[4]") -- "$fields[2]" "$fields[3]"
end
