#!/bin/sh

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=600
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100


NAME=claymore
CLAYMORE_USER=claymore
DAEMON=./ethdcrminer64
EPOOL=eth-eu1.nanopool.org:9999 
WALLET=
MODE=1

CLAYMOREHOME=/home/claymore/claymore

PIDDIR=/var/run/claymore
PIDFILE=${PIDDIR}/claymore.pid

# Debian distros and SUSE
has_lsb_init()
{
  test -f "/lib/lsb/init-functions"
}


if has_lsb_init ; then
 . /lib/lsb/init-functions
elif has_init ; then
  . /etc/init.d/functions
else
  echo "Error: your platform is not supported by ${NAME}" >&2
  exit 1
fi

do_start()
{
 [ -d "${PIDDIR}" ] || mkdir -p "${PIDDIR}"

 if has_lsb_init ; then
   echo "start startstop daemon"
   start-stop-daemon --chuid ${CLAYMORE_USER} --background --chdir ${CLAYMOREHOME} --exec ${DAEMON} --start -- -epool ${EPOOL} -ewal ${WALLET} -mode ${MODE} -di 012
 else
   echo "start daemon command"
   daemon --user="${CLAYMORE_USER}" --pidfile="${PIDFILE}" "${DAEMON} -epool ${EPOOL} -ewal ${WALLET} -mode ${MODE} > /dev/null 2>&1 &"
 fi 
}


do_stop()
{
  kill -9 `ps -u claymore |grep ethdcrminer64 |awk '{printf($1)}'`
}


case "$1" in
  start)
    do_start
    ;;
  stop)
    do_stop
    ;;
  restart)
    do_stop && do_start
    ;;
  *)
    echo "Usage: $SCRIPTNAME {start|stop|restart}" >&2
    exit 3
    ;;
esac









