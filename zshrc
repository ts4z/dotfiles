# -*- sh -*-

#
# .zshrc for ts4z
#

if [ `id -u` -ne 0 ]; then
    # Disabled, because on some hosts (like my Mac) I own the shell dirs and
    # this upsets zsh for reasonable security reasons.
    autoload -U compinit
    compinit
fi

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
MAILCHECK=0
unset MAIL
unset MAILPATH

# autoload -U colors
#colors

prompt_nat='%S%n%s@'
case `whoami` in
    timshowalter|tjs)
        prompt_nat='' ;;
    *) ;;
esac

current_git_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

set_prompt_git_vars ()
{
    prompt_git_branch=''
    local branch=$(current_git_branch)
    if [[ "$branch" != '' ]]; then
        # if [ "$branch" = master ]; then
        #     # "master" is too long and too common; abbreviate
        #     # (consider an emoji tree if OSX Emacs restores support
        #     # for them.)
        #     branch='⍟' # other interesting characters: ⎈⍟⧳⋮
        # fi
        local rev_on=''
        local rev_off=''
        local git_status=$(git status -s 2>&1)
        if [[ -n "$git_status" ]] ; then
            # workspace is dirty (uncommitted file OR unpushed change)
            local stars=''
            if echo "$git_status" | grep -q '??' ; then
                stars='☢'
            fi
            if ! git diff HEAD --quiet ; then
                # we are not consistent with HEAD; add a *
                stars="${stars}✻"
            fi
            #rev_on="%S "
            #rev_off=" %s"
        fi
        prompt_git_branch=' '"$rev_on($branch)$stars$rev_off"
    fi
}

reset_prompt() {
    PROMPT="%1(j.[%j job%2(j.s.)] .)%B${prompt_nat}%m%b %42<…<%~${prompt_git_branch}%<< %# "
}

if [ `id -u` != 0 ]; then
    precmd_functions=(
        set_prompt_git_vars
        reset_prompt
    )
else
    # just do this once, we're root, we don't need to screw around
    reset_prompt
fi

RPROMPT='%(3D.%(1d.~APRIL FOOLS~ .).)'
FIGNORE=.svn:~:.git

# Path slicing and dicing.  Remove stupid crap from the path (relative dirs,
# but also nonexistant dirs and duplicates, since we probably just made a
# bunch of those).  This is hard to do in Bourne shell, so I resort to
# a perl hairball called whackpath.  If that can't be found, we don't.
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
 "$HOME"/go \
 "$HOME" \
 "$HOME"/local \
 "$HOME"/opt/scala \
 "$HOME"/go \
 /usr/lib/go-1.9 \
 /usr/local \
 /usr/local/X11R6 \
 /usr/local/kde \
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

alias brawl='brew update && brew upgrade && brew cleanup && brew cask outdated' 
alias cls=clear
alias eighty="echo 01234567890123456789012345678901234567890123456789012345678901234567890123456789"
alias eightyn="(eighty; cat >/dev/null)"
alias gz=gzip
alias k=kubectl
alias j=jobs
alias accw="svin resolve --accept=working"
#alias shit="find . -name core -o -name \*.core -o \! -name . \( -type d -prune \! -type d \) | xargs rm"
alias shit="find . -maxdepth 1 -type f \( -name core -o -name \[0-9\]\*.core -o -name core.\*\[0-9\] \) -print -exec rm {} \;"
alias deep-shit="find . -type f \( -name core -o -name \[0-9\]\*.core -o -name core.\*\[0-9\] \) -print -exec rm {} \;"
alias clean="find . -maxdepth 1 \( -name \*~ \) -print -exec rm {} \;"
alias deep-clean='find . -name \*~ -print -exec rm {} \;'
alias tmuxa='tmux a || tmux'
# trash both + and / as they don't cut and paste well.
# not optimal, but pretty good.
alias pwgen='dd if=/dev/urandom bs=15 count=1 2>/dev/null | base64 | tr +/ __'

if [ `uname -s` != Darwin ]; then
  alias open=xdg-open
fi
# nobody seems to have finger installed anymore.
ncfinger () {
    echo "$1" | cut -d@ -f1 | nc `echo $1 | cut -d@ -f2` 79
}
screen () {
    echo "you meant tmux, right?"
}
alias em='emacsclient -c'

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
# with no args, just print the local time.
function gmtime  
{
    perl -we 'if (!@ARGV) { push @ARGV, time } map { print scalar(gmtime($_ > 2000000000 ? $_/1000 : $_)),"\n" } (@ARGV);' "$@"
}

# convert Unix time to ctime.  If time is huge, it's probably Java ms, fudge it.
# with no args, just print the local time.
function localtime
{
    perl -we 'if (!@ARGV) { push @ARGV, time } map { print scalar(localtime($_ > 2000000000 ? $_/1000 : $_)),"\n" } (@ARGV);' "$@"
}

alias epochtime='date +%s'

# mangle tabs and newline characters for ad-hoc pretty-printing

function nltab
{
    perl -pne 's/\\n/\n/g; s/\\t/\t/g; '
}

# oh, rmstar, how I've missed you
set rmstar on

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# this is fine, but do we get this for free with a reasonable
# kubectl install?
#if which kubectl >/dev/null 2>&1 ; then
#    source <(kubectl completion zsh)
#fi

if which direnv >/dev/null ; then
    eval "$(direnv hook zsh)"
fi

# this is stuff from the default list on Linux

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
if which dircolors >& /dev/null ; then
    eval "$(dircolors -b)"
fi
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
