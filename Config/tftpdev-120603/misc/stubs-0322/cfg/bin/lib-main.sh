CTRLROOT=`pwd`

find_file()
{
	DIRHINT=$1
	FILEHINT=$2

	case $DIRHINT in
	/*) ;; *) DIRHINT=${CTRLROOT}/${DIRHINT} ;;
	esac

	FILE=''
	while [ -z "$FILE" -a $DIRHINT != $CTRLROOT ] ; do
		if [ -r $DIRHINT/$FILEHINT ] ; then
			FILE="$DIRHINT/$FILEHINT"
		else
			DIRHINT=`dirname $DIRHINT`
		fi
	done

	if [ "$FILE" ] ; then
		echo $FILE
	else
		echo ''
		false
	fi
}

