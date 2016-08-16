#
# .zprofile
#

# If we are running under XDM, skip the chatty crap.
if [ -z "$XDMRUNNING" ]; then
  (
  echo "/*"
  if [ -x /usr/games/fortune ]; then
    if [ -f /etc/redhat-release ]; then
      # can't run fortune -a -- redhat broke it.
      fortune
    else
      fortune -a
    fi
  fi
  echo "*/"
  ) 
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

  #exec ssh-agent zsh
  #echo "WARNING: could not exec ssh-agent; still in original shell" 1>&2
  eval `ssh-agent 2>/dev/null`
fi

#
# If we got here, we have a running ssh-agent via .xsession, or something
# is screwed up.  Oh, well, whatever, start the usual .bashrc crap.
#

# User specific environment and startup programs

if [ -x /usr/bin/keychain ] ; then
	MYNAME=`/usr/bin/whoami`
	if [ -f ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key ] ; then
	      /usr/bin/keychain ~/.ssh/${MYNAME}_at_linkedin.com_dsa_key
      	      . ~/.keychain/`hostname`-sh
	fi
fi

export PATH=$HOME/bin:$HOME/local/bin:/export/apps/xtools/bin:$PATH

##############################################################################
# LinkedIn
#

export NETREPO=svn+ssh://svn.corp.linkedin.com/netrepo/network
export LIREPO=svn+ssh://svn.corp.linkedin.com/lirepo
export VENREPO=svn+ssh://svn.corp.linkedin.com/vendor

export JAVA_HOME=/export/apps/jdk/JDK-1_8_0_5
export JDK_HOME=/export/apps/jdk/JDK-1_8_0_5
export ORACLE_HOME=/local/instantclient_10_2
export TNS_ADMIN=/local/instantclient_10_2
export NLS_LANG=American_America.UTF8

export LD_LIBRARY_PATH=/local/instantclient_10_2

export ORACLE_SID=DB
export PATH=$JAVA_HOME/bin:/usr/local/bin:$PATH:/usr/local/mysql/bin:$ORACLE_HOME/bin

export PATH=$ORACLE_HOME:/usr/local/linkedin/bin:/export/content/linkedin/bin:$PATH

export LEOHOME=/home/tshowalt/s/network.trunk/
export ORACLE_SID=DB
