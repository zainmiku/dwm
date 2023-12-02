#! /bin/bash
# DWM自启动脚本 仅作参考 
# 搭配 https://github.com/yaocccc/scripts 仓库使用 目录位置 ~/scripts
# 部分配置文件在 ~/scripts/config 目录下

_thisdir=$(cd $(dirname $0);pwd)
tempfile=$(cd $(dirname $0);pwd)/temp

settings() {
    [ $1 ] && sleep $1
    xset -b                                   # 关闭蜂鸣器
    syndaemon -i 1 -t -K -R -d                # 设置使用键盘时触控板短暂失效
    #设置声音
    amixer sset master unmute
    amixer sset speaker unmute
    amixer sset headphone unmute
    # ~/scripts/set_screen.sh two               # 设置显示器
    feh --bg-fill ~/Pictures/nwallpaper/2406548372a5649a574aee08c5bdd862.jpg
    systemctl --user start mpd-mpris.service
    # $DWM/statusbar/statusbar.sh icons L
}

daemons() {
    [ $1 ] && sleep $1
    $_thisdir/statusbar/statusbar.sh cron &   # 开启状态栏定时更新
    xss-lock -- ~/scripts/blurlock.sh &       # 开启自动锁屏程序
    fcitx5 &                                  # 开启输入法
    # mpd &
    # lemonade server &                         # 开启lemonade 远程剪切板支持
    flameshot &                               # 截图要跑一个程序在后台 不然无法将截图保存到剪贴板
    dunst -conf ~/scripts/config/dunst.conf & # 开启通知server
    picom --config ~/scripts/config/picom.conf >> /dev/null 2>&1 & # 开启picom
    # 显卡切换
    /usr/bin/prime-offload &
    optimus-manager-qt &
    $HOME/.config/clash/start-clash.sh edu > /dev/null 2>&1 &
}

cron() {
    [ $1 ] && sleep $1
    let i=10
    while true; do
        # [ $((i % 10)) -eq 0 ] && ~/scripts/set_screen.sh check # 每10秒检查显示器状态 以此自动设置显示器
        # [ $((i % 600)) -eq 0 ] && $DWM/statusbar/packages/icons.sh click L # 每600秒更新壁纸
        sleep 10; let i+=10
    done
}

settings 1 &                                  # 初始化设置项
daemons 3 &                                   # 后台程序项
cron 10 &                                     # 定时任务项
