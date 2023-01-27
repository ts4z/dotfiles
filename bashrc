# -*- sh -*-
#

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# (Path munging removed, it wasn't right.  See zshrc.)

umask 22

export CVS_RSH=ssh
if which gnuclient >/dev/null 2>&1; then 
    export EDITOR=gnuclient
else
    export EDITOR=emacs
fi
export PAGER=less
export VISUAL="${EDITOR}"
export FIGNORE=.svn:~:.git
export TJS_TMPDIR="/tmp/tjs"
if [ -d "${HOME}/cvs-tjs" ]; then
  export TJS_CVS="${HOME}/cvs-tjs"
else
  export TJS_CVS="${HOME}/cvs"
fi

ulimit -c unlimited

# Note that the semicolon is required.
zless () { zcat $1 | less ; }
title () { echo -n "]0;$*" ; }
# bored?
rot13 () { 
	if [ x"$*" != x ] ; then
		for x in "$@" ; do tr a-zA-Z n-za-mN-ZA-M < $x ; done
	else
		tr a-zA-Z n-za-mN-ZA-M
	fi
}

alias cls=clear
alias eighty="echo 01234567890123456789012345678901234567890123456789012345678901234567890123456789"
alias gz=gzip
alias l=less
alias j=jobs
#alias rot13="tr a-zA-Z n-za-mN-ZA-M"
#alias shit="find . -name core -o -name \*.core -o \! -name . \( -type d -prune \! -type d \) | xargs rm"
alias shit="find . -maxdepth 1 \( -name core -o -name \*.core \) -print -exec rm {} \;"
alias clean="find . -maxdepth 1 \( -name \*~ \) -print -exec rm {} \;"

# argh.  redhat %!^@#&.
if alias rm 2>/dev/null ; then
  unalias rm
fi

# The shell prompt.  This makes it tjs@nil:~$
PS1='\u@\h:\w\$ '

set -o notify

#
# Source any externally-maintained bash startup scripts.
#
if [ -d "$HOME/cvs/lib/bash-startup" ]; then
  for script in "$HOME"/cvs/lib/bash-startup/[a-z]* ; do
    if [ -f "$script" ]; then
      . "$script"
    fi
  done
fi

#############################################################################

# Features I want from tcsh that aren't in bash:
# !-whatever-tab should expand out the history on the readline.
# ... although C-r is so close I don't miss this.
# set rmstar protection from being a fuckwit.
