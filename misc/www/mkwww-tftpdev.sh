#!/bin/sh

MIN_TFTPDEV=tftpdev-110228
TFTPDEV_METAFILE=Config/META/perl-www.mak
NATIVE_GCC_VERMAJ=0

PERLVER=`perl --version | sed -n 's/.*v\([0-9.]*\).*for \([^ ]*\)$/\1 \2/ p'`

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

	make -C ${MIN_TFTPDEV} ${TFTPDEV_METAFILE} ACTION=show-urls-n NATIVE_GCC_VERMAJ=0
}

do_make_page()
{
	if [ -d toolchain ] ; then
		TFTPDEV_TC=`pwd`/toolchain
		LIB1=` printf '%s/usr/lib/perl5/site_perl/%s/%s/' ${TFTPDEV_TC} ${PERLVER} `
		LIB2=` dirname ${LIB1}`
		PERL="perl -I${LIB1} -I${LIB2}"

		export PATH=${TFTPDEV_TC}/usr/bin:${PATH}
	elif [ -d bin ] ; then
		export PATH=`pwd`/bin:${PATH}
	fi

	TPAGE=`which tpage 2>/dev/null`
	if [ -z "${TPAGE}" ] ; then
		echo "$0: Required executable 'tpage' not PATHed" 1>&2
		exit 1
	fi

	if [ -z "$1" ] ; then
		echo "$0: No PAGE" 1>&2
		exit 1
	else
		FILE=$1
		( cd `dirname ${FILE}` && ${PERL} ${TPAGE} `basename ${FILE}` )
	fi
}

do_make_site()
{
	if [ -d toolchain ] ; then
		TFTPDEV_TC=`pwd`/toolchain
		LIB1=` printf '%s/usr/lib/perl5/site_perl/%s/%s/' ${TFTPDEV_TC} ${PERLVER} `
		LIB2=` dirname ${LIB1}`
		PERL="perl -I${LIB1} -I${LIB2}"

		export PATH=${TFTPDEV_TC}/usr/bin:${PATH}
	elif [ -d bin ] ; then
		export PATH=`pwd`/bin:${PATH}
	fi

	TPAGE=`which tpage 2>/dev/null`
	if [ -z "${TPAGE}" ] ; then
		echo "$0: Required executable 'tpage' not PATHed" 1>&2
		exit 1
	fi

	HTMLDIR=`pwd`/html
	if [ ! -d ${HTMLDIR} ] ; then
		echo "$0: Cannot produce output: HTMLDIR ${HTMLDIR} missing" 1>&2
		exit 1
	fi

	if [ -z "$1" ] ; then
		echo "$0: No TMPLTREE param" 1>&2
		exit 1
	fi
	TMPLTREE=$1
	shift

	( cd ${TMPLTREE} || exit 1
		for SUBDIR in tt2 extra ; do
			if [ -d ${SUBDIR} ] ; then
				find ${SUBDIR}/* -type d | while read DIR ; do
					DIRNAME=`echo ${DIR} | sed "s%${SUBDIR}/%${HTMLDIR}/%"`
					mkdir -p "${DIRNAME}" || exit 1
				done || exit 1

				find ${SUBDIR} -type f | while read FILE ; do
					OUTFILE=`echo ${FILE} | sed "s%${SUBDIR}/%${HTMLDIR}/%" | sed 's%\.tmpl%.html%'`
					case ${FILE} in
					*.tmpl)	( ${PERL} ${TPAGE} "${FILE}" > "${OUTFILE}" ) 2>&1 | sed "s%^%${FILE}: %" || exit 1
					;;
					*.sh.in)	# ignore
					;;
					*)	cp "${FILE}" "${OUTFILE}"
					;;
					esac
				done || exit 1
			fi || exit 1
		done || exit 1
		echo "OK"
	)
}


ACTION=$1
shift
case ${ACTION} in
show-urls)
	do_show_urls ${1+"$@"}
;;
maketc)
	do_make_tc ${1+"$@"}
;;
makepage)
	do_make_page ${1+"$@"}
;;
makesite)
	do_make_site ${1+"$@"}
;;
*)	if [ "${ACTION}" -a "${ACTION}" != 'help' ] ; then
		echo "$0: Unrecognised command '${ACTION}'" 1>&2
	fi
	echo "$0: Usage:" 1>&2
	grep "^[0-9a-z-]*)" $0 | sed "s/^/	/" 1>&2
	exit 1
;;
esac
