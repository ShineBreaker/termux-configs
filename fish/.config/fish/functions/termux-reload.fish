function termux-reload
    if type -q termux-reload-settings
        termux-reload-settings
        echo "Termux 设置已重载"
    else
        echo "termux-reload-settings 未找到，请在 Termux 中使用"
        return 1
    end
end
