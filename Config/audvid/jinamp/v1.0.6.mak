# jinamp v1.0.6			[ EARLIEST v1.0.6, c.2013-02-22 ]
# last mod WmT, 2016-12-25	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_JINAMP_CONFIG},y)
HAVE_JINAMP_CONFIG:=y

#DESCRLIST+= "'nti-jinamp' -- jinamp"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${JINAMP_VERSION},)
JINAMP_VERSION=1.0.6
endif

JINAMP_SRC=${SOURCES}/j/jinamp-${JINAMP_VERSION}.tar.bz2
URLS+= http://downloads.sourceforge.net/project/jinamp/source/1.0.6/jinamp-1.0.6.tar.bz2?r=&ts=1355741775&use_mirror=ignum

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/flex/v2.5.27.mak
#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak
include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak

NTI_JINAMP_TEMP=nti-jinamp-${JINAMP_VERSION}

NTI_JINAMP_EXTRACTED=${EXTTEMP}/${NTI_JINAMP_TEMP}/Makefile
NTI_JINAMP_CONFIGURED=${EXTTEMP}/${NTI_JINAMP_TEMP}/config.log
NTI_JINAMP_BUILT=${EXTTEMP}/${NTI_JINAMP_TEMP}/jinamp
NTI_JINAMP_INSTALLED=${NTI_TC_ROOT}/usr/bin/jinamp


## ,-----
## |	Extract
## +-----

${NTI_JINAMP_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/jinamp-${JINAMP_VERSION} ] || rm -rf ${EXTTEMP}/jinamp-${JINAMP_VERSION}
	bzcat ${JINAMP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_JINAMP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_JINAMP_TEMP}
	mv ${EXTTEMP}/jinamp-${JINAMP_VERSION} ${EXTTEMP}/${NTI_JINAMP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_JINAMP_CONFIGURED}: ${NTI_JINAMP_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JINAMP_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_JINAMP_BUILT}: ${NTI_JINAMP_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JINAMP_TEMP} || exit 1 ;\
		make \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_JINAMP_INSTALLED}: ${NTI_JINAMP_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_JINAMP_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \

##

.PHONY: nti-jinamp
nti-jinamp: nti-flex \
	${NTI_JINAMP_INSTALLED}
#nti-jinamp: nti-libtool ${NTI_JINAMP_INSTALLED}

ALL_NTI_TARGETS+= nti-jinamp

endif	# HAVE_JINAMP_CONFIG
