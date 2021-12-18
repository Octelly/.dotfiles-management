## ZSH options
setopt correct # suggest corrections

#devkitPro (3DS homebrew dev stuff)
export DEVKITPRO=/opt/devkitpro
export DEVKITARM=${DEVKITPRO}/devkitARM
export DEVKITPPC=${DEVKITPRO}/devkitPPC

export PATH=${DEVKITPRO}/tools/bin:$PATH


export PATH=$HOME/.emacs.d/bin:$PATH


# COMMAND-LINE UTILS
# - cht.sh
# - bat
# - lsd
# - ranger
# - yt-dlp
# - ffmpeg
# - ncdu
# - btop
# - fzf
# - z (zoxide)


export CHEAT_USE_FZF=true


CASE_SENSITIVE="false"
HYPHEN_INSENSITIVE="false"
DISABLE_AUTO_UPDATE="false"
DISABLE_UPDATE_PROMPT="true"



export EDITOR=/usr/bin/nvim
export editor=/usr/bin/nvim

## Custom functions and aliases

alias dw="ytdl-safe -f \"bestaudio/best\" -x --audio-format \"flac\""
alias dww="ytdl-safe --sleep-interval 60 -f \"bestaudio/best\" -x --audio-format \"flac\""

alias -- '+x'='chmod +x'

alias p3=python3
alias ip3=ipython3
alias bp3=bpython
alias ytdl-safe="yt-dlp --compat-options youtube-dl"
alias ytdl='ytdl-safe --add-metadata -i'
alias ytv='ytdl -f "bestvideo[fps>=60]+bestaudio/bestvideo+bestaudio"'
alias yta='ytdl -f "bestaudio"'
alias ffmpeg='ffmpeg -hide_banner'
alias sha256='shasum -a 256'

alias wine32='WINEPREFIX=~/.wine32 WINEARCH=win32 wine'
alias wineboot32='WINEPREFIX=~/.wine32 WINEARCH=win32 wineboot'
alias winetricks32='WINEPREFIX=~/.wine32 WINEARCH=win32 winetricks'
alias winejp='WINEPREFIX=~/.wineJP LC_ALL="ja_JP" LANG=ja-JP.utf8 wine'
alias winetricksjp='WINEPREFIX=~/.wineJP LC_ALL="ja_JP" LANG=ja_JP.UTF-8 winetricks'

alias timestamp='date +%s'

alias ssh='kitty kitten ssh'

alias :q=exit
alias :wq="echo haha yes, imma write that to the disk for sure :\)"
alias owu="echo jn jn"

alias please='sudo'
alias clr='clear'
alias cls='clear'
alias cl='clear'

alias cht='cht.sh'
alias cheat='cht.sh'

alias myip='curl ipinfo.io/ip'

alias mkcd='take'
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias f=ranger
alias ff='nautilus . & disown'
alias disk='df -h'

alias conf='$EDITOR $HOME/.zshrc'
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles-management/ --work-tree=$HOME'

# file assoc

alias -s spc=mpv

function zff () {
	nautilus $(z -e $*) &
	disown
	exit  # works on gnome-terminal, doesn't work on kitty
}

function lnmv () {
	mv $1 $2
	ln -s $2 $1
}

function calc () {
    printf "%s\n" "$*" | tr x \* | bc
}

function open () {
  nohup xdg-open "$*" > /dev/null 2>&1
}

function twitter () {
    open "https://twitter.com/$*"
}

function timer () {
   date1=$((`date +%s` + $1)); 
   while [ "$date1" -ge `date +%s` ]; do 
     echo -ne "$(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r";
     sleep 0.1
   done
}
function stopwatch () {
  date1=`date +%s`; 
   while true; do 
    echo -ne "$(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r"; 
    sleep 0.1
   done
}

function _auto_install () {
    echo "Installing $*..."

    ( echo "Attempting pip3 installation..." && python3 -m pip install -U "$*" ) ||
    ( echo "Attempting apt installation..." && sudo apt install "$*" ) ||
    echo "Couldn't install $*"
}

function _install_if_unavailable () {
    which "$*" > /dev/null || _auto_install "$*"
}

function people_db () {
	if [[ $* =~ '-' ]] then
		echo 'setting up aliases not yet supported'
	elif [[ ! -z $* ]] then
		$EDITOR "$HOME/.people_db/$*.md"
	else
		ls "$HOME/.people_db" | grep ".md" | sed -e 's/\.md$//'
	fi
}
alias pd='people_db'

## Requirements

#_install_if_unavailable beep  # might require "sudo modprobe snd-pcsp" in order to work
#_install_if_unavailable toilet
#_install_if_unavailable lolcat
#_install_if_unavailable nms
#_install_if_unavailable htop
#_install_if_unavailable vim
#_install_if_unavailable git
#_install_if_unavailable ranger


## ls colours

# Yes, these are a pain to customize. Fortunately, Geoff Greer made an online
# tool that makes it easy to customize your color scheme and keep them in sync
# across Linux and OS X/*BSD at http://geoff.greer.fm/lscolors/

export LSCOLORS='Exfxcxdxbxegedabagacad'
export LS_COLORS='di=1;34;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:'


## Zgen config

# load zgen
source "${HOME}/.zgen/zgen.zsh"

# if the init scipt doesn't exist
if ! zgen saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh

    # omz plugins
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/colored-man-pages
    zgen oh-my-zsh plugins/python
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/command-not-found
    # zgen oh-my-zsh plugins/z  # replacing with zoxide
    zgen oh-my-zsh plugins/web-search

    # plugins
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load unixorn/autoupdate-zgen
    zgen load chrissicool/zsh-256color
    zgen load supercrabtree/k
    
    # completions
    zgen load zsh-users/zsh-completions src
    zgen load zsh-users/zsh-autosuggestions
    zgen load cheat/cheat scripts/cheat.zsh
    #zgen load marlonrichert/zsh-autocomplete . main  # LAGGY!

    # theme
    #zgen load romkatv/powerlevel10k powerlevel10k
    zgen load ~/my.zsh-theme

    # save all to init script
    zgen save
fi


## Powerlevel10K config

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#task limit:3 next  # I hate seeing all the past due tasks,
                    # so I'm commenting this out

# Created by `pipx` on 2021-04-19 19:36:28
export PATH="$PATH:/home/ocean/.local/bin"
compaudit && compinit

eval "$(zoxide init zsh)"
