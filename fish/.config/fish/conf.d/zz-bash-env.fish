# 继承 Bash 登录环境: 用 fenv 读取 ~/.profile 中导出的变量。
# fenv 由 Oh My Fish 的 foreign-env 插件提供; 文件名以 zz- 开头，
# 保证按字母序排在 omf.fish 之后加载，此时 fenv 才已可用。
# 只在登录会话执行，嵌套 Fish 会自然继承父进程环境，无需重复导入。
if status is-login; and type -q fenv; and test -f ~/.profile
    fenv source ~/.profile
end
