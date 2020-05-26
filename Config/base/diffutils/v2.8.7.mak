# diffutils v2.8.7		[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-04-30	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_DIFFUTILS_CONFIG},y)
HAVE_DIFFUTILS_CONFIG:=y

#DESCRLIST+= "'nti-diffutils' -- diffutils"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DIFFUTILS_VERSION},)
DIFFUTILS_VERSION=2.8.7
endif

DIFFUTILS_SRC=${SOURCES}/d/diffutils-${DIFFUTILS_VERSION}.tar.gz
URLS+= https://ftp.gnu.org/gnu/diffutils/diffutils-2.7.tar.gz

NTI_DIFFUTILS_TEMP=nti-diffutils-${DIFFUTILS_VERSION}

NTI_DIFFUTILS_EXTRACTED=${EXTTEMP}/${NTI_DIFFUTILS_TEMP}/configure
NTI_DIFFUTILS_CONFIGURED=${EXTTEMP}/${NTI_DIFFUTILS_TEMP}/config.status
NTI_DIFFUTILS_BUILT=${EXTTEMP}/${NTI_DIFFUTILS_TEMP}/src/diffutils
NTI_DIFFUTILS_INSTALLED=${NTI_TC_ROOT}/bin/diffutils


## ,-----
## |	Extract
## +-----

${NTI_DIFFUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION} ] || rm -rf ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION}
	zcat ${DIFFUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIFFUTILS_TEMP}
	mv ${EXTTEMP}/diffutils-${DIFFUTILS_VERSION} ${EXTTEMP}/${NTI_DIFFUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_DIFFUTILS_CONFIGURED}: ${NTI_DIFFUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_DIFFUTILS_BUILT}: ${NTI_DIFFUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_DIFFUTILS_INSTALLED}: ${NTI_DIFFUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIFFUTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-diffutils
nti-diffutils: ${NTI_DIFFUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-diffutils

endif	# HAVE_DIFFUTILS_CONFIG
