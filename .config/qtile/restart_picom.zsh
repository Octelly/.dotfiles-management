#!/usr/bin/zsh
(killall picom || true) && sleep 0.1 && picom --experimental-backends --config /home/ocean/.config/awesome/picom/picom.conf & disown
