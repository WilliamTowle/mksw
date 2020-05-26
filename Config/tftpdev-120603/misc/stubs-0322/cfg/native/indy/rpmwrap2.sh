#!/bin/sh

##
##	subroutines
##

do_init()
{
	ROOTDIR=$1
	if [ -z "$ROOTDIR" ] ; then
		echo "$0: INIT: No ROOTDIR supplied"
		exit 1
	elif [ ! -d $ROOTDIR ] ; then
		echo "$0: INIT: ROOTDIR $ROOTDIR unsuitable/does not exist"
		exit 1
	else
		shift
	fi

	[ -d $ROOTDIR/var/lib/rpm ] || mkdir -p $ROOTDIR/var/lib/rpm
	run_rpm $ROOTDIR --initdb || exit 1
}

do_install()
{
	ROOTDIR=$1
	if [ -z "$ROOTDIR" ] ; then
		echo "$0: INSTALL: No ROOTDIR supplied"
		exit 1
	elif [ ! -d $ROOTDIR ] ; then
		echo "$0: INSTALL: ROOTDIR $ROOTDIR unsuitable/does not exist"
		exit 1
	else
		shift
	fi

	LIST=$1
	if [ -z "$LIST" ] ; then
		echo "$0: No 'LIST' supplied"
		exit 1
	else
		shift
	fi

	verify_setup $ROOTDIR mklx-mips || exit 1

	PKGDIR=`pwd`/packages/rpm
	for FILE in `grep -v '^#' $LIST` ; do
		ARCH=`basename ${FILE} | sed 's/^[a-z]*[0-9\.-]*//' | sed 's/\.rpm$//'`
	
		RPM=${PKGDIR}/${ARCH}/${FILE}
		ARGS=" --install --hash --percent --force --force --ignorearch --nodeps --noscripts ${RPM} "
		echo
		echo "[ ${RPM} ]"
		run_rpm ${ROOTDIR} $ARGS
	done
}

verify_setup()
{
	ROOTDIR=$1
	BINDIR=$2

	if [ ! -r $ROOTDIR/var/lib/rpm/Packages ] ; then
		echo "$0: ROOTDIR $ROOTDIR not initialised"
		exit 1
	fi

	if [ ! -x $BINDIR/bin/rpm ] ; then
		echo "$0: BINDIR $BINDIR missing 'rpm' executable"
		exit 1
	fi

	if [ "$UID" != 0 -a "$UID" ] ; then
		echo "$0: You are not 'root'"
		exit 1
	fi
}

run_rpm()
{
	ROOTDIR=$1
	if [ -z "$ROOTDIR" ] ; then
		echo "$0: Expected ROOTDIR"
		exit 1
	elif [ ! -d $ROOTDIR ] ; then
		echo "$0: Expected ROOTDIR $ROOTDIR to be directory"
		exit 1
	else
		shift
	fi

	case $ROOTDIR in
	/*)	;;
	*)	ROOTDIR=`pwd`/${ROOTDIR}
	esac
	mklx-mips/bin/rpm --root=$ROOTDIR $*
}

##
##	main program
##

COMMAND=$1
[ "$COMMAND" ] && shift

case $COMMAND in
init)		## initialise database in given ROOTDIR
	do_init $* || exit 1
	echo "$0: INIT phase OK"
	;;
install)	## populate ROOTDIR with given LIST
	do_install $* || exit 1
	echo "$0: INSTALL phase OK"
	;;
passargs)	## pass ARGUMENT(s) to rpm
	run_rpm $* || exit 1
	;;
*)
	if [ -n "$COMMAND" -a "$COMMAND" != 'help' ] ; then
		echo "$0: Unrecognised command '$COMMAND'"
	fi
	echo "$0: Usage:"
	grep "^[0-9a-z]*)" $0 | sed "s/^/	/"
	exit 1
	;;
esac
