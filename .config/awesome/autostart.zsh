#!/usr/bin/env bash

function run {
  if ! pgrep -f "$1" ;
  then
    $@&
  fi
}

#wired -r & disown
#run "/usr/bin/dunst"
run "/usr/lib/policykit-1-pantheon/io.elementary.desktop.agent-polkit"

run "blueberry-tray"
run "pasystray"
run "nm-applet"
run "clight-gui --tray"
run "caffeine start"

#run "light-locker --no-late-locking --no-lock-on-suspend --no-lock-on-lid --no-idle-hint"

run "picom --experimental-backends --config $HOME/.config/awesome/picom/picom.conf"
run "unclutter --timeout 5 --hide-on-touch"

#nitrogen --set-zoom-fill ~/Wallpapers/16-9/wallhaven-rdz76w-cropped.png
