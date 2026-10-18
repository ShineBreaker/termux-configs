# retry — 命令失败时自动重试 (应对移动端网络抖动)
function retry -d "命令失败时自动重试"
    if test (count $argv) -eq 0
        echo "用法: retry <命令> [参数...]" >&2
        return 1
    end

    set -l max_retries 5
    set -l attempt 0

    while true
        $argv
        if test $status -eq 0
            return 0
        end

        set attempt (math $attempt + 1)

        if test $attempt -ge $max_retries
            echo "已连续失败 $max_retries 次，是否继续重试？(y/n)" >&2
            read -l response
            if test "$response" != y
                return 1
            end
            set attempt 0
        else
            echo "命令失败，正在重试 (第 $attempt 次)..." >&2
        end
    end
end
