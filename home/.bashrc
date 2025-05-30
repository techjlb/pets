# ~/.bashrc: executed by bash(1) for non-login shells.
# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=100000
HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

export LANG=en_GB.UTF-8

export XDG_CONFIG_HOME="$HOME/.config"

eval "$(starship init bash)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml

export EDITOR=/usr/bin/vim

alias la=tree
alias cat=batcat

# Git
alias gc="git commit -m"
alias gca="git commit -a -m"
alias gp="git push origin HEAD"
alias gpu="git pull origin"
alias gst="git status"
alias glog="git log --graph --topo-order --pretty='%w(100,0,6)%C(yellow)%h%C(bold)%C(black)%d %C(cyan)%ar %C(green)%an%n%C(bold)%C(white)%s %N' --abbrev-commit"
alias gdiff="git diff"
alias gco="git checkout"
alias gb='git branch'
alias gba='git branch -a'
alias gadd='git add'
alias ga='git add -p'
alias gcoall='git checkout -- .'
alias gr='git remote'
alias gre='git reset'

# Docker
alias dco="docker compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias dl="docker ps -l -q"
alias dx="docker exec -it"

# Dirs
alias zz="z -"
alias cd="z"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

alias cl='clear'

tf() {
  if [ -z "$1" ]; then
    echo "Usage: tf <logfile>"
    return 1
  fi

  if [ ! -f "$1" ]; then
    echo "Error: '$1' is not a file."
    return 1
  fi

  tail -f "$1" | ccze -A
}

# Eza
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"

# vim
alias vi=vim

eval "$(zoxide init bash)"

### FZF ###
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow'
alias fe='fzf -m --preview="batcat --color=always {}" --bind "enter:become(vim {+})"'

# Function for directory navigation with fzf
fc() {
  local dir
  dir=$(fdfind --type d --hidden --follow | fzf --preview="eza -l --icons --git -a --color=always  {}")
  if [ -n "$dir" ]; then
    cd "$dir" || return
  fi
}

# navigation
cx() { cd "$@" && l; }

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

source /usr/share/doc/fzf/examples/key-bindings.bash

fastfetch

if [ -f "$HOME/.bashrc_local" ]; then
  source "$HOME/.bashrc_local"
fi
