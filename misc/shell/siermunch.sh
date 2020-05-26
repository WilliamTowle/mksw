#!/bin/bash

TLIM=$1
if [ -z "${TLIM}" ] ; then
	echo "$0: Expected TLIM" 1>&2
	exit 1
fi
shift

plot()
{
	R=$(($1 + 1))
	C=$(($2 + 1))

	echo -n "[${R};${C}H$"
}

unplot()
{
	R=$(($1 + 1))
	C=$(($2 + 1))

	echo -n "[${R};${C}H:"
}

clear
for T in `seq 0 ${TLIM}` ; do
	for X in `seq 0 ${TLIM}` ; do
		Y=$(( $X ^ $T ))
		if [ $(( $X & $T )) == 0 ] ; then plot $Y $X ; else unplot $Y $X ; fi
		usleep $(( 100000 / ($TLIM * $TLIM) )) 2>/dev/null
	done
done
