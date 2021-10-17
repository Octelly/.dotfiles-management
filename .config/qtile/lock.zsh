#!/usr/bin/zsh

if [[ "$(setxkbmap -query | grep layout)" == "layout:     us" ]]
then
	i3lock -k -i ~/Wallpapers/16-9/wallhaven-z8o1og-FHD.jpg -F\
		--ring-color=2d2a2e
		--ring-ver-color=e5c463
		--ring-wrong-color=f85e84
else
	notify-send -u CRITICAL "Lock failed" "Please switch to US layout first"
fi
