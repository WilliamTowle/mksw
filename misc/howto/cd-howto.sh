#!/bin/sh
##	status		(c)1999-2006 William Towle
##	Last modified	12/07/2006, WmT
##	Purpose		configuration management
#
#   Open Source software - copyright and GPLv2 apply. Briefly:
#	- No warranty/guarantee of fitness, use is at own risk
#	- No restrictions on strictly-private use/copying/modification
#	- This license must apply also to all modified/derived works
#	- Redistributing? Include/offer to deliver original source
#   Philosophy/full details at http://www.gnu.org/copyleft/gpl.html

do_scan()
{
	sudo cdrecord -scanbus
}

do_isofs_howto()
{
	cat << EOF
mkisofs -r -o \${ISO}
	-b \${BOOTPATH}/isolinux.bin -c \${BOOTPATH}/boot.cat
	-no-emul-boot -boot-load-size 4 -boot-info-table
	\${MASTERDIR}

	-R - use Rock Ridge extensions
	-r - use "rational" Rock Ridge - sane UID/GID/read bits
	-J - use Joliet extensions
EOF
}

do_audio_howto()
{
	cat << EOF
Write audio to disk (CDDA, or other with extension)
	[sudo] cdrecord -v speed=8 dev=1,4,0 -audio [files]
EOF
}

do_burn_howto()
{
	cat << EOF
Write ISO to disk:
	[sudo] cdrecord -v speed=8 dev=1,4,0 -data \${ISO}
EOF
}
ACTION=$1
[ "$1" ] && shift
case ${ACTION} in
scan)	## identify devices and characteristics
	do_scan $*
;;
audio-howto)	## command to write music
	do_audio_howto $*
;;
burn-howto)	## command to write disk
	do_burn_howto $*
;;
isofs-howto)	## command to write image
	do_isofs_howto $*
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
