
#
# xinitrc
# Bring up an X environment.  I try and use the filenames of the files that
# exist on CMU's Andrew system and, not coincidentally, XFree86.
#
# Within my dotfiles, this file gets called by .xsession in order to
# bring up clients, after .xsession has gotten itself running under bash and
# gotten the environment set up.
#

# Guess some parameters so that we can configure programs based on them
# later.  Note the head -1 is necessary because xdpyinfo reads multiple heads;
# this makes everything act on the size and depth of the first head, which
# simplifies things somewhat.
xdpyinfo=`xdpyinfo`
XDISPLAYSIZE=`echo "$xdpyinfo" | grep dimensions: | head -1 | sed -e 's/^.*:[ ]*//' -e 's/ pixels.*//'` ; export XDISPLAYSIZE
XDISPLAYDEPTH=`echo "$xdpyinfo" | grep 'depth of root window: ' | head -1 | sed -e 's/^[^0-9]*//' -e 's/[^0-9]*$//'` ; export XDISPLAYDEPTH

# "which" is shit under Cygwin, so we can't use it.
# Type is similar but not fucked up.
type cpp >/dev/null && nocpp="" || nocpp="-nocpp"

# Load display-size specific stuff.  There has to be a file for the display
# you want or we get no display at all.
xrdb ${nocpp} -merge "${HOME}/.Xresources"
if [ -f "${TJS_CVS}/dotfiles/Xresources.${XDISPLAYSIZE}" ]; then
    xrdb ${nocpp} -merge "${TJS_CVS}/dotfiles/Xresources.${XDISPLAYSIZE}"
fi
sh -c '. "${HOME}/.Xclients"' &

exec gnome-session

#
# Make a last-ditch effort to get X not to immediately exit.
#
echo "No window manager could be executed; will substitute Death Term." 1>&2
exec xterm -fg white -bg firebrick2 -T "all that's standing between you and oblivion"
