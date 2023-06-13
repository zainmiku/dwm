#! /bin/bash
# ICONS 部分特殊的标记图标 这里是我自己用的，你用不上的话去掉就行

tempfile=$(cd $(dirname $0);cd ..;pwd)/temp

this=_icons
color="^c#2D1B46^^b#5555660x66^"
signal=$(echo "^s$this^" | sed 's/_//')

with_clash() {
    [ "$(ps x | grep -v grep | grep 'start-clash')" ] && icons=(${icons[@]} "")
}

with_bluetooth() {
    # 此处为自用蓝牙设备的 MAC 地址，你可以自定义该部分
    [ ! "$(command -v bluetoothctl)" ] && echo command not found: bluetoothctl && return
    [ "$(bluetoothctl info 88:C9:E8:14:2A:72 | grep 'Connected: yes')" ] && icons=(${icons[@]} "")
}

update() {
    icons=("")
    with_clash
    # with_bluetooth

    text=" ${icons[@]} "

    sed -i '/^export '$this'=.*$/d' $tempfile
    printf "export %s='%s%s%s'\n" $this "$signal" "$color" "$text" >> $tempfile
}

notify() {
    texts=""
    [ "$(ps aux | grep -v grep | grep 'clash')" ] && texts="$texts\n  clash 已启动"
    [ "$(bluetoothctl info 88:C9:E8:14:2A:72 | grep 'Connected: yes')" ] && texts="$texts\n WH-1000XM4 已链接"
    [ "$texts" != "" ] && notify-send " Info" "$texts" -r 9527
}

call_menu() {
    case $(echo -e '󰤄 睡眠\n 关机\n 重启\n 休眠' | rofi -dmenu -window-title power) in
        "󰤄 睡眠") systemctl suspend ;;
        " 关机") poweroff ;;
        " 重启") reboot ;;
        " 休眠") systemctl hibernate ;;
    esac
}

update_wallpaper_state() {
    _wallpaper=''
    source $tempfile                                                      # 从 temp 文件中读取模块的状态
    if [ "$_wallpaper" = 'r' ]; then
        sed -i '/^export _wallpaper=.*$/d' $tempfile
        printf "export _wallpaper=\"n\"\n" >> $tempfile
        notify-send " wallpaper" "\nN模式" -r 9527
    else
        sed -i '/^export _wallpaper=.*$/d' $tempfile
        printf "export _wallpaper=\"r\"\n" >> $tempfile
        notify-send " wallpaper" "\nR模式" -r 9527
    fi

}

update_wallpaper() {
    _wallpaper=''
    source $tempfile                                                      # 从 temp 文件中读取模块的状态
    if [ "$_wallpaper" = 'r' ]; then
        feh --randomize --bg-fill ~/Pictures/wallpaper/*
    else
        feh --randomize --bg-fill ~/Pictures/nwallpaper/*
    fi
}

click() {
    case "$1" in
        # L) notify; feh --randomize --bg-fill ~/Pictures/wallpaper/* ;;
        L) update_wallpaper ;;
        R) update_wallpaper_state ;;
        # R) feh --bg-fill ~/Pictures/wallpaper/2c3f9df25b784069da8cfa34a182eb43.jpg ;;
        # R) call_menu ;;
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
