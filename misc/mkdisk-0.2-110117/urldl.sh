#!/bin/sh

do_copy()
{
	if [ -z "$1" ] ; then
		echo "$0: do_copy(): Expected SOURCEDIR[, ...]" 1>&2
		exit 1
	elif [ -z "$2" ] ; then
		echo "$0: do_copy(): Expected OLDSOURCEDIR" 1>&2
		exit 1
	elif [ -t 0 ] ; then
		# isatty - not allowed
		echo "$0: Need URLs on STDIN" 1>&2
		exit 1
	fi

	SOURCEDIR=$1
	OLDSOURCEDIR=$2

	FAILS=n
	while read INPUTLINE ; do
		case ${INPUTLINE} in
		make:*) # ignore
		;;
		*)
			URL=`echo ${INPUTLINE} | sed 's/.* //'`
			case ${URL} in
			*.bz2|*.gz)
				ARCHIVE=`basename $URL`
			;;
			*)
				echo "$0: Unhandled URL format: ${URL}" 1>&2
				exit 1
			;;
			esac

			ORIG_DIR=${OLDSOURCEDIR}/`echo ${ARCHIVE} | sed 's/\(.\).*/\1/' | tr 'A-Z' 'a-z'`
			TARG_DIR=${SOURCEDIR}/`echo ${ARCHIVE} | sed 's/\(.\).*/\1/' | tr 'A-Z' 'a-z'`

			[ -d ${TARG_DIR} ] || mkdir -p ${TARG_DIR}
			[ -r ${TARG_DIR}/${ARCHIVE} ] || cp ${ORIG_DIR}/${ARCHIVE} ${TARG_DIR}/${ARCHIVE} || FAILS=y
		;;
		esac
	done

	if [ "${FAILS}" != 'n' ] ; then
		echo "$0: WARNING: Some copy creation failed" 1>&2
		find ${SOURCEDIR} -empty | while read FILE ; do
			echo "$0: WARNING: ${FILE} is zero bytes" 1>&2
		done
		exit 1
	fi
}

do_download()
{
	if [ -z "$1" ] ; then
		echo "$0: Expected SOURCEDIR" 1>&2
		exit 1
	elif [ -t 0 ] ; then
		# isatty - not allowed
		echo "$0: Need URLs on STDIN" 1>&2
		exit 1
	fi
	SOURCEDIR=$1
	shift

	FAILS=n
	while read INPUTLINE ; do
		case ${INPUTLINE} in
		make:*) # ignore
		;;
		*)
			URL=`echo ${INPUTLINE} | sed 's/.* //'`
			case ${URL} in
			*.bz2|*.gz)
				ARCHIVE=`basename $URL`
			;;
			*)
				echo "$0: Unhandled URL format: ${URL}" 1>&2
				exit 1
			;;
			esac

			TARG_DIR=${SOURCEDIR}/`echo ${ARCHIVE} | sed 's/\(.\).*/\1/' | tr 'A-Z' 'a-z'`

			[ -d ${TARG_DIR} ] || mkdir -p ${TARG_DIR}
			[ -r ${TARG_DIR}/${ARCHIVE} ] || wget ${URL} -O ${TARG_DIR}/${ARCHIVE} || FAILS=y
		;;
		esac
	done

	if [ "${FAILS}" != 'n' ] ; then
		echo "$0: WARNING: Some downloads failed" 1>&2
		find ${SOURCEDIR} -empty | while read FILE ; do
			echo "$0: WARNING: ${FILE} is zero bytes" 1>&2
		done
		exit 1
	fi
}

ACTION=$1
[ "${ACTION}" ] && shift
case ${ACTION} in
download)	## acquire sources from web -- UNTESTED
	do_download ${1+"$@"}
	echo "$0: DOWNLOAD phase OK"
;;
copy)		## acquire sources from CD/old download tree
	do_copy ${1+"$@"}
	echo "$0: COPY phase OK"
;;
*)	if [ "${ACTION}" -a "${ACTION}" != 'help' ] ; then
		echo "$0: Unrecognised command '${ACTION}'"
	fi
	echo "$0: Usage:" 1>&2
	grep "^[0-9a-z-]*)" $0 | sed "s/^/	/" 1>&2
	exit 1
;;
esac
