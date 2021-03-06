#!/bin/sh

MIN_TFTPDEV=tftpdev-110117
TFTPDEV_METAFILE=Config/META/mkiso.mak
# '0', '2', '4' (no compiler; gccv2; gccv4)
[ "${NATIVE_GCC_VERMAJ}" ] || NATIVE_GCC_VERMAJ=0

## handle ISO image creation

do_make_fs()
{
	FSIMAGE=$1
	FSROOTDIR=$2

	if [ -z "${FSIMAGE}" ] ; then
		echo "$0: do_make_fs(): Need FSIMAGE and FSROOTDIR" 1>&2
		exit 1
	fi

	if [ -z "${FSROOTDIR}" ] ; then
		echo "$0: do_make_fs(): Need FSROOTDIR" 1>&2
		exit 1
	elif [ ! -d ${FSROOTDIR} ] ; then
		echo "$0: do_make_fs(): FSROOTDIR ${FSROOTDIR} not directory" 1>&2
		exit 1
	fi

	MKISOFS=toolchain/usr/bin/mkisofs
	echo "Checking for MKISOFS ${MKISOFS}..."
	if [ ! -x ${MKISOFS} ] ; then
		echo "$0: No mkisofs executable"
		exit 1
	fi

	BOOTPATH=boot/isolinux
	SYSLDIR=toolchain/etc/syslinux
	echo "Checking for isolinux.bin in FSROOTDIR ${FSROOTDIR}..."
	if [ ! -r ${FSROOTDIR}/${BOOTPATH}/isolinux.bin ] ; then
		echo "Copying isolinux.bin from SYSLDIR ${SYSLDIR}..."
		cp ${SYSLDIR}/isolinux.bin ${FSROOTDIR}/${BOOTPATH} || exit 1
	fi
	echo

	echo "Writing..."
	${MKISOFS} \
		-rational-rock -o ${FSIMAGE} \
		-b ${BOOTPATH}/isolinux.bin -c ${BOOTPATH}/boot.cat \
		-no-emul-boot -boot-load-size 4 -boot-info-table \
		${FSROOTDIR} || exit 1
	echo

	echo "Advice..."
	BQ='`'
	cat <<EOF
#ISO FILE ${FSIMAGE} NOW BUILT :)
#
#See ${BQ}cdrecord -scanbus${BQ} as root to identify device and characteristics
#...and burn image with ${BQ}cdrecord -v speed=8 dev=0,4,0 -data
#	${FSIMAGE}${BQ}
EOF
}

## handle building toolchain

do_make_tc()
{
	[ "$1" ] && MIN_TFTPDEV=$1
	if [ ! -d ${MIN_TFTPDEV} ] ; then
		echo "$0: MIN_TFTPDEV ${MIN_TFTPDEV}: Not a directory" 1>&2
		exit 1
	fi

	make -C ${MIN_TFTPDEV} ${TFTPDEV_METAFILE} EXTTEMP=${PWD}/exttemp TC_ROOT=${PWD}/toolchain SRCDIR=${PWD}/source ACTION=buildn NATIVE_GCC_VERMAJ=${NATIVE_GCC_VERMAJ}
}

do_show_urls()
{
	[ "$1" ] && MIN_TFTPDEV=$1
	if [ ! -d ${MIN_TFTPDEV} ] ; then
		echo "$0: MIN_TFTPDEV ${MIN_TFTPDEV}: Not a directory" 1>&2
		exit 1
	fi

	make -C ${MIN_TFTPDEV} ${TFTPDEV_METAFILE} ACTION=show-urls-n NATIVE_GCC_VERMAJ=${NATIVE_GCC_VERMAJ}
}

if [ "$1" = 'show-urls' ] ; then
	shift
	do_show_urls ${1+"$@"}
elif [ "$1" = 'maketc' ] ; then
	shift
	do_make_tc ${1+"$@"}
elif [ "$1" = 'makefs' ] ; then
	shift
	do_make_fs ${1+"$@"}
else
	echo "$0: show-urls|maketc [DIRNAME]" 1>&2
	echo "$0: makefs FSIMG FSROOTDIR" 1>&2
	exit 1
fi
