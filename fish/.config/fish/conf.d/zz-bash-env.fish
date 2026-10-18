# 继承 Bash 登录环境: 用 fenv (Oh My Fish 的 foreign-env 插件) 读取用户登录 profile。
# 系统级环境已由 Termux 自身提供 (login 脚本导出 PREFIX/TMPDIR/LD_PRELOAD,
# $PREFIX/etc/fish/conf.d/start-services.fish 提供 SVDIR/LOGDIR)，此处无需重复。
# 用户 profile 与 bash 登录优先级一致: ~/.bash_profile > ~/.bash_login > ~/.profile。
# 文件名以 zz- 开头，保证按字母序排在 omf.fish 之后加载，此时 fenv 才已可用。
# 只在登录会话执行，嵌套 Fish 会自然继承父进程环境，无需重复导入。
if status is-login; and type -q fenv
    for profile in ~/.bash_profile ~/.bash_login ~/.profile
        if test -f $profile
            fenv source $profile
            break
        end
    end
end
