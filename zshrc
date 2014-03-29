# -*- ksh -*-

# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

setopt BAD_PATTERN

#allow tab completion in the middle of a word
setopt COMPLETE_IN_WORD

## keep background processes at full speed
#setopt NOBGNICE
## restart running processes on exit
#setopt HUP

## history
setopt APPEND_HISTORY
## for sharing history between zsh processes
# setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

## never ever beep ever
#setopt NO_BEEP

## automatically decide when to page a list of completions
#LISTMAX=0

## disable mail checking
#MAILCHECK=0

# autoload -U colors
#colors

PROMPT="%1(j.[%j job%2(j.s.)] .)%n@%m:%~%# "
RPROMPT='%(3D.%(1d.~APRIL FOOLS~ .).)'
FIGNORE=.svn:~:.git

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
done
for dir in \
 "$HOME" \
 "$HOME"/local \
 "$HOME"/opt/scala \
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

EDITOR=''
for possible in emacsclient-nw emacsclient gnuclient emacs xemacs vi ; do
    if test -z "$EDITOR" && which "$possible" >/dev/null 2>&1 ; then
        export EDITOR="$possible"
    fi
done

export CVS_RSH=ssh
export PAGER=less
export VISUAL="${EDITOR}"
export FIGNORE=.svn:~:.git
export TJS_TMPDIR="/tmp/tjs"
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=9999
export SAVEHIST=9999
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS


ulimit -c unlimited

# Note that the semicolon is required.
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
alias j=jobs
alias accw="svin resolve --accept=working"
#alias shit="find . -name core -o -name \*.core -o \! -name . \( -type d -prune \! -type d \) | xargs rm"
alias shit="find . -maxdepth 1 \( -name core -o -name \*.core \) -print -exec rm {} \;"
alias clean="find . -maxdepth 1 \( -name \*~ \) -print -exec rm {} \;"
alias deep-clean='find . -name \*~ -print -exec rm {} \;'
alias open=xdg-open             # don't do this on a Mac

# argh.  redhat %!^@#&.
if alias rm 2>/dev/null ; then
  unalias rm
fi

set -o notify

# see also WORDCHARS; I think / and = need to be omitted from it
autoload -U select-word-style
select-word-style bash

# from jflorenc
function gn
{
    start=`date +%s`
    "$@"
    end=`date +%s`
    elapsed=$((end - start))
    /usr/bin/notify-send "Finished" "Job completed: $*\n\nat `date`, run for ${elapsed}s"
}

# convert Unix time to ctime.  If time is huge, it's probably Java ms, fudge it.
function gmtime  
{
    perl -we 'map { print scalar(gmtime($_ > 2000000000 ? $_/1000 : $_)),"\n" } (@ARGV);' "$@"
}

# convert Unix time to ctime.  If time is huge, it's probably Java ms, fudge it.
function localtime
{
    perl -we 'map { print scalar(localtime($_ > 2000000000 ? $_/1000 : $_)),"\n" } (@ARGV);' "$@"
}

# mangle tabs and newline characters for ad-hoc pretty-printing

function nltab
{
    perl -pne 's/\\n/\n/g; s/\\t/\t/g; '
}

#############################################################################
#
# LinkedIn
#
alias bestop="ps aux | grep 'java.*container' | grep -v 'grep' | awk '{print \$2}' | xargs kill -9"
alias lh='cd $LEOHOME'
alias jh="cd $HOME/s/jobs_trunk"



#############################################################################

# Features I want from tcsh that aren't in bash:
# !-whatever-tab should expand out the history on the readline.
# ... although C-r is so close I don't miss this.
# set rmstar protection from being a fuckwit.

# Features I want from zsh that aren't in bash or tcsh:
set rmstar on

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

# this is stuff from the default list on Linux

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

