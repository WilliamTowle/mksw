# cdrkit v4.0.18		[ since v3.9.9, c.2003-05-28 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_CDRKIT_CONFIG},y)
HAVE_CDRKIT_CONFIG:=y

#DESCRLIST+= "'nti-cdrkit' -- cdrkit"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${CDRKIT_VERSION},)
CDRKIT_VERSION=1.1.11
endif

CDRKIT_SRC=${SOURCES}/c/cdrkit_${CDRKIT_VERSION}.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/cdrkit/cdrkit_1.1.11.orig.tar.gz

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_CDRKIT_TEMP=nti-cdrkit-${CDRKIT_VERSION}

NTI_CDRKIT_EXTRACTED=${EXTTEMP}/${NTI_CDRKIT_TEMP}/configure
NTI_CDRKIT_CONFIGURED=${EXTTEMP}/${NTI_CDRKIT_TEMP}/config.status
NTI_CDRKIT_BUILT=${EXTTEMP}/${NTI_CDRKIT_TEMP}/cdrkit
NTI_CDRKIT_INSTALLED=${NTI_TC_ROOT}/usr/bin/cdrkit


## ,-----
## |	Extract
## +-----

${NTI_CDRKIT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/cdrkit-${CDRKIT_VERSION} ] || rm -rf ${EXTTEMP}/cdrkit-${CDRKIT_VERSION}
	zcat ${CDRKIT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CDRKIT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CDRKIT_TEMP}
	mv ${EXTTEMP}/cdrkit-${CDRKIT_VERSION} ${EXTTEMP}/${NTI_CDRKIT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CDRKIT_CONFIGURED}: ${NTI_CDRKIT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CDRKIT_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  CC=${NTI_GCC} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_CDRKIT_BUILT}: ${NTI_CDRKIT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CDRKIT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CDRKIT_INSTALLED}: ${NTI_CDRKIT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CDRKIT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-cdrkit
nti-cdrkit: ${NTI_CDRKIT_INSTALLED}

ALL_NTI_TARGETS+= nti-cdrkit

endif	# HAVE_CDRKIT_CONFIG
