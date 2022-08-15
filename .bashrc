#Startx after tty login
#[[ $(wmctrl -m | awk 'NR==1 {print $2}') != "dwm" ]] && startx

[[ $- != *i* ]] && return

usage() { #Taken from TFL's github.
	du -h --max-depth=1 | sed -r '
		$d; s/^([.0-9]+[KMGTPEZY]\t)\.\//\1/
	' | sort -hr | column
}
cleanse(){ #Do not allow the glowing ones to know.
    history -c
    echo "" > "$HOME/.bash_history"
    echo "" > "$HOME/.python_history"
    echo "" > "$HOME/.config/BetterDiscord/plugins/MessageLoggerV2Data.json"
    rm -rf $HOME/.config/discord/Cache/*_0\
        $HOME/.config/discord/Cache/*_s\
        $HOME/.config/discord/.org.chromium.Chromium.*\
        $HOME/.cache/vim/backup/*\
        $HOME/.config/BetterDiscord/plugins/MLV2_IMAGE_CACHE/*
}
own(){ #External drive makes everything read only and owned by root, so we reown dat shit!
    [[ $2 == "\*" ]] && {
    sudo chmod $1 *
    sudo chown $USER *
    sudo chgrp $USER *
}||{
    sudo chmod $1 $2
    sudo chown $USER $2
    sudo chgrp $USER $2
}
}
trash(){ #Use when in doubt.
    dir="$HOME/.trash"
    [[ ! $1 ]] && echo "Trash command for trashing files." ||{
        [[ ! -d $dir ]] && mkdir $dir
        [[ $1 == "clean" ]] && rm -rf $dir/* || mv $1 $dir
    }
}
ffcord(){ #Opening OBS takes too much effort
     ffmpeg -video_size 1920x1080 -framerate 40 -f x11grab -i :0.0+0,0 -f pulse -ac 2 -i 2 "$HOME/Videos/screenRecordings/$(date +"%Y-%m-%d %H:%M:%S").mp4"
}
lsample(){ #EASY FUCKING SAMPLING BABY
     ffmpeg -f pulse -ac 2 -i 2 "$HOME/Music/ModTracker/Samples/misc/$1.wav"
}
rmex(){ #Obscure as fuck function for an obscure ass need.(It just replaces filename matches in bulk)
    for x in "$PWD"/*
    do
        mod=$(echo $x | sed -e "s/$1//g")
        cp "$x" "$mod" && rm "$x"# || echo "file ignored."
    done
}
emoji(){ # Thanks you Luke Smith.
    # The famous "get a menu of emojis to copy" script.

    # Get user selection via dmenu from emoji file.
    chosen=$(cut -d ';' -f1 ~/txt/emoji | dmenu -i -l 30 | sed "s/ .*//")

    # Exit if none chosen.
    [ -z "$chosen" ] && exit

    # If you run this command with an argument, it will automatically insert the
    # character. Otherwise, show a message that the emoji has been copied.
    if [ -n "$1" ]; then
        xdotol type "$chosen"
    else
        printf "$chosen" | xclip -selection clipboard
        notify-send "'$chosen' copied to clipboard."
    fi
}
colors() {
	local fgc bgc vals seq0

	printf "Color escapes are %s\n" '\e[${value};...;${value}m'
	printf "Values 30..37 are \e[33mforeground colors\e[m\n"
	printf "Values 40..47 are \e[43mbackground colors\e[m\n"
	printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

	# foreground colors
	for fgc in {30..37}; do
		# background colors
		for bgc in {40..47}; do
			fgc=${fgc#37} # white
			bgc=${bgc#40} # black

			vals="${fgc:+$fgc;}${bgc}" 
			vals=${vals%%;}

			seq0="${vals:+\e[${vals}m}"
			printf "  %-9s" "${seq0:-(default)}"
			printf " ${seq0}TEXT\e[m"
			printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
		done
		echo; echo
	done
}

[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

unset use_color safe_term match_lhs sh


xhost +local:root > /dev/null 2>&1

complete -cf sudo
shopt -s checkwinsize interactive_comments expand_aliases histappend
set -o vi

export PATH=/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:$HOME/.local/bin
export XDG_RUNTIME_DIR=/tmp/runtime-nobie
#Global colors

export Black="\033[1;30m"
export Red="\033[1;31m"
export Green="\033[1;32m"
export Yellow="\033[1;33m"
export Blue="\033[1;34m"
export Purple="\033[1;35m"
export Cyan="\033[1;36m"
export White="\033[1;37m"
export NC="\033[0m"
export blue="\033[0;34m"
export white="\033[0;37m"
export red="\033[0;31m"
export yellow="\033[0;33m"

#Custom aliases

alias rctard="clear && . ~/.bashrc"
alias rm="rm -i"
alias cls="clear"
alias ls="ls -a --color"
alias lsl="ls -ahl --color"
alias strlen="expr length $1"
alias xr="sudo xbps-remove"
alias xu="sudo xbps-install -Syu"
alias xq="xbps-query -Rs"
alias cp="cp -i"
alias df="df -h"
alias free="free -h"
alias scrot="scrot ~/Pictures/Scrot/Screenshot.jpeg"
alias wttr="curl wttr.in/"
alias ms-dlp="yt-dlp -x --audio-quality 10"
alias ident="identify -verbose"
alias grabc="grabc -rgb"
alias hexedit="hexedit --color"
alias todo="cat ~/.todo"
alias hear="mpv $1 --no-video"
alias nn="firejail --net=none"
alias a="cat $HOME/txt/Anime"
alias ae="vim $HOME/txt/Anime"
alias m="cat $HOME/txt/Manga"
alias me="vim $HOME/txt/Manga"
alias d="cat $HOME/txt/DreamJournal.txt"
alias de="vim $HOME/txt/DreamJournal.txt"

alias vi="vim" # for some reason vi mode opened the edit in literally vi instead of how it used to do and open vim, lol.

#Custom PS1
export PS1="\[${Green}\]\u\e${Cyan}[\w]\e[m\]: \]"
export LESS="--RAW-CONTROL-CHARS"
[[ -f ~/.LESS_TERMCAP ]] && . ~/.LESS_TERMCAP

#neofetch; cat ~/.todo | lolcat
#festival --tts ~/txt/welcome_message
