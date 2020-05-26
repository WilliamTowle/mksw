# bison v3.0.4			[ EARLIEST v1.34, c.2002-10-09 ]
# last mod WmT, 2016-01-28	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_BISON_CONFIG},y)
HAVE_BISON_CONFIG:=y

#DESCRLIST+= "'nti-bison' -- bison"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${BISON_VERSION},)
#BISON_VERSION=3.0.2
BISON_VERSION=3.0.4
endif

BISON_SRC=${SOURCES}/b/bison-${BISON_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/bison/bison-${BISON_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/flex/v2.5.37.mak
#include ${CFG_ROOT}/buildtools/m4/v1.4.12.mak
#include ${CFG_ROOT}/buildtools/m4/v1.4.16.mak
include ${CFG_ROOT}/buildtools/m4/v1.4.17.mak


NTI_BISON_TEMP=nti-bison-${BISON_VERSION}

NTI_BISON_EXTRACTED=${EXTTEMP}/${NTI_BISON_TEMP}/configure
NTI_BISON_CONFIGURED=${EXTTEMP}/${NTI_BISON_TEMP}/config.status
NTI_BISON_BUILT=${EXTTEMP}/${NTI_BISON_TEMP}/src/bison
NTI_BISON_INSTALLED=${NTI_TC_ROOT}/usr/bin/bison

## ,-----
## |	Extract
## +-----

${NTI_BISON_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/bison-${BISON_VERSION} ] || rm -rf ${EXTTEMP}/bison-${BISON_VERSION}
	#bzcat ${BISON_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${BISON_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_BISON_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_BISON_TEMP}
	mv ${EXTTEMP}/bison-${BISON_VERSION} ${EXTTEMP}/${NTI_BISON_TEMP}


## ,-----
## |	Configure
## +-----


${NTI_BISON_CONFIGURED}: ${NTI_BISON_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_BISON_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_BISON_BUILT}: ${NTI_BISON_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_BISON_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_BISON_INSTALLED}: ${NTI_BISON_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_BISON_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-bison
nti-bison: nti-m4 nti-flex ${NTI_BISON_INSTALLED}

ALL_NTI_TARGETS+= nti-bison

endif	# HAVE_BISON_CONFIG
