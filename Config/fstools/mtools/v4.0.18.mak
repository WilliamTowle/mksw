# mtools v4.0.18		[ since v3.9.9, c.2003-05-28 ]
# last mod WmT, 2014-02-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_MTOOLS_CONFIG},y)
HAVE_MTOOLS_CONFIG:=y

#DESCRLIST+= "'nti-mtools' -- mtools"
#DESCRLIST+= "'cti-mtools' -- mtools"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MTOOLS_VERSION},)
#MTOOLS_VERSION=4.0.12
#MTOOLS_VERSION=4.0.13
#MTOOLS_VERSION=4.0.16
MTOOLS_VERSION=4.0.18
endif

MTOOLS_SRC=${SOURCES}/m/mtools-${MTOOLS_VERSION}.tar.bz2
URLS+= ftp://ftp.gnu.org/gnu/mtools/mtools-${MTOOLS_VERSION}.tar.bz2

NTI_MTOOLS_TEMP=nti-mtools-${MTOOLS_VERSION}

NTI_MTOOLS_EXTRACTED=${EXTTEMP}/${NTI_MTOOLS_TEMP}/configure
NTI_MTOOLS_CONFIGURED=${EXTTEMP}/${NTI_MTOOLS_TEMP}/config.status
NTI_MTOOLS_BUILT=${EXTTEMP}/${NTI_MTOOLS_TEMP}/mtools
NTI_MTOOLS_INSTALLED=${NTI_TC_ROOT}/usr/bin/mtools


## ,-----
## |	Extract
## +-----

${NTI_MTOOLS_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/mtools-${MTOOLS_VERSION} ] || rm -rf ${EXTTEMP}/mtools-${MTOOLS_VERSION}
	bzcat ${MTOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MTOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MTOOLS_TEMP}
	mv ${EXTTEMP}/mtools-${MTOOLS_VERSION} ${EXTTEMP}/${NTI_MTOOLS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MTOOLS_CONFIGURED}: ${NTI_MTOOLS_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MTOOLS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  CC=${NTI_GCC} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_MTOOLS_BUILT}: ${NTI_MTOOLS_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MTOOLS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_MTOOLS_INSTALLED}: ${NTI_MTOOLS_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MTOOLS_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-mtools
nti-mtools: ${NTI_MTOOLS_INSTALLED}

ALL_NTI_TARGETS+= nti-mtools

endif	# HAVE_MTOOLS_CONFIG
