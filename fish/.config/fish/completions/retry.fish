# retry 补全: 把参数当作子命令补全
complete -c retry -a "(__fish_complete_subcommand)" -d "被重试的命令"
