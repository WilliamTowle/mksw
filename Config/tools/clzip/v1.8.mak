# clzip v1.2.4			[ earliest v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-03-18	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_CLZIP_CONFIG},y)
HAVE_CLZIP_CONFIG:=y

#DESCRLIST+= "'nti-clzip' -- clzip"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${CLZIP_VERSION},)
CLZIP_VERSION=1.8
endif

CLZIP_SRC=${SOURCES}/c/clzip-${CLZIP_VERSION}.tar.gz
URLS+= http://download.savannah.gnu.org/releases/lzip/clzip/clzip-1.8.tar.gz

#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak


NTI_CLZIP_TEMP=nti-clzip-${CLZIP_VERSION}

NTI_CLZIP_EXTRACTED=${EXTTEMP}/${NTI_CLZIP_TEMP}/configure
NTI_CLZIP_CONFIGURED=${EXTTEMP}/${NTI_CLZIP_TEMP}/config.status
NTI_CLZIP_BUILT=${EXTTEMP}/${NTI_CLZIP_TEMP}/clzip
NTI_CLZIP_INSTALLED=${NTI_TC_ROOT}/usr/bin/clzip


## ,-----
## |	Extract
## +-----

${NTI_CLZIP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/clzip-${CLZIP_VERSION} ] || rm -rf ${EXTTEMP}/clzip-${CLZIP_VERSION}
	zcat ${CLZIP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_CLZIP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_CLZIP_TEMP}
	mv ${EXTTEMP}/clzip-${CLZIP_VERSION} ${EXTTEMP}/${NTI_CLZIP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_CLZIP_CONFIGURED}: ${NTI_CLZIP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_CLZIP_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_CLZIP_BUILT}: ${NTI_CLZIP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_CLZIP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_CLZIP_INSTALLED}: ${NTI_CLZIP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_CLZIP_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-clzip
nti-clzip: ${NTI_CLZIP_INSTALLED}

ALL_NTI_TARGETS+= nti-clzip

endif	# HAVE_CLZIP_CONFIG
