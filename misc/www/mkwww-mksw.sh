#!/bin/sh

#MIN_MKSW=mksw-170308
MIN_MKSW=mksw-170326

[ -z ${MKSW_VER} ] && MKSW_VER=${MIN_MKSW}

[ -d ${PWD}/${MKSW_VER} ] && MKSW_VER=${PWD}/${MKSW_VER}
#TFTPDEV_METAFILE=Config/META/perl-www.mak
MKWWW_METAFILE=${MKSW_VER}/Config/ENV/mkwww.mak

CDPATH=''

do_make_tc()
{
	if [ ! -d ${MKSW_VER} ] ; then
		echo "$0: MKSW_VER ${MKSW_VER}: Not a directory" 1>&2
		exit 1
	fi

	make -C ${MKSW_VER} META=${MKWWW_METAFILE} EXTTEMP=${PWD}/exttemp NTI_TC_ROOT=${PWD}/toolchain SOURCES=${PWD}/source all-nti
}

do_show_urls()
{
	if [ ! -d ${MKSW_VER} ] ; then
		echo "$0: MKSW_VER ${MKSW_VER}: Not a directory" 1>&2
		exit 1
	fi

	make -C ${MKSW_VER} show-urls META=${MKWWW_METAFILE}
}

do_make_page()
{
	if [ -d toolchain ] ; then
		TFTPDEV_TC=`pwd`/toolchain
		PERL_VER=`perl --version | awk '/This/ { print $4 }' | sed 's/^v//'`
		PERL_ARCH=`perl --version | awk '/This/ { print $8 }'`
		case ${PERL_ARCH} in
		x86_64*)
			PERL="perl -I${TFTPDEV_TC}/usr/lib64/perl5/ -I${TFTPDEV_TC}/usr/share/perl5/"
			;;
		*)
			PERL="perl -I${TFTPDEV_TC}/usr/lib/perl5/site_perl/${PERL_VER}/${PERL_ARCH}/ -I${TFTPDEV_TC}/usr/lib/perl5/site_perl/${PERL_VER}/"
		esac

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
		PERL_VER=`perl --version | awk '/This/ { print $4 }' | sed 's/^v//'`
		PERL_ARCH=`perl --version | awk '/This/ { print $8 }'`
		case ${PERL_ARCH} in
		x86_64*)
			PERL="perl -I${TFTPDEV_TC}/usr/lib64/perl5/ -I${TFTPDEV_TC}/usr/share/perl5/"
			;;
		*)
			PERL="perl -I${TFTPDEV_TC}/usr/lib/perl5/site_perl/${PERL_VER}/${PERL_ARCH}/ -I${TFTPDEV_TC}/usr/lib/perl5/site_perl/${PERL_VER}/"
		esac

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
	else
		TMPLTREE=$1
		shift
	fi

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


[ "$1" ] && ACTION=$1 && shift
case ${ACTION} in
show-urls)
	do_show_urls
;;
maketc)
	do_make_tc
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
