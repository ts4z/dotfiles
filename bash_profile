# -*- ksh -*-
#
# .bash_profile (aka cvs/dotfiles/bash_profile)
# Tim Showalter
# not that it's properly ksh, but ksh-mode works so much better than
# shell-script mode!
#

# If we are running under XDM, skip the chatty crap.
if [ -z "$XDMRUNNING" ]; then
  (
  if [ -x /usr/games/fortune ]; then
    if [ -f /etc/redhat-release ]; then
      # can't run fortune -a -- redhat broke it.
      fortune
    else
      fortune -a
    fi
  fi
  ) | perl -pne 's/^/-- /'
fi

#
# If we are running under xdm or something, we might already have done this.
# If not, make sure we do it now.
#
if [ -z "$SSH_AGENT_PID" ]; then
  # Start an ssh-agent but supress its pid output
  # (Note that we ONLY do this if we haven't done it.  Secretly this script
  # is run by my .xsession in the .xsession shell so it gets run even if
  # there was no proper login shell, but that script also runs ssh-agent so
  # this code doesn't get run.)

  #exec ssh-agent bash
  #echo "WARNING: could not exec ssh-agent; still in original shell" 1>&2
  eval `ssh-agent 2>/dev/null`
fi

#
# If we got here, we have a running ssh-agent via .xsession, or something
# is screwed up.  Oh, well, whatever, start the usual .bashrc crap.
#

. "$HOME/.bashrc"
