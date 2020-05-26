#!/bin/sh

TOOLCHAIN=`pwd`/toolchain

PATH=${TOOLCHAIN}/usr/bin:$PATH
LIBS=${TOOLCHAIN}/usr/lib

##

do_run_amixer()
{
	LD_LIBRARY_PATH=${LIBS} amixer ${1+"$@"}
}

##

COMMAND=$1
[ "${COMMAND}" ] && shift
case ${COMMAND} in
low)
	do_run_amixer set 'Master' 66% unmute
;;
loud)
	do_run_amixer set 'Master' 100% unmute
;;
*)
	do_run_amixer ${1+"$@"}
;;
esac
