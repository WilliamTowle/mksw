# coreutils v8.22		[ since v?.?.?, c.????-??-?? ]
# last mod WmT, 2014-04-30	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_COREUTILS_CONFIG},y)
HAVE_COREUTILS_CONFIG:=y

#DESCRLIST+= "'nti-coreutils' -- coreutils"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${COREUTILS_VERSION},)
#COREUTILS_VERSION=5.97
COREUTILS_VERSION=8.22
endif

#COREUTILS_SRC=${SOURCES}/c/coreutils-${COREUTILS_VERSION}.tar.bz2
COREUTILS_SRC=${SOURCES}/c/coreutils-${COREUTILS_VERSION}.tar.xz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/coreutils/coreutils-${COREUTILS_VERSION}.tar.xz

NTI_COREUTILS_TEMP=nti-coreutils-${COREUTILS_VERSION}

NTI_COREUTILS_EXTRACTED=${EXTTEMP}/${NTI_COREUTILS_TEMP}/configure
NTI_COREUTILS_CONFIGURED=${EXTTEMP}/${NTI_COREUTILS_TEMP}/config.status
NTI_COREUTILS_BUILT=${EXTTEMP}/${NTI_COREUTILS_TEMP}/src/yes
NTI_COREUTILS_INSTALLED=${NTI_TC_ROOT}/bin/yes


## ,-----
## |	Extract
## +-----

${NTI_COREUTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/coreutils-${COREUTILS_VERSION} ] || rm -rf ${EXTTEMP}/coreutils-${COREUTILS_VERSION}
	#bzcat ${COREUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${COREUTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_COREUTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_COREUTILS_TEMP}
	mv ${EXTTEMP}/coreutils-${COREUTILS_VERSION} ${EXTTEMP}/${NTI_COREUTILS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_COREUTILS_CONFIGURED}: ${NTI_COREUTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_COREUTILS_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT} \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_COREUTILS_BUILT}: ${NTI_COREUTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_COREUTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_COREUTILS_INSTALLED}: ${NTI_COREUTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_COREUTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-coreutils
nti-coreutils: ${NTI_COREUTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-coreutils

endif	# HAVE_COREUTILS_CONFIG
