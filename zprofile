#
# .zprofile
#

# If we are running under XDM, skip the chatty crap.
#
# If we are running on Mac, every shell is a login shell,
# and this is annoying.
if [ -z "$XDMRUNNING" -a `uname` != Darwin ]; then
    (
        echo "/*"

        offensive=-a
        if [ "$USER" != tjs -o -f /etc/redhat-release ]; then
            # fortune -a wimps out on RHEL, don't use it
            # (maybe it's fixed by now, I haven't checked in a while.)
            # don't run it at work, or as root, either
            offensive=
        fi

        if [ -x /usr/games/fortune ]; then
            /usr/games/fortune $offensive
        else
            # zsh outputs the error on fd 1 (at least on my mac)
            fortunate=`which fortune | grep -v 'not found'`
            if [ -n "$fortunate" ]; then
                "$fortunate" $offensive
            else
                echo "The fortune cookie was empty."
            fi
        fi
      
        echo "*/"
    ) 
fi

#
# If we are running under xdm or something, we might already have done this.
# If not, make sure we do it now.  (If we are on a Mac, don't, because there is
# voodoo that makes this just do the right thing somewhat magically.)
#
if [ -z "$SSH_AGENT_PID" -a `uname` != "Darwin" ]; then
  # Start an ssh-agent but supress its pid output
  # (Note that we ONLY do this if we haven't done it.  Secretly this script
  # is run by my .xsession in the .xsession shell so it gets run even if
  # there was no proper login shell, but that script also runs ssh-agent so
  # this code doesn't get run.)

  exec ssh-agent zsh
  #echo "WARNING: could not exec ssh-agent; still in original shell" 1>&2

  # lame way; very undesirable, but not confused by trying to start a new
  # shell.  when this shell exits, the ssh-agent won't, and that means they
  # tend to accumulate.
  
  # eval `ssh-agent 2>/dev/null`
fi

# path munging in ~/.zshrc because in today's enlightened world, my GDM system
# can get me to a shell window that never went through a login shell.  Better
# to have it in one place.
