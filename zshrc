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
    tshowalter|timshowalter|timshow|tjs)
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
                stars='♺'
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

prompt_hostname='%m'

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

# Rewrite PATH into the order I prefer.

# Add these to back of path.
path+=(/bin)
path+=(/usr/sbin)
path+=(/sbin)
path+=(/usr/games)

scanpaths=(
        "$HOME"/go \
        "$HOME" \
        "$HOME"/local \
        "$HOME"/opt/scala \
        "$HOME"/go \
        "$HOME/.cargo" \
        "$HOME/.local" \
	/opt/homebrew \
        /opt/homebrew/opt/postgresql@15 \
        /snap \
        /opt/go \
        /usr/local \
        /usr/local/X11R6 \
        /usr/local/kde \
        /usr/games \
        /usr \
        /usr/X11R6 \
        )

# Scan the above list in reverse order.
for dir in ${(Oa)scanpaths} ; do
    # Add each interesting item to the front of the path.
    if [ -d "${dir}/bin" ]; then
        path=("${dir}/bin" $path)
    fi
    if [ -d "${dir}/share/man" ]; then
        manpath+=("${dir}/share/man" $manpath)
    fi
    if [ -d "${dir}/man" ]; then
        manpath+=("${dir}/man" $manpath)
    fi
done

# Keep first occurrence, remove others.
typeset -U path
typeset -U manpath

umask 22

EDITOR=''
for possible in emacsclient-nw emacsclient gnuclient emacs xemacs vi ; do
    if test -z "$EDITOR" && which "$possible" >/dev/null 2>&1 ; then
        export EDITOR="$possible"
    fi
done

export GOPATH="$HOME/go"
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

no-screensaver() {
    echo "Crippling xscreensaver; ^C to end..."
    (
        while true; do
            xscreensaver-command -deactivate >/dev/null
            sleep 60
        done
    )
}

python() {
    echo "zshrc: Use python2 or python3, this is ambiguous." 1>&2
    echo "args:" "$@"
    if command -v python3 2>/dev/null ; then
        echo "zshrc: Running python3 on path." 1>&2
        python3 "$@"
    elif command -v python2 ; then
        echo "zshrc: Running python2 on path." 1>&2
        python2 "$@"
    else
        echo "No python installed. What year is this?" 1>&2
        false
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
# trash both + and / as they don't cut and paste well.
# try _ and . for now.
alias pwgen='dd if=/dev/urandom bs=15 count=1 2>/dev/null | base64 | tr +/ _.'

if ! which open >&/dev/null ; then
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

# tmux
alias tmuxa='tmux a || tmux'
reagent() {
    # grab environment from connected session
    eval $(tmux show-env -s)
}
# do it once now, so closing & reopening session reattaches to current agent
reagent

# argh.  redhat %!^@#&.
if alias rm 2>/dev/null ; then
  unalias rm
fi

# argh. ubuntu.
if ! which cal >/dev/null && which ccal >/dev/null ; then
    alias cal=ccal
fi

set -o notify

# see also WORDCHARS; I think / and = need to be omitted from it
autoload -U select-word-style
select-word-style bash

# from jflorenc
gn() {
    start=`date +%s`
    "$@"
    end=`date +%s`
    elapsed=$((end - start))
    /usr/bin/notify-send "Finished" "Job completed: $*\n\nat `date`, run for ${elapsed}s"
}

# convert Unix time to ctime.  If time is huge, it's probably Java ms, fudge it.
# with no args, just print the local time.
gmtime() {
    perl -we 'if (!@ARGV) { push @ARGV, time } map { print scalar(gmtime($_ > 2000000000 ? $_/1000 : $_)),"\n" } (@ARGV);' "$@"
}

# convert Unix time to ctime.  If time is huge, it's probably Java ms, fudge it.
# with no args, just print the local time.
localtime() {
    perl -we 'if (!@ARGV) { push @ARGV, time } map { print scalar(localtime($_ > 2000000000 ? $_/1000 : $_)),"\n" } (@ARGV);' "$@"
}

alias epochtime='date +%s'

# mangle tabs and newline characters for ad-hoc pretty-printing

nltab() {
    perl -pne 's/\\n/\n/g; s/\\t/\t/g; '
}

g4d_usage () {
    cat 1>&2 <<EOF 
g4d: a simulacrum of the real g4d command (because old habits die hard)

Usage:
        g4d
                -- change to root directory in current sandbox
        g4d <sandbox>
                -- change to sandbox called <sandbox>
EOF
}

# By personal convention, I keep work source code in ~/s.
# This knowledge is baked in.
g4d () {
    wd=s
    creat_dir=''
    usage=''
    args=$(getopt dfh $*)
    if [ $? -ne 0 ]; then
        g4d_usage
        return 1
    fi
    eval set -- $args
    while :; do
        case "$1" in
            -d)
                echo "g4d: -d not yet supported"
                return 1;;
            -h)
                usage=1
                shift;;
            -f)
                creat_dir=1
                shift;;
            --)
                shift
                break;;
            *)
                echo 1>&2 "can't parse option '$1'"
                return 1
                ;;
        esac
    done

    if [ -n "$usage" ]; then
        g4d_usage
        return 1
    fi

    if [ $# -gt 1 ]; then
        g4d_usage
        return 1
    fi

    if [ $# = 0 ]; then
        # With no arguments, cd to the root of the sandbox.
        # I suppose you can do this with sed, but the quoting is insane.
        # Use temp vars here to help with readability (believe it or not).
        nd=$(pwd | WD="$wd" perl -pe '$wd = "$ENV{WD}"; $h = $ENV{HOME}; <>;
                 s:^$h/$wd/([^/]+).*$:$h/$wd/$1: or exit 1')
        if [ $? != 0 ]; then
            echo 1>&2 "g4d: not in sandbox"
            return 1
        fi
        cd "$nd"
        return 0
    fi
    
    if [ -n "$creat_dir" ]; then
        mkdir "$HOME/$wd/$1" || return false
        echo 1>&2 "g4d: created dir, you'll have to git clone yourself"
    fi

    cd "$HOME/$wd/$1"
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

#export GCP_PROJECT_ID=$(gcloud config list --format="value(core.project)")

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
