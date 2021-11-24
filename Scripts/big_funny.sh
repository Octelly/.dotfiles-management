#!/usr/bin/zsh

mpv --no-config --volume=50 --no-video --loop=inf $(dirname $(realpath $0))/lore.webm &>/dev/null & disown
pid="$!"
kitty
kill $pid
