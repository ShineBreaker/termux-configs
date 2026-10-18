# run — 按当前目录构建文件派发 (与桌面同名习惯对齐)
function run -d "按当前目录构建文件派发: justfile→just"
    if test -f justfile; or test -f Justfile
        just $argv
    else
        echo "run: 当前目录下未找到 justfile" >&2
        return 1
    end
end
