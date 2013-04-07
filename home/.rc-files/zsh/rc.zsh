#!/bin/zsh
rcfiles=$(dirname $(dirname $_))

system=`$rcfiles/system`

if [ -f ~/.localenv ]; then
	. ~/.localenv
fi

omz_dir=$HOME/.homesick/repos/oh-my-zsh
if [[ -e $omz_dir/oh-my-zsh.sh ]] then
	export ZSH=$omz_dir
	# Let homeshick handle the updating
	DISABLE_AUTO_UPDATE="true"
	if [[ -z "$ZSH_THEME" ]] then
		export ZSH_THEME="jreese"
	fi
	plugins+=(ant cake coffee extract history-substring-search npm pip)
	if [[ $system == 'Linux' ]]; then
		plugins+=(debian)
	fi
	if [[ $system == 'OSX' ]]; then
		plugins+=(brew terminalapp osx)
	fi
	source $omz_dir/oh-my-zsh.sh
	unsetopt correct_all
	# Disable the automatic titling, it screws up tmux
	DISABLE_AUTO_TITLE=true
fi
unset omz_dir

if [[ $system == 'Linux' ]]; then
	. $rcfiles/zsh/rc.linux.zsh
fi
if [[ $system == 'OSX' ]]; then
	. $rcfiles/zsh/rc.osx.zsh
fi

. $rcfiles/aliases
. $rcfiles/tools

if [[ -f ~/.dir_colors && ( -x /usr/local/bin/dircolors || -x /usr/bin/dircolors ) ]]; then
    eval `dircolors ~/.dir_colors`
fi

if [[ -e ~/.ssh/ssh_auth_sock ]] then
	export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi

compile-zshrc () {
	homesick_repos=$HOME/.homesick/repos
	if [[ -n $1 && $1 == "clean" ]]; then
		find $homesick_repos -name '*.zwc' -delete
		echo 'All *.zwc files removed'
		return
	fi;
	for file in `find $homesick_repos -name '*.zsh' -type f -print`; do
		zcompile $file
	done
}

unset rcfiles
unset system
