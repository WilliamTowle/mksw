# time v4.13			[ since v1.7, c.2017-03-03 ]
# last mod WmT, 2017-03-03	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_TIME},y)
HAVE_TIME:=y

#DESCRLIST+= "'nti-time' -- time"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${TIME_VERSION},)
TIME_VERSION=1.7
endif

TIME_SRC=${SOURCES}/t/time-${TIME_VERSION}.tar.gz
URLS+= ftp://ftp.gnu.org/gnu/time/time-1.7.tar.gz

#include [...] no build-time deps

NTI_TIME_TEMP=nti-time-${TIME_VERSION}

NTI_TIME_EXTRACTED=${EXTTEMP}/${NTI_TIME_TEMP}/README
NTI_TIME_CONFIGURED=${EXTTEMP}/${NTI_TIME_TEMP}/config.status
NTI_TIME_BUILT=${EXTTEMP}/${NTI_TIME_TEMP}/time
NTI_TIME_INSTALLED=${NTI_TC_ROOT}/usr/bin/time


## ,-----
## |	Extract
## +-----

${NTI_TIME_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/time-${TIME_VERSION} ] || rm -rf ${EXTTEMP}/time-${TIME_VERSION}
	zcat ${TIME_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TIME_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TIME_TEMP}
	mv ${EXTTEMP}/time-${TIME_VERSION} ${EXTTEMP}/${NTI_TIME_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TIME_CONFIGURED}: ${NTI_TIME_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TIME_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_TIME_BUILT}: ${NTI_TIME_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TIME_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_TIME_INSTALLED}: ${NTI_TIME_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_TIME_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-time
nti-time: ${NTI_TIME_INSTALLED}

ALL_NTI_TARGETS+= nti-time

endif	# HAVE_TIME_CONFIG
