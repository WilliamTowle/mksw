# gzip v1.2.4			[ earliest v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-03-18	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_GZIP_CONFIG},y)
HAVE_GZIP_CONFIG:=y

#DESCRLIST+= "'nti-gzip' -- gzip"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${GZIP_VERSION},)
GZIP_VERSION=1.2.4a
endif

GZIP_SRC=${SOURCES}/g/gzip-${GZIP_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/gzip/gzip-${GZIP_VERSION}.tar.gz


#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak

NTI_GZIP_TEMP=nti-gzip-${GZIP_VERSION}

NTI_GZIP_EXTRACTED=${EXTTEMP}/${NTI_GZIP_TEMP}/configure
NTI_GZIP_CONFIGURED=${EXTTEMP}/${NTI_GZIP_TEMP}/config.status
NTI_GZIP_BUILT=${EXTTEMP}/${NTI_GZIP_TEMP}/gzexe
NTI_GZIP_INSTALLED=${NTI_TC_ROOT}/usr/bin/gzip


## ,-----
## |	Extract
## +-----

${NTI_GZIP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/gzip-${GZIP_VERSION} ] || rm -rf ${EXTTEMP}/gzip-${GZIP_VERSION}
	zcat ${GZIP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_GZIP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_GZIP_TEMP}
	mv ${EXTTEMP}/gzip-${GZIP_VERSION} ${EXTTEMP}/${NTI_GZIP_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_GZIP_CONFIGURED}: ${NTI_GZIP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_GZIP_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_GZIP_BUILT}: ${NTI_GZIP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_GZIP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_GZIP_INSTALLED}: ${NTI_GZIP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_GZIP_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-gzip
nti-gzip: ${NTI_GZIP_INSTALLED}

ALL_NTI_TARGETS+= nti-gzip

endif	# HAVE_GZIP_CONFIG
