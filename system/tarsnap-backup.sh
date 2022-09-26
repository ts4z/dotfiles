#!/bin/bash

# this probably has a lot of bugs!
#
# todo: make file list configurable and live in /etc or something
#
# todo: this is not smart w.r.t. log file vs stderr

set -eu
set -o pipefail

logfile=/var/log/tarsnap-backup.log
keep=28
keep_all=''                     # keep all, skip cleanup step
dry=''                          # don't do anything for real, just log
no_backup=''                    # skip backup, just do cleanup
tarsnap=/usr/bin/tarsnap

# do it, or don't; but if you don't, pretend that it worked
maybe () {
    (
        if [ -n "$dry" ]; then
            log "[dry] would run:" "$@"
            exit 0              # assume success
        else
            log "run:" "$@"
            exec "$@"           # tail-recurse?
            exit 1              # definitive failure
        fi
    )
}

log () {
    echo "$0" "$(date):" "$@" >> "$logfile"
}

list_old_backups () {
    # no maybe here; we need to do this for real
    # to see what the next commands are.
    tarsnap --list-archives | sort -r | tail +"$keep" | \
        perl -pe 'print STDERR "old backup: $_"'
}

# Run this in a subshell; it will report status via exit
clean_backups () {
    if [ -n "$keep_all" ]; then
	log "keep all backups set; skip GC"
        exit 0
    fi

    log "removing old backups..."
    
    for archive in $(list_old_backups) ; do
        maybe "$tarsnap" -d -f "$archive"
        ex=$?
        if [ "$ex" != 0 ]; then
            log "giving up on removing backups, tarsnap -d ... exited $ex"
            exit $ex
        fi
    done
    
    log "... done (successfully) removing old backups."
}

# I'm quite sure this is bogus

if ! options="$(getopt -n "$0" -o BKn -- "$@")"; then
    echo "error parsing options, giving up"
    exit 1
fi
# shellcheck disable=SC2086
set -- $options

for o ; do
    case "$o" in
        -B) no_backup=1; shift;;
        -n) dry=1; shift;;
        -K) keep_all=1; shift;;
        --)
            shift; break;;
        *)
            echo "bug: unknown option $o"
            exit 1;;
    esac
done

if [ $# -ne 0 ]; then
    echo extraneous args found, giving up
    exit 1
fi

log "------------------"
log "awaiting lock"
(
    flock -n 9 || exit 1

    log "have lock"

    (clean_backups)
    ex=$?
    if [ "$ex" != 0 ]; then
        log "NOTE: exit-status $ex while removing backups"
    fi
    
    # Be in /; that way we can create full-path archives (for
    # whatever archives we want to produce) without getting 
    # warnings about removing / from archive names
    cd /

    if [ -n "$no_backup" ]; then
        log "no_backup is set, not doing backup"
        exit 0
    else
        maybe "$tarsnap" -c \
	      --nodump \
	      -f "$(uname -n)-$(date +%Y-%m-%d_%H-%M-%S)" \
              --exclude '*~' \
	      home/tjs \
              root/tarsnap-backup.sh \
	      etc/sudoers.d/tjs \
	      etc/update-motd.d \
	      etc/ssh/ssh_config \
	      etc/ssh/sshd_config \
	      etc/rsnapshot.conf \
	      etc/fstab
        
        ex=$?

        log "...tarsnap completed, exit $ex"
    
        if [ $ex != 0 ]; then
            log "tarsnap reported error"
        fi
        
        exit $ex
    fi
    
) >>"$logfile" 2>&1 9>/var/lock/root-tarsnap-backup.lock

ex=$?

if [ "$ex" != 0 ]; then
    echo "error reported by tarsnap. logfile tails as follows:"
    tail "$logfile"
else
    log "done"
fi

exit $ex
