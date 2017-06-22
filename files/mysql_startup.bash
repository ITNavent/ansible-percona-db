#!/bin/bash
#
### BEGIN INIT INFO
# Provides:          mysql
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Should-Start:      $network $named $time
# Should-Stop:       $network $named $time
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start and stop the mysql (Percona Server) daemon
# Description:       Controls the main MySQL (Percona Server) daemon "mysqld"
#                    and its wrapper script "mysqld_safe".
### END INIT INFO
#
set -e
set -u
${DEBIAN_SCRIPT_DEBUG:+ set -v -x}
PERCONA_PREFIX=/usr

test -x "${PERCONA_PREFIX}"/sbin/mysqld || exit 0

# read default file
startup_timeout=900
stop_timeout=300
[ -e /etc/default/mysql ] && . /etc/default/mysql || true

. /lib/lsb/init-functions

SELF=$(cd $(dirname $0); pwd -P)/$(basename $0)
CONF=/etc/mysql/my.cnf
MYADMIN="${PERCONA_PREFIX}/bin/mysqladmin"

# priority can be overriden and "-s" adds output to stderr
ERR_LOGGER="logger -p daemon.err -t /etc/init.d/mysql -i"

# Safeguard (relative paths, core dumps..)
cd /
umask 077

# mysqladmin likes to read /root/.my.cnf. This is usually not what I want
# as many admins e.g. only store a password without a username there and
# so break my scripts.
export HOME=/etc/mysql/

## Fetch a particular option from mysql's invocation.
#
# Usage: void mysqld_get_param option
mysqld_get_param() {
	"${PERCONA_PREFIX}"/sbin/mysqld --print-defaults \
		| tr " " "\n" \
		| grep -- "--$1" \
		| tail -n 1 \
		| cut -d= -f2
}

## Do some sanity checks before even trying to start mysqld.
sanity_checks() {
  # check for config file
  # DISABLED: We do not install my.cnf
  #if [ ! -r /etc/mysql/my.cnf ]; then
  #  log_warning_msg "$0: WARNING: /etc/mysql/my.cnf cannot be read. See README.Debian.gz"
  #  echo                "WARNING: /etc/mysql/my.cnf cannot be read. See README.Debian.gz" | $ERR_LOGGER
  #fi

  # check for diskspace shortage
  datadir=`mysqld_get_param datadir`
  if LC_ALL=C BLOCKSIZE= df --portability $datadir/. | tail -n 1 | awk '{ exit ($4>4096) }'; then
    log_failure_msg "$0: ERROR: The partition with $datadir is too full!"
    echo                "ERROR: The partition with $datadir is too full!" | $ERR_LOGGER
    exit 1
  fi
}

## Checks if there is a server running and if so if it is accessible.
#
# check_alive insists on a pingable server
# check_dead also fails if there is a lost mysqld in the process list
#
# Usage: boolean mysqld_status [check_alive|check_dead] [warn|nowarn]
mysqld_status () {
    ping_output=`$MYADMIN ping 2>&1`; ping_alive=$(( ! $? ))

    ps_alive=0
    pidfile=`mysqld_get_param pid-file`
    if [ -f "$pidfile" ] && ps `cat $pidfile` >/dev/null 2>&1; then ps_alive=1; fi

    if [ "$1" = "check_alive"  -a  $ping_alive = 1 ] ||
       [ "$1" = "check_dead"   -a  $ping_alive = 0  -a  $ps_alive = 0 ]; then
	return 0 # EXIT_SUCCESS
    else
  	if [ "$2" = "warn" ]; then
  	    echo -e "$ps_alive processes alive and '$MYADMIN ping' resulted in\n$ping_output\n" | $ERR_LOGGER -p daemon.debug
	fi
  	return 1 # EXIT_FAILURE
    fi
}

#
# main()
#

case "${1:-''}" in
  'start')
	sanity_checks;
	# Start daemon
	log_daemon_msg "Starting MySQL (Percona Server) database server" "mysqld"
	if mysqld_status check_alive nowarn; then
	   log_progress_msg "already running"
	   log_end_msg 0
	else
  	    "${PERCONA_PREFIX}"/bin/mysqld_safe > /dev/null 2>&1 &
	    dead_check_counter=0
	    while true; do
                sleep 1
	        if mysqld_status check_alive nowarn ; then break; fi
		# wait before start checking if pid file created or server is dead
		if [ $dead_check_counter -lt $startup_timeout ]; then
			dead_check_counter=$(( dead_check_counter + 1 ))
		else
			if mysqld_status check_dead nowarn; then break; fi
		fi
		log_progress_msg "."
	    done
	fi
	;;

  'stop')
	# * As a passwordless mysqladmin (e.g. via ~/.my.cnf) must be possible
	# at least for cron, we can rely on it here, too. (although we have
	# to specify it explicit as e.g. sudo environments points to the normal
	# users home and not /root)
	log_daemon_msg "Stopping MySQL (Percona Server)" "mysqld"
	if ! mysqld_status check_dead nowarn; then
	  set +e
	  shutdown_out=`$MYADMIN shutdown 2>&1`; r=$?
	  set -e
	  if [ "$r" -ne 0 ]; then
	    log_end_msg 1
	    [ "$VERBOSE" != "no" ] && log_failure_msg "Error: $shutdown_out"
	    log_daemon_msg "Killing MySQL (Percona Server) by signal" "mysqld"
	    killall -15 mysqld
            server_down=
	    for i in `seq 1 $stop_timeout`; do
              sleep 1
              if mysqld_status check_dead nowarn; then server_down=1; break; fi
            done
          if test -z "$server_down"; then killall -9 mysqld; fi
	  fi
        fi

        if ! mysqld_status check_dead warn; then
	  log_end_msg 1
	  log_failure_msg "Please stop MySQL (Percona Server) manually and read /usr/share/doc/percona-server-server-5.5/README.Debian.gz!"
	  exit -1
	else
	  log_end_msg 0
        fi
	;;

  'restart')
	set +e; $SELF stop; set -e
	$SELF start
	;;

  'reload'|'force-reload')
  	log_daemon_msg "Reloading MySQL (Percona Server)" "mysqld"
	$MYADMIN reload
	log_end_msg 0
	;;

  'status')
	if mysqld_status check_alive nowarn; then
	  log_action_msg "$($MYADMIN version)"
	else
	  log_action_msg "MySQL (Percona Server) is stopped."
	  exit 3
	fi
  	;;

  *)
	echo "Usage: $SELF start|stop|restart|reload|force-reload|status"
	exit 1
	;;
esac