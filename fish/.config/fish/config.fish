# Fish 主配置入口
# 实际配置按功能拆分在 conf.d/ 目录 (按文件名顺序加载):
#   00-init.fish    工具集成 (zoxide / starship / fzf)
#   05-env.fish     环境变量与 PATH
#   20-startup.fish 欢迎消息与提示符
#   99-abbr.fish    移动友好缩写
#   zz-bash-env.fish 继承 Bash 登录环境 (fenv，需在 omf.fish 之后加载)
# 注: omf.fish 由 Oh My Fish 安装器生成 (setup.sh 自动安装)，不入库。
# 自定义函数在 functions/ 目录。
