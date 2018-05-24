# -*- ksh -*-
# xsession: a .xsession file for hooking in xinitrc and bash_profile.
#

# To keep my X setup cross-platform and also allow for machines on which I
# use both ssh and X-console access, I have this file.  This gets run by
# xdm in some random shell (probably bash but technically we don't know that)
# to try and bring up my X environment.  But I want the X environment that I
# also use on systems without all this newfangled crap.

# What we do here is make sure we're running under bash.  If not we try to
# make that the case.  Then we load the bash_profile which gets most of the
# rest of the environment put together and then pull up the usual X startup
# out of xinitrc.

##############################################################################

XDMRUNNING=yes; export XDMRUNNING

# are we bash?
if [ -z "$BASH_VERSINFO" ]; then
  # is there a bash?
  for bashloc in /usr/local/bin/bash /bin/bash; do
    if [ -x "$bashloc" ]; then
      # be the bash!
      exec "$bashloc" "$0" "$@"
    fi
  done

  # If that doesn't work we're just going to hope for the best.
  # Most of these scripts are straight ksh anyway.
fi

if [ x = "${SSH_AGENT_PID}x" ]; then
  # No good.  We're not running an ssh-agent.  Re-exec this script from within
  # an ssh-agent.  (I could do this with a manual logout but things are less
  # likely to get cleaned up that way.)
  exec ssh-agent "${HOME}/.xsession" >/dev/null
fi

# load .bash_profile.  We're almost a login shell, so fake it.
# (Note that it is important that the login shell not exec itself!
# That's why we've done the ssh-agent stuff above.  If that happens,
# I think we'll accidentally start over.)
. "$HOME/.bash_profile"

#
# okay, now try the usual startup crap as if we weren't running xdm.
# I'd like to do this in the current shell but there's no reason that
# exec should take out this shell (that's bad, actually, because we
# want to run .bash_logout and clean up stuff on exit).  So we keep this
# shell running and run .xinitrc in a subshell.
#
# cd here because BSD might think we're in /usr/home, not /home.
#
(cd ; bash "$HOME/.xinitrc")

#
# We do this here to make sure ssh_agents get cleaned up.
#
. "$HOME/.bash_logout"
