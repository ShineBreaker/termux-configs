# Fish 主配置入口
# 实际配置按功能拆分在 conf.d/ 目录 (按文件名顺序加载):
#   00-init.fish    工具集成 (zoxide / starship / fzf / atuin)
#   05-env.fish     环境变量与 PATH
#   10-aliases.fish 现代 CLI 别名 (eza / bat / dust / fd / rg)
#   15-tmux.fish    自动进入 tmux (main 分组共享 / tab 独立，TMUX_AUTO 控制，TMUX_TAB_NAME 指定名字)
#   20-startup.fish 欢迎消息与提示符
#   99-abbr.fish    移动友好缩写
#   zz-bash-env.fish 继承 Bash 登录环境 (fenv，需在 omf.fish 之后加载)
# 注: omf.fish 由 Oh My Fish 安装器生成 (setup.sh 自动安装)，不入库。
# 自定义函数在 functions/ 目录。
