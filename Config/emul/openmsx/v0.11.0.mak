# openmsx v0.11.0		[ EARLIEST v0.5.0, c.2012-12-25 ]
# last mod WmT, 2017-01-03	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_OPENMSX_CONFIG},y)
HAVE_OPENMSX_CONFIG:=y

#DESCRLIST+= "'nti-openmsx' -- openmsx"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

ifeq (${OPENMSX_VERSION},)
#OPENMSX_VERSION=0.5.0
OPENMSX_VERSION=0.11.0
endif
OPENMSX_SRC=${SOURCES}/o/openmsx-${OPENMSX_VERSION}.tar.gz

URLS+= http://heanet.dl.sourceforge.net/sourceforge/openmsx/openmsx-${OPENMSX_VERSION}.tar.gz


NTI_OPENMSX_TEMP=nti-openmsx-${OPENMSX_VERSION}

NTI_OPENMSX_EXTRACTED=${EXTTEMP}/${NTI_OPENMSX_TEMP}/README
NTI_OPENMSX_CONFIGURED=${EXTTEMP}/${NTI_OPENMSX_TEMP}/config.log
NTI_OPENMSX_BUILT=${EXTTEMP}/${NTI_OPENMSX_TEMP}/openmsx
NTI_OPENMSX_INSTALLED=${NTI_TC_ROOT}/usr/bin/openmsx


## ,-----
## |	Extract
## +-----

${NTI_OPENMSX_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/openmsx-${OPENMSX_VERSION} ] || rm -rf ${EXTTEMP}/openmsx-${OPENMSX_VERSION}
	zcat ${OPENMSX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_OPENMSX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_OPENMSX_TEMP}
	mv ${EXTTEMP}/openmsx-${OPENMSX_VERSION} ${EXTTEMP}/${NTI_OPENMSX_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_OPENMSX_CONFIGURED}: ${NTI_OPENMSX_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_OPENMSX_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_OPENMSX_BUILT}: ${NTI_OPENMSX_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_OPENMSX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_OPENMSX_INSTALLED}: ${NTI_OPENMSX_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_OPENMSX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-openmsx
nti-openmsx: ${NTI_OPENMSX_INSTALLED}

ALL_NTI_TARGETS+= nti-openmsx

endif	# HAVE_OPENMSX_CONFIG
