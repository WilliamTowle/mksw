# findutils v4.2.29		[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-06-10	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_FINDUTILS_CONFIG},y)
HAVE_FINDUTILS_CONFIG:=y

#DESCRLIST+= "'nti-findutils' -- findutils"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${FINDUTILS_VERSION},)
FINDUTILS_VERSION=4.2.29
endif

FINDUTILS_SRC=${SOURCES}/f/findutils-${FINDUTILS_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/findutils/findutils-4.2.29.tar.gz

NTI_FINDUTILS_TEMP=nti-findutils-${FINDUTILS_VERSION}

NTI_FINDUTILS_EXTRACTED=${EXTTEMP}/${NTI_FINDUTILS_TEMP}/configure
NTI_FINDUTILS_CONFIGURED=${EXTTEMP}/${NTI_FINDUTILS_TEMP}/config.status
NTI_FINDUTILS_BUILT=${EXTTEMP}/${NTI_FINDUTILS_TEMP}/find/find
NTI_FINDUTILS_INSTALLED=${NTI_TC_ROOT}/bin/find


## ,-----
## |	Extract
## +-----

${NTI_FINDUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/findutils-${FINDUTILS_VERSION} ] || rm -rf ${EXTTEMP}/findutils-${FINDUTILS_VERSION}
	zcat ${FINDUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FINDUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FINDUTILS_TEMP}
	mv ${EXTTEMP}/findutils-${FINDUTILS_VERSION} ${EXTTEMP}/${NTI_FINDUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FINDUTILS_CONFIGURED}: ${NTI_FINDUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FINDUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FINDUTILS_BUILT}: ${NTI_FINDUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FINDUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FINDUTILS_INSTALLED}: ${NTI_FINDUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FINDUTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-findutils
nti-findutils: ${NTI_FINDUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-findutils

endif	# HAVE_FINDUTILS_CONFIG
