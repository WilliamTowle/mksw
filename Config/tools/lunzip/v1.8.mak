# lunzip v1.2.4			[ earliest v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-03-18	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_UNLZIP_CONFIG},y)
HAVE_UNLZIP_CONFIG:=y

#DESCRLIST+= "'nti-lunzip' -- lunzip"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${UNLZIP_VERSION},)
UNLZIP_VERSION=1.8
endif

UNLZIP_SRC=${SOURCES}/l/lunzip-${UNLZIP_VERSION}.tar.gz
URLS+= http://download.savannah.gnu.org/releases/lzip/lunzip/lunzip-1.8.tar.gz

#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak


NTI_UNLZIP_TEMP=nti-lunzip-${UNLZIP_VERSION}

NTI_UNLZIP_EXTRACTED=${EXTTEMP}/${NTI_UNLZIP_TEMP}/configure
NTI_UNLZIP_CONFIGURED=${EXTTEMP}/${NTI_UNLZIP_TEMP}/config.status
NTI_UNLZIP_BUILT=${EXTTEMP}/${NTI_UNLZIP_TEMP}/lunzip
NTI_UNLZIP_INSTALLED=${NTI_TC_ROOT}/usr/bin/lunzip


## ,-----
## |	Extract
## +-----

${NTI_UNLZIP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/lunzip-${UNLZIP_VERSION} ] || rm -rf ${EXTTEMP}/lunzip-${UNLZIP_VERSION}
	zcat ${UNLZIP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UNLZIP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UNLZIP_TEMP}
	mv ${EXTTEMP}/lunzip-${UNLZIP_VERSION} ${EXTTEMP}/${NTI_UNLZIP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_UNLZIP_CONFIGURED}: ${NTI_UNLZIP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UNLZIP_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_UNLZIP_BUILT}: ${NTI_UNLZIP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_UNLZIP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_UNLZIP_INSTALLED}: ${NTI_UNLZIP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_UNLZIP_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-lunzip
nti-lunzip: ${NTI_UNLZIP_INSTALLED}

ALL_NTI_TARGETS+= nti-lunzip

endif	# HAVE_UNLZIP_CONFIG
