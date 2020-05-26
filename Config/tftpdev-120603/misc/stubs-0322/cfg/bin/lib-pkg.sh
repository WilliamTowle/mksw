do_extract()
{
	ARCHIVE=$1
	DIRECTORY=$2

	case $ARCHIVE in
	*.tar.bz2)
		cat $ARCHIVE | bzip2 -d | ( cd $DIRECTORY && tar xvf - )
		;;
	*.tar.gz|*.tgz)
		cat $ARCHIVE | gzip -d -c | ( cd $DIRECTORY && tar xvf - )
		;;
	*)
		echo "$0: Internal error - ARCHIVE $ARCHIVE not handled"
	esac
}
