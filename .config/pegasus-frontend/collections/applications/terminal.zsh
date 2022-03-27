#!/bin/zsh

# Terminal list taken from Qtile's
# libqtile.utils.guess_terminal function
kitty ||
	roxterm ||
  sakura ||
  hyper ||
  alacritty ||
  terminator ||
  termite ||
  gnome-terminal ||
  konsole ||
  xfce4-terminal ||
  lxterminal ||
  mate-terminal ||
  #kitty ||
  yakuake ||
  tilda ||
  guake ||
  eterm ||
  st ||
  urxvt ||
  xterm ||
  x-terminal-emulator
