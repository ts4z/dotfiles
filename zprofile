#
# .zprofile
# (untested!)
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

export JAVA_HOME=/export/apps/jdk/JDK-1_6_0_27
export JDK_HOME=/export/apps/jdk/JDK-1_6_0_27
export ORACLE_HOME=/local/instantclient_10_2
export TNS_ADMIN=/local/instantclient_10_2
export NLS_LANG=American_America.UTF8

export LD_LIBRARY_PATH=/local/instantclient_10_2

export ORACLE_SID=DB
export PATH=$JAVA_HOME/bin:/usr/local/bin:$PATH:/usr/local/mysql/bin:$ORACLE_HOME/bin

export M2_HOME=/local/maven
export M2=$M2_HOME/bin

export ANT_HOME=/local/apache-ant-1.7.1
export ANT_OPTS="-Xms512m -Xmx2500m -XX:PermSize=256m -XX:MaxPermSize=1024m"

export GRADLE_HOME=/local/gradle-1.0-milestone-3

export PATH=$HOME/local/bin:/export/apps/xtools/bin:$ORACLE_HOME:$ANT_HOME/bin:$GRADLE_HOME/bin:/usr/local/linkedin/bin:$PATH

export LEOHOME=/home/tshowalt/s/network.trunk/
export QUICK_DEPLOY=/home/tshowalt/s/quick-deploy
export ORACLE_HOME=/local/instantclient_10_2 # or wherever you have Oracle installed
export ORACLE_SID=DB
