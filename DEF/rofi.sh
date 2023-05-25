# 打印菜单
call_menu() {
    echo ' update statusbar'
    echo ' open picture'
    [ "$(ps | grep clash)" ] && echo ' close clash' || echo ' open clash'
    [ "$(ps aux | grep picom | grep -v 'grep\|rofi\|nvim')" ] && echo ' close picom' || echo ' open picom'
}

# 执行菜单
execute_menu() {
    case $1 in
        ' update statusbar')
            coproc ($DWM/statusbar/statusbar.sh updateall > /dev/null 2>&1)
            ;;
        ' open picture')
            coproc (feh  -S mtime -Z -.  --cache-size 1024MiB ~/Pictures/Sankaku/)
            ;;
        ' open clash')
            coproc ($HOME/.config/clash/start-clash.sh > /dev/null 2>&1 && export HTTP_PROXY=127.0.0.1:7890 && export HTTPS_PROXY=127.0.0.1:7890 && export SOCKS_PROXY=127.0.0.1:7891 && $DWM/statusbar/statusbar.sh updateall > /dev/null)
            ;;
        ' close clash')
            coproc ($HOME/.config/clash/stop-clash.sh > /dev/null 2>&1 && unset HTTP_PROXY && unset HTTPS_PROXY && unset SOCKS_PROXY && $DWM/statusbar/statusbar.sh updateall > /dev/null)
            ;;
        ' open picom')
            coproc (picom  --config ~/scripts/config/picom.conf > /dev/null 2>&1)
            ;;
        ' close picom')
            killall picom
            ;;
    esac
}

execute_menu "$(call_menu | rofi -dmenu -p "")"
