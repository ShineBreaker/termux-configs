# run 补全: 把参数转发给当前目录的 just
function __run_complete
    set -l tokens (commandline -opc 2>/dev/null)
    set -l args $tokens[2..-1]
    if test -f justfile; or test -f Justfile
        complete -C "just $args"
    end
end

complete -c run -f -a "(__run_complete)"
