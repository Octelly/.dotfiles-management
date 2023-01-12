#!/usr/bin/zsh

Xephyr -br -ac -noreset -screen 1600x900 :2 &
xeph_pid="$!"

sleep 0.01

DISPLAY=:2 awesome -c rc.lua
kill $xeph_pid
