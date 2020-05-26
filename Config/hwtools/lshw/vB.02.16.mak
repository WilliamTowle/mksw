# lshw vB.02.16			[ since vB.02.16, 2013-05-01 ]
# last mod WmT, 2013-05-01	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LSHW_CONFIG},y)
HAVE_LSHW_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-lshw' -- lshw"

ifeq (${LSHW_VERSION},)
LSHW_VERSION=B.02.16
endif

LSHW_SRC=${SOURCES}/l/lshw-${LSHW_VERSION}.tar.gz
URLS+= http://ezix.org/software/files/lshw-B.02.16.tar.gz

#include ${CFG_ROOT}/perl/perl/v5.16.2.mak

NTI_LSHW_TEMP=nti-lshw-${LSHW_VERSION}

NTI_LSHW_EXTRACTED=${EXTTEMP}/${NTI_LSHW_TEMP}/README
NTI_LSHW_CONFIGURED=${EXTTEMP}/${NTI_LSHW_TEMP}/.configure.done
NTI_LSHW_BUILT=${EXTTEMP}/${NTI_LSHW_TEMP}/lshwize
NTI_LSHW_INSTALLED=${NTI_TC_ROOT}/usr/bin/lshwize


## ,-----
## |	Extract
## +-----

${NTI_LSHW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/lshw-${LSHW_VERSION} ] || rm -rf ${EXTTEMP}/lshw-${LSHW_VERSION}
	zcat ${LSHW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LSHW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LSHW_TEMP}
	mv ${EXTTEMP}/lshw-${LSHW_VERSION} ${EXTTEMP}/${NTI_LSHW_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LSHW_CONFIGURED}: ${NTI_LSHW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LSHW_TEMP} || exit 1 ;\
		touch $@ \
	)


## ,-----
## |	Build
## +-----

${NTI_LSHW_BUILT}: ${NTI_LSHW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LSHW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LSHW_INSTALLED}: ${NTI_LSHW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LSHW_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-lshw
nti-lshw: ${NTI_LSHW_INSTALLED}

ALL_NTI_TARGETS+= nti-lshw

endif	# HAVE_LSHW_CONFIG
