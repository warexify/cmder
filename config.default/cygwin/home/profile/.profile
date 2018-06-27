###############################################################################
# User dependent .profile file

###############################################################################
# Set home directory
#export HOME=/root

###############################################################################
# Source the user's bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

###############################################################################
# Aliases, some people use a different file for aliases
if [ -f "${HOME}/.aliases" ]; then
  source "${HOME}/.aliases"
fi

###############################################################################
# Define personal dircolors
if [ -f "${HOME}/.dircolors" ] ; then
	eval `dircolors -b ${HOME}/.dircolors`
fi

###############################################################################
# This fixes the backspace when telnetting in.
# if [ "$TERM" != "linux" ]; then
#   stty erase
# fi

###############################################################################
# Only for console (ssh/telnet works w/o resize)
isTTY=$(ps | grep $$ | grep tty)
# Only for bash (bash needs to resize and can support these commands)
isBash=$(echo $BASH_VERSION)
# Only for interactive (not necessary for "su -")
isInteractive=$(echo $- | grep i)

shopt -s checkwinsize
if [ -n "$isTTY" -a -n "$isBash" -a -n "$isInteractive" ]; then
  checksize='echo -en "\E7 \E[r \E[999;999H \E[6n"; read -sdR CURPOS;CURPOS=${CURPOS#*[}; IFS="?; \t\n"; read lines columns <<< "$(echo $CURPOS)"; unset IFS'
  eval $checksize
  # columns is 1 in Procomm ANSI-BBS
  if [ 1 != "$columns" ]; then
    export_stty='export COLUMNS=$columns; export LINES=$lines; stty columns $columns; stty rows $lines'
    alias resize="$checksize; columns=\$((\$columns - 1)); $export_stty"
    eval "$checksize; columns=$(($columns - 1)); $export_stty"
    alias vim='function _vim(){ eval resize; TERM=xterm vi $@; }; _vim'
  else
    alias vim='TERM=xterm vi $@'
  fi
  alias vi='vim'
  alias ps='COLUMNS=1024 ps'
fi

###############################################################################
# Set Enhance Prompt
# PROMPT_COMMAND='printf "\n\e[0;37m[Folder Content: \e[1;34m$(ls -1 | wc -l | sed "s: ::g") files, $(ls -lah | grep -m 1 total | sed "s/total //")\e[0;37m]\n\e[0;37m[Memory Usage:\e[1;34m $((`sed -n "s/MemFree:[\t ]\+\([0-9]\+\) kB/\1/p" /proc/meminfo`/1024))M / $((`sed -n "s/MemTotal:[\t ]\+\([0-9]\+\) kB/\1/Ip" /proc/meminfo`/1024 ))M\e[0;37m]\n\e[0;37m[Path: \e[1;34m`pwd`\e[0;37m]\e[m\n"';
# export PROMPT_COMMAND
# Set Prompt
export PS1="\[\n\]\[\e[0;37m\][Path:\[\e[1;34m\] \w\[\e[0;37m\]]\n\[\e[1;\`if [[ \$? = "0" ]]; then echo "32m"; else echo "31m"; fi\`\][\u@\h] \[\e[0;37m\]λ \[\e[0m\]";
export PS2="\[\e[1;37m\]> \[\e[0m\]";

###############################################################################
# Set the title for the window
echo -en "\e]0; `hostname` \a";

###############################################################################
# Retrieve the shark folder

if [ "$SHARK_ROOT" == "" ] ; then
    case "$ConEmuDir" in *\\*) SHARK_ROOT=$( cd "$(cygpath -u "$ConEmuDir")/../.." ; pwd );; esac
else
    case "$SHARK_ROOT" in *\\*) SHARK_ROOT="$(cygpath -u "$SHARK_ROOT")";; esac
fi

# Remove any trailing '/'
SHARK_ROOT=$(echo $SHARK_ROOT | sed 's:/*$::')
export SHARK_ROOT
echo $SHARK_ROOT

###############################################################################
# Expand PATH to include sharks binaries
PATH=${PATH}:${SHARK_ROOT}/bin
PATH=${PATH}:${SHARK_ROOT}/modules/cygwin/bin
PATH=${PATH}:${SHARK_ROOT}/modules/git/bin
PATH=${PATH}:${SHARK_ROOT}/modules/gow/bin
PATH=${PATH}:${SHARK_ROOT}/modules/php
PATH=${PATH}:${SHARK_ROOT}/modules/putty
export PATH
