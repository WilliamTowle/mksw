## smpeg2 v2.0.0		[ since v2.0.0, c.2017-07-20 ]
## last mod WmT, 2017-07-20	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SMPEG2_CONFIG},y)
HAVE_SMPEG2_CONFIG:=y

#DESCRLIST+= "'nti-smpeg2' -- smpeg2"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${SMPEG2_VERSION},)
SMPEG2_VERSION=2.0.0
endif

SMPEG2_SRC=${SOURCES}/s/smpeg2-${SMPEG2_VERSION}.tar.gz
URLS+= https://www.libsdl.org/projects/smpeg/release/smpeg2-2.0.0.tar.gz

#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/gui/SDL/v2.0.5.mak

NTI_SMPEG2_TEMP=nti-smpeg2-${SMPEG2_VERSION}

NTI_SMPEG2_EXTRACTED=${EXTTEMP}/${NTI_SMPEG2_TEMP}/configure
NTI_SMPEG2_CONFIGURED=${EXTTEMP}/${NTI_SMPEG2_TEMP}/config.log
NTI_SMPEG2_BUILT=${EXTTEMP}/${NTI_SMPEG2_TEMP}/plaympeg
NTI_SMPEG2_INSTALLED=${NTI_TC_ROOT}/usr/bin/plaympeg


## ,-----
## |	Extract
## +-----

${NTI_SMPEG2_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/smpeg2-${SMPEG2_VERSION} ] || rm -rf ${EXTTEMP}/smpeg2-${SMPEG2_VERSION}
	zcat ${SMPEG2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SMPEG2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SMPEG2_TEMP}
	mv ${EXTTEMP}/smpeg2-${SMPEG2_VERSION} ${EXTTEMP}/${NTI_SMPEG2_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SMPEG2_CONFIGURED}: ${NTI_SMPEG2_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SMPEG2_TEMP} || exit 1 ;\
		case ${SMPEG2_VERSION} in \
		2.0.0) \
			[ -r audio/hufftable.cpp.OLD ] || mv audio/hufftable.cpp audio/hufftable.cpp.OLD || exit 1 ;\
			cat audio/hufftable.cpp.OLD \
				| sed '/"MPEGaudio.h"/		s/^/#include <climits>\n/' \
				| sed '/HUFFMANCODETABLE/,/^}/	s/0-1/UINT_MAX/g' \
				>  audio/hufftable.cpp \
		;; \
		*) \
			echo "Unexpected SMPEG2_VERSION ${SMPEG2_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SMPEG2_BUILT}: ${NTI_SMPEG2_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SMPEG2_TEMP} || exit 1 ;\
		make \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_SMPEG2_INSTALLED}: ${NTI_SMPEG2_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SMPEG2_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-smpeg2
nti-smpeg2: \
	nti-SDL \
	${NTI_SMPEG2_INSTALLED}

ALL_NTI_TARGETS+= nti-smpeg2

endif	# HAVE_SMPEG2_CONFIG
