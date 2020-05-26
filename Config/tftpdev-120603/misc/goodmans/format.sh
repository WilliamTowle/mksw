#!/bin/sh

SFDISK=/sbin/sfdisk
MKFS=/sbin/mkfs.msdos
FSCK=/sbin/fsck.msdos

do_status()
{
	DEVICE=$1
	if [ -z "${DEVICE}" ] ; then
		echo "$0: do_status(): Expected DEVICE" 1>&2
		exit 1
	else
		shift
	fi

	if [ ! -O ${SFDISK} ] ; then
		echo "$0: Not root" 1>&2
		exit 1
	fi

	${SFDISK} -l ${DEVICE}
}

do_dumppt()
{
	DEVICE=$1
	if [ -z "${DEVICE}" ] ; then
		echo "$0: do_dumppt(): Expected DEVICE argument" 1>&2
		exit 1
	else
		shift
	fi

	TMPFILE=$1
	if [ -z "${TMPFILE}" ] ; then
		echo "$0: do_dumppt(): No TMPFILE" 1>&2
		exit 1
	else
		shift
	fi

	if [ ! -O ${SFDISK} ] ; then
		echo "$0: Not root" 1>&2
		exit 1
	fi

	dd if=${DEVICE} of=${TMPFILE} bs=512 count=1 2>/dev/null
	ls -la ${TMPFILE}
}

do_makept()
{
	DEVICE=$1
	if [ -z "${DEVICE}" ] ; then
		echo "$0: do_makept(): Expected DEVICE argument" 1>&2
		exit 1
	else
		shift
	fi

	if [ ! -O ${SFDISK} ] ; then
		echo "$0: Not root" 1>&2
		exit 1
	fi

	OK=y
	(
		GEOM=`${SFDISK} -G ${DEVICE} 2>/dev/null | sed 's/[^0-9 ]//g'`
		set -- $GEOM
		CYLS=$1

		echo "Blanking existing partition table..."
		dd if=/dev/zero of =${DEVICE} bs=512 count=1 2>/dev/null
		echo "Writing new partition table..."
		echo "1,"$((${CYLS} - 1))",6,-" | ${SFDISK} -D ${DEVICE}
	) || OK=n
	[ ${OK} = 'y' ] || false
}

do_makefs()
{
	DEVICE=$1
	if [ -z "${DEVICE}" ] ; then
		echo "$0: do_makefs(): Expected DEVICE argument" 1>&2
		exit 1
	else
		shift
	fi

	TMPDIR=$1
	if [ -z "${TMPDIR}" ] ; then
		echo "$0: do_makefs(): Expected TMPDIR argument" 1>&2
		exit 1
	elif [ ! -d "${TMPDIR}" ] ; then
		echo "$0: do_makefs(): TMPDIR not directory" 1>&2
		exit 1
	else
		shift
	fi

	OK=y
	(
		# trash the partition's idea of its own size
		${ECHO} dd if=/dev/zero of=${DEVICE}1 bs=512 count=1

		# -F -> force 16 bit FAT (no FAT32 support on device)
		# -s -> sectors per cluster (-s 64 -> 32768 bytes)
		# -S -> logical sector size (-S 32768)
		#${ECHO} ${MKFS} -t msdos -c -F 16 -S 32768 ${DEVICE}1 || exit 1
		${ECHO} ${MKFS} -F 16 -s 64 ${DEVICE}1 || exit 1

		${ECHO} mount -t vfat ${DEVICE}1 ${TMPDIR} || exit 1
		${ECHO} mkdir ${TMPDIR}/CONFIG
		${ECHO} touch ${TMPDIR}/CONFIG/CONFIG.TCC
		${ECHO} touch ${TMPDIR}/CONFIG/BRWSDB.TCC
		${ECHO} mkdir ${TMPDIR}/MUSIC ${TMPDIR}/VOICE
		${ECHO} umount ${TMPDIR}
	) || OK=n
	[ ${OK} = 'y' ] || false
}

do_fsck()
{
	DEVICE=$1
	if [ -z "${DEVICE}" ] ; then
		echo "$0: do_makefs(): Expected DEVICE argument" 1>&2
		exit 1
	else
		shift
	fi

	if [ ! -O ${SFDISK} ] ; then
		echo "$0: Not root" 1>&2
		exit 1
	fi

	# fsck.msdos
	# -t -> mark unreadable clusters as bad
	# -w -> write changes to disk immediately
	${FSCK} -twa ${DEVICE}1
}

ACTION=$1
[ "$1" ] && shift
case ${ACTION} in
status)		## show status of DEVICE
	do_status $* || exit 1
;;
dumppt)		## dump DEVICE's partition table (dd ... of=TMPFILE)
	do_dumppt $* || exit 1
;;
makept)		## (re)create DEVICE's partition table
	do_makept $* || exit 1
;;
makefs)		## make DEVICE's filesystem and directories
	do_makefs $* || exit 1
;;
fsck)		## file system check
	do_fsck $* || exit 1
;;
*)
	if [ -n "${ACTION}" -a "${ACTION}" != 'help' ] ; then
		echo "$0: Unrecognised command '${ACTION}'"
	fi
	echo "$0: Usage:"
	grep "^[0-9a-z][0-9a-z|-]*)" $0 | sed "s/^/	/"
	exit 1
;;
esac
