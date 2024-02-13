
#! /bin/bash
# light 亮度脚本
# 本脚本需要你自行修改音量获取命令

tempfile=$(cd $(dirname $0);cd ..;pwd)/temp

this=_light
icon_color="^c#3B001B^^b#6873790x88^"
text_color="^c#3B001B^^b#6873790x99^"
signal=$(echo "^s$this^" | sed 's/_//')

# check
[ ! "$(command -v light)" ] && echo command not found: light && exit

update() {
    current_brightness=$(light)
    # 将亮度值截断为整数
    current_brightness=${current_brightness%.*}
    case $current_brightness in
        0)
            light_icno="󰃞"
            light_text="00"
            ;;
        [1-9])
            light_icno="󰃞"
            light_text="0$current_brightness"
            ;;
        [1-4][0-9])
            light_icno="󰃝"
            light_text="$current_brightness"
            ;;
        [5-7][0-9])
            light_icno="󰃟"
            light_text="$current_brightness"
            ;;
        *)
            light_icno="󰃠"
            light_text="$current_brightness"
            ;;
    esac

    icon=" $light_icno "
    text=" $light_text% "

    sed -i '/^export '$this'=.*$/d' $tempfile
    printf "export %s='%s%s%s%s%s'\n" $this "$signal" "$icon_color" "$icon" "$text_color" "$text" >> $tempfile
}


notify() {
    update
    notify-send -r 9527 -h int:value:$light_text -h string:hlcolor:#dddddd "$light_icno Light"
}

click() {
    case "$1" in
        L) notify              ;; # 仅通知
        M) notify              ;; # 仅通知
        R) notify              ;; # 仅通知
        U) light -A 5%; notify ;; # 亮度加
        D) light -U 5%; notify ;; # 亮度减
    esac
}

case "$1" in
    click) click $2 ;;
    notify) notify ;;
    *) update ;;
esac
