# -*- sh -*-
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

# User specific environment and startup programs

PATH=$PATH:$HOME/bin

if [ -x /usr/bin/keychain ] ; then
	MYNAME=`/usr/bin/whoami`
	if [ -f ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key ] ; then
	      /usr/bin/keychain ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key
      	      . ~/.keychain/`hostname`-sh
	fi
fi

##############################################################################
# LinkedIn
#

export NETREPO=svn+ssh://svn.corp.linkedin.com/netrepo/network
export LIREPO=svn+ssh://svn.corp.linkedin.com/lirepo
export VENREPO=svn+ssh://svn.corp.linkedin.com/vendor

export JAVA_HOME=/export/apps/jdk/JDK-1_7_0_51
export JDK_HOME="$JAVA_HOME"
export ORACLE_HOME=/local/instantclient_10_2
export TNS_ADMIN=/local/instantclient_10_2
export NLS_LANG=American_America.UTF8

export LD_LIBRARY_PATH=/local/instantclient_10_2

export ORACLE_SID=DB
export PATH=$JAVA_HOME/bin:/usr/local/bin:$PATH:/usr/local/mysql/bin:$ORACLE_HOME/bin
export PATH=$HOME/local/bin:/export/apps/xtools/bin:$ORACLE_HOME:/usr/local/linkedin/bin:/export/content/linkedin/bin:$PATH

export LEOHOME=/home/tshowalt/s/network.trunk/
export ORACLE_HOME=/local/instantclient_10_2 # or wherever you have Oracle installed
export ORACLE_SID=DB

# hack for LI since it's hard to change shell here :-(
export SHELL=/bin/zsh

# 
# end LinkedIn
##############################################################################

. "$HOME/.bashrc"
