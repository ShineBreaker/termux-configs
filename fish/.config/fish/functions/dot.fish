function dot
    set -l DOTFILES_DIR "$HOME/Documents/dotfiles"

    if test (count $argv) -eq 0
        _dot_usage
        return 0
    end

    set -l cmd $argv[1]
    set -e argv[1]

    switch $cmd
        case "cd"
            cd $DOTFILES_DIR
            echo (set_color cyan)"已进入 dotfiles 目录: $DOTFILES_DIR"
        case "stow"
            if test (count $argv) -eq 0
                echo (set_color red)"错误: 请指定包名"
                echo "用法: dot stow <包名>"
                return 1
            end
            cd $DOTFILES_DIR
            stow -v -t ~ $argv
        case "unstow"
            if test (count $argv) -eq 0
                echo (set_color red)"错误: 请指定包名"
                echo "用法: dot unstow <包名>"
                return 1
            end
            cd $DOTFILES_DIR
            stow -D -v -t ~ $argv
        case "restow"
            if test (count $argv) -eq 0
                echo (set_color red)"错误: 请指定包名"
                echo "用法: dot restow <包名>"
                return 1
            end
            cd $DOTFILES_DIR
            stow -R -v -t ~ $argv
        case "list"
            _dot_list_packages
        case "status"
            _dot_status
        case "add"
            if test (count $argv) -eq 0
                echo (set_color red)"错误: 请指定包名"
                echo "用法: dot add <包名>"
                return 1
            end
            _dot_add_package $argv[1]
        case "*"
            echo (set_color red)"未知命令: $cmd"
            _dot_usage
            return 1
    end
end

function _dot_usage
    echo (set_color cyan)"╔════════════════════════════════════════╗"
    echo (set_color cyan)"║     📦 Dotfiles 管理命令              ║"
    echo (set_color cyan)"╚════════════════════════════════════════╝"
    echo
    echo (set_color yellow)"用法:"
    echo (set_color normal)"  dot <命令> [参数]"
    echo
    echo (set_color yellow)"命令:"
    echo (set_color normal)"  cd              进入 dotfiles 目录"
    echo "  stow <包名>     创建符号链接"
    echo "  unstow <包名>   移除符号链接"
    echo "  restow <包名>   重新创建符号链接"
    echo "  list            列出所有包"
    echo "  status          检查链接状态"
    echo "  add <包名>      添加新包 (交互式)"
    echo
    echo (set_color yellow)"示例:"
    echo (set_color normal)"  dot cd"
    echo "  dot stow fish"
    echo "  dot restow termux"
    echo "  dot list"
end

function _dot_list_packages
    set -l DOTFILES_DIR "$HOME/Documents/dotfiles"
    echo (set_color cyan)"可用包:"
    echo

    for dir in $DOTFILES_DIR/*/
        set -l pkg (basename $dir)
        test -d $dir; or continue
        string match -q ".*" $pkg; and continue

        set -l linked "○"
        set -l color (set_color normal)

        # 检查是否已链接
        set -l is_linked false
        if test -L "$HOME/.config/$pkg"
            set is_linked true
        else if test -L "$HOME/.$pkg"
            set is_linked true
        else if test -L "$HOME/."$pkg"rc"
            set is_linked true
        else if test "$pkg" = "fish"
            if test -L "$HOME/.config/fish/config.fish"
                set is_linked true
            end
        else if test "$pkg" = "bash"
            if test -L "$HOME/.bashrc"
                set is_linked true
            end
        end

        if test "$is_linked" = true
            set linked "✓"
            set color (set_color green)
        end

        echo $color"  $linked $pkg"
    end
    echo (set_color normal)
end

function _dot_status
    set -l DOTFILES_DIR "$HOME/Documents/dotfiles"
    echo (set_color cyan)"链接状态:"
    echo

    for dir in $DOTFILES_DIR/*/
        set -l pkg (basename $dir)
        test -d $dir; or continue
        string match -q ".*" $pkg; and continue

        echo (set_color yellow)"[$pkg]"

        # 检查包是否已链接
        set -l dir_linked false
        if test -L "$HOME/.config/$pkg"
            set dir_linked true
        else if test -L "$HOME/.$pkg"
            set dir_linked true
        else if test -L "$HOME/."$pkg"rc"
            set dir_linked true
        end

        # fish 特殊处理
        if test "$pkg" = "fish"
            if test -L "$HOME/.config/fish/config.fish"
                set dir_linked true
            end
        end

        if test "$dir_linked" = true
            echo (set_color green)"  ✓ 目录已链接"
        else
            # 查找包内所有文件
            find $dir -type f | while read -l file
                set -l rel_path (string replace "$DOTFILES_DIR/$pkg/" "" $file)
                set -l target_path "$HOME/$rel_path"

                if test -L $target_path
                    echo (set_color green)"  ✓ $rel_path"
                else if test -e $target_path
                    echo (set_color red)"  ! $rel_path (存在但非链接)"
                else
                    echo (set_color normal)"  ✗ $rel_path (未链接)"
                end
            end
        end
        echo
    end
    echo (set_color normal)
end

function _dot_add_package
    set -l pkg $argv[1]
    set -l DOTFILES_DIR "$HOME/Documents/dotfiles"
    set -l pkg_dir "$DOTFILES_DIR/$pkg"

    if test -d $pkg_dir
        echo (set_color red)"错误: 包 '$pkg' 已存在"
        return 1
    end

    echo (set_color cyan)"创建新包: $pkg"
    echo (set_color normal)"请输入配置路径 (相对于 ~，例如: .config/$pkg):"
    read -l path

    if test -z "$path"
        echo (set_color red)"错误: 路径不能为空"
        return 1
    end

    set -l clean_path (string trim --left --chars="/" $path)
    set -l full_path "$pkg_dir/$clean_path"
    mkdir -p $full_path

    echo (set_color green)"包目录已创建: $full_path"
    echo (set_color normal)"请将配置文件移动到此目录，然后运行:"
    echo "  dot stow $pkg"
end
