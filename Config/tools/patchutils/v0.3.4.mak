# patchutils v0.3.2		[ since v0.2.12, c.2004-03-23 ]
# last mod WmT, 2017-08-22	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_PATCHUTILS_CONFIG},y)
HAVE_PATCHUTILS_CONFIG:=y

#DESCRLIST+= "'nti-patchutils' -- patchutils"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2...
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.29.2.mak
# unzip? xzcat? 

ifeq (${PATCHUTILS_VERSION},)
#PATCHUTILS_VERSION=0.3.2
PATCHUTILS_VERSION=0.3.4
endif

#PATCHUTILS_SRC=${SOURCES}/p/patchutils-${PATCHUTILS_VERSION}.tar.bz2
PATCHUTILS_SRC=${SOURCES}/p/patchutils-${PATCHUTILS_VERSION}.tar.xz
#URLS+= http://cyberelk.net/tim/data/patchutils/stable/patchutils-${PATCHUTILS_VERSION}.tar.bz2
URLS+= http://cyberelk.net/tim/data/patchutils/stable/patchutils-${PATCHUTILS_VERSION}.tar.xz

#include ${CFG_ROOT}/misc/libiconv/v1.12.mak
#include ${CFG_ROOT}/misc/libiconv/v1.14.mak

NTI_PATCHUTILS_TEMP=nti-patchutils-${PATCHUTILS_VERSION}

NTI_PATCHUTILS_EXTRACTED=${EXTTEMP}/${NTI_PATCHUTILS_TEMP}/README
NTI_PATCHUTILS_CONFIGURED=${EXTTEMP}/${NTI_PATCHUTILS_TEMP}/config.status
NTI_PATCHUTILS_BUILT=${EXTTEMP}/${NTI_PATCHUTILS_TEMP}/src/rediff
NTI_PATCHUTILS_INSTALLED=${NTI_TC_ROOT}/usr/bin/rediff


## ,-----
## |	Extract
## +-----

${NTI_PATCHUTILS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/patchutils-${PATCHUTILS_VERSION} ] || rm -rf ${EXTTEMP}/patchutils-${PATCHUTILS_VERSION}
	#bzcat ${PATCHUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${PATCHUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_PATCHUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PATCHUTILS_TEMP}
	mv ${EXTTEMP}/patchutils-${PATCHUTILS_VERSION} ${EXTTEMP}/${NTI_PATCHUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_PATCHUTILS_CONFIGURED}: ${NTI_PATCHUTILS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_PATCHUTILS_TEMP} || exit 1 ;\
		    CFLAGS='-O2' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_PATCHUTILS_BUILT}: ${NTI_PATCHUTILS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_PATCHUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_PATCHUTILS_INSTALLED}: ${NTI_PATCHUTILS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_PATCHUTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-patchutils
#nti-patchutils: nti-libtool nti-libiconv ${NTI_PATCHUTILS_INSTALLED}
nti-patchutils: \
	${NTI_PATCHUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-patchutils

endif	# HAVE_PATCHUTILS_CONFIG
