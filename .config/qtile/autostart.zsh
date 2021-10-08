#!/usr/bin/zsh

wired -r & disown
/usr/lib/policykit-1-pantheon/io.elementary.desktop.agent-polkit & disown

blueberry-tray
pasystray & disown
nm-applet & disown
clight-gui --tray & disown

picom --experimental-backends --config /home/ocean/.config/awesome/picom/picom.conf & disown
nitrogen --set-zoom-fill ~/Wallpapers/16-9/wallhaven-z8o1og.jpg
