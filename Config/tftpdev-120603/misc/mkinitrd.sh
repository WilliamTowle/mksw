#!/bin/sh

# Where 'tftpdev' is
[ "${TCMF}" ] || TCMF=./Makefile

do_maketc()
{
	if [ ! -r ${TCMF} ] ; then
		echo "Toolchain Makefile ${TCMF} not found" 1>&2
		exit 1
	fi

	( cd `dirname ${TCMF}` && make Config/fstools/genext2fs/v1.4.1.mak ACTION=buildn ) || exit 1
}

do_makerd()
{
	FSNAME=$1
	if [ -z "${FSNAME}" ] ; then
		echo "do_makerd(): Missing FSNAME[, ...]" 1>&2
		exit 1
	fi
	shift

	FSSIZE_KB=$1
	if [ -z "${FSSIZE_KB}" ] ; then
		echo "do_makerd(): Missing FSSIZE_KB[, ...]" 1>&2
		exit 1
	fi
	shift

	FSROOT=$1
	if [ -z "${FSROOT}" ] ; then
		echo "do_makerd(): Missing FSROOT" 1>&2
		exit 1
	fi
	shift

	[ -r ${FSNAME}-devs.txt ] || cat >${FSNAME}-devs.txt <<EOF
# name		type mode uid gid major minor start inc count
/dev		d    755  0    0    -    -    -    -    -
/dev/console	c    600  0    0    5    1    0    0    -
/dev/hda	b    640  0    0    3    0    0    0    -
/dev/hda	b    640  0    0    3    1    1    1    4
/dev/mem	c    640  0    0    1    1    0    0    -
/dev/loop	b    640  0    0    7    0    0    1    2
/dev/null	c    666  0    0    1    3    0    0    -
/dev/ram0	c    660  0    0    1    0    0    0    -
/dev/tty	c    666  0    0    5    0    0    0    -
/dev/tty	c    666  0    0    4    0    0    1    6
/dev/zero	c    666  0    0    1    5    0    0    -
EOF

	echo "[Creating empty image...]"
	dd if=/dev/zero of=${FSNAME} count=${FSSIZE_KB} bs=1k
	echo "[Populating image...]"
	`dirname ${TCMF}`/toolchain/usr/bin/genext2fs -d ${FSROOT} -D ${FSNAME}-devs.txt -b ${FSSIZE_KB} -q -m 5 ${FSNAME} || exit 1
}

ACTION=$1
shift
case ${ACTION} in
maketc)
	do_maketc || exit 1
	echo "$0: ${ACTION} OK"
;;
makerd)
	do_makerd $* || exit 1
	echo "$0: ${ACTION} OK"
;;
*)	if [ "${ACTION}" -a "${ACTION}" != 'help' ] ; then
		echo "$0: Unrecognised command '${ACTION}'" 1>&2
	fi
	echo "$0: Usage:" 1>&2
	grep "^[0-9a-z-]*)" $0 | sed "s/^/	/" 1>&2
	exit 1
;;
esac
