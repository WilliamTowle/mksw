# tar v1.13			[ earliest v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-03-18	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_TAR_CONFIG},y)
HAVE_TAR_CONFIG:=y

#DESCRLIST+= "'nti-tar' -- tar"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${TAR_VERSION},)
TAR_VERSION=1.13
endif

TAR_SRC=${SOURCES}/t/tar-${TAR_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/pub/gnu/tar/tar-1.13.tar.gz


#include ${CFG_ROOT}/buildtools/flex/v2.5.35.mak

NTI_TAR_TEMP=nti-tar-${TAR_VERSION}

NTI_TAR_EXTRACTED=${EXTTEMP}/${NTI_TAR_TEMP}/configure
NTI_TAR_CONFIGURED=${EXTTEMP}/${NTI_TAR_TEMP}/config.status
NTI_TAR_BUILT=${EXTTEMP}/${NTI_TAR_TEMP}/src/tar
NTI_TAR_INSTALLED=${NTI_TC_ROOT}/usr/bin/tar


## ,-----
## |	Extract
## +-----

${NTI_TAR_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/tar-${TAR_VERSION} ] || rm -rf ${EXTTEMP}/tar-${TAR_VERSION}
	zcat ${TAR_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_TAR_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_TAR_TEMP}
	mv ${EXTTEMP}/tar-${TAR_VERSION} ${EXTTEMP}/${NTI_TAR_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_TAR_CONFIGURED}: ${NTI_TAR_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_TAR_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
			./configure --prefix=${NTI_TC_ROOT}/usr \
			  || exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_TAR_BUILT}: ${NTI_TAR_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_TAR_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_TAR_INSTALLED}: ${NTI_TAR_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_TAR_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-tar
nti-tar: ${NTI_TAR_INSTALLED}

ALL_NTI_TARGETS+= nti-tar

endif	# HAVE_TAR_CONFIG
