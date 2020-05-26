# mawk v1.3.4			[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-12-10	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_MAWK_CONFIG},y)
HAVE_MAWK_CONFIG:=y

#DESCRLIST+= "'nti-mawk' -- mawk"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${MAWK_VERSION},)
#MAWK_VERSION=1.3.3
MAWK_VERSION=1.3.4
endif

#MAWK_SRC=${SOURCES}/m/mawk-${MAWK_VERSION}.tar.gz
MAWK_SRC=${SOURCES}/m/mawk-${MAWK_VERSION}.tgz
#URLS+= ftp://invisible-island.net/mawk/mawk-${MAWK_VERSION}.tar.gz
URLS+= ftp://invisible-island.net/mawk/mawk-${MAWK_VERSION}.tgz

NTI_MAWK_TEMP=nti-mawk-${MAWK_VERSION}

NTI_MAWK_EXTRACTED=${EXTTEMP}/${NTI_MAWK_TEMP}/configure
NTI_MAWK_CONFIGURED=${EXTTEMP}/${NTI_MAWK_TEMP}/config.status
NTI_MAWK_BUILT=${EXTTEMP}/${NTI_MAWK_TEMP}/mawk
NTI_MAWK_INSTALLED=${NTI_TC_ROOT}/usr/bin/mawk


## ,-----
## |	Extract
## +-----

${NTI_MAWK_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/mawk-${MAWK_VERSION} ] || rm -rf ${EXTTEMP}/mawk-${MAWK_VERSION}
	zcat ${MAWK_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MAWK_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MAWK_TEMP}
	mv ${EXTTEMP}/mawk-${MAWK_VERSION} ${EXTTEMP}/${NTI_MAWK_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_MAWK_CONFIGURED}: ${NTI_MAWK_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MAWK_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_MAWK_BUILT}: ${NTI_MAWK_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MAWK_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_MAWK_INSTALLED}: ${NTI_MAWK_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_MAWK_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-mawk
nti-mawk: ${NTI_MAWK_INSTALLED}

ALL_NTI_TARGETS+= nti-mawk

endif	# HAVE_MAWK_CONFIG
