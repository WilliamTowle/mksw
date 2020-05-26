# alsa-tools v1.1.3		[ EARLIEST v1.1.0, ????-??-?? ]
# last mod WmT, 2017-11-10	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_ALSA_TOOLS_CONFIG},y)
HAVE_ALSA_TOOLS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-alsa-tools' -- alsa-tools"

ifeq (${ALSA_TOOLS_VERSION},)
#ALSA_TOOLS_VERSION=1.1.0
ALSA_TOOLS_VERSION=1.1.3
endif

ALSA_TOOLS_SRC=${SOURCES}/a/alsa-tools-${ALSA_TOOLS_VERSION}.tar.bz2
URLS+= ftp://ftp.alsa-project.org/pub/tools/alsa-tools-${ALSA_TOOLS_VERSION}.tar.bz2

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

## Needs fftw from v1.1.0+
#include ${CFG_ROOT}/audvid/alsa-lib/v1.1.0.mak
#include ${CFG_ROOT}/misc/fftw/v3.3.4.mak

NTI_ALSA_TOOLS_TEMP=nti-alsa-tools-${ALSA_TOOLS_VERSION}

NTI_ALSA_TOOLS_EXTRACTED=${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP}/README
NTI_ALSA_TOOLS_CONFIGURED=${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP}/config.log
NTI_ALSA_TOOLS_BUILT=${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP}/aplay/aplay
NTI_ALSA_TOOLS_INSTALLED=${NTI_TC_ROOT}/usr/bin/aplay


## ,-----
## |	Extract
## +-----

${NTI_ALSA_TOOLS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alsa-tools-${ALSA_TOOLS_VERSION} ] || rm -rf ${EXTTEMP}/alsa-tools-${ALSA_TOOLS_VERSION}
	bzcat ${ALSA_TOOLS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP}
	mv ${EXTTEMP}/alsa-tools-${ALSA_TOOLS_VERSION} ${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ALSA_TOOLS_CONFIGURED}: ${NTI_ALSA_TOOLS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP} || exit 1 ;\
		make configure || exit 1 \
	)
#		ls ; echo '...' 1>&2 ; exit 1 ;\
#		CFLAGS='-O2' \
#		  ./configure \
#			--prefix=${NTI_TC_ROOT}/usr \
#			|| exit 1 \


## ,-----
## |	Build
## +-----

${NTI_ALSA_TOOLS_BUILT}: ${NTI_ALSA_TOOLS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP} || exit 1 ;\
		make all \
	)
#		make LIBTOOL=${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_ALSA_TOOLS_INSTALLED}: ${NTI_ALSA_TOOLS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_TOOLS_TEMP} || exit 1 ;\
		make install \
	)
#		make install LIBTOOL=${HOSTSPEC}-libtool \


##

.PHONY: cui-alsa-tools
cui-alsa-tools: cui-alsa-lib ${CUI_ALSA_TOOLS_INSTALLED}
#cui-alsa-tools: cti-libtool cti-pkg-config \
	cui-alsa-lib ${CUI_ALSA_TOOLS_INSTALLED}

ALL_CUI_TARGETS+= cui-alsa-tools


.PHONY: nti-alsa-tools
nti-alsa-tools: \
	${NTI_ALSA_TOOLS_INSTALLED}
#nti-alsa-tools: nti-libtool nti-pkg-config \
#	nti-alsa-lib nti-fftw3 ${NTI_ALSA_TOOLS_INSTALLED}

ALL_NTI_TARGETS+= nti-alsa-tools

endif	# HAVE_ALSA_TOOLS_CONFIG
