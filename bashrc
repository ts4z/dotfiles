# -*- ksh -*-
#

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Path slicing and dicing.  Remove stupid crap from the path (relative dirs,
# but also nonexistant dirs and duplicates, since we probably just made a
# bunch of those).  This is hard to do in Bourne shell, so I resort to
# a perl hairball called whackpath.  If that can't be found we use
cleanpath ()
{
  for dir in "$HOME/cvs/bin" "$HOME/cvs-tjs/bin" ; do
    if [ -x "${dir}/whackpath" ]; then
      answer=`"${dir}/whackpath" "$@"`
      if [ -n "$answer" ]; then
	# success--output cleaned up PATH setting
	echo "$answer"
	return 0
      fi
      return 0
    fi
  done
  # failed--output the input
  echo "$@"
}


# Add extra crap to the back of the path.  Since I'm now using an
# external perl script to make this work, I could conceivably do this
# in the perl script instead, but this way it works even if perl is
# hosed somehow.
#

for dir in \
 /usr/sbin \
 /usr/games \
 /sbin \
 ; do
  PATH="$PATH:$dir"
done
for dir in \
 /usr \
 /usr/share \
 /usr/local \
 /usr/local/share \
 ; do
  MANPATH="$MANPATH:${dir}/man"
done
for dir in \
 "$HOME" \
 "$HOME"/local \
 /usr/local \
 /usr/local/X11R6 \
 /usr/local/kde/bin \
 /usr/games \
 /bin \
 /usr \
 /usr/X11R6 \
 ; do
  # duplicates are eliminated below
  PATH="$PATH:${dir}/bin"
  if [ -d "${dir}/share" ]; then
    MANPATH="${MANPATH}:${dir}/share/man"
  else
    MANPATH="${MANPATH}:${dir}/man"
  fi
done

export PATH=`cleanpath "${PATH}"`
export MANPATH=`cleanpath "${MANPATH}"`

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
#
# LinkedIn
#
alias anfb='ant -Dno.full.build=true'
alias fullclean='ant -f $LEOHOME/build.xml fullclean'
alias bestop="ps aux | grep 'java.*container' | grep -v 'grep' | awk '{print \$2}' | xargs kill -9"
alias activate-tools-dev="source $HOME/.virtualenvs/linkedin/bin/activate"


#############################################################################

# Features I want from tcsh that aren't in bash:
# !-whatever-tab should expand out the history on the readline.
# ... although C-r is so close I don't miss this.
# set rmstar protection from being a fuckwit.
