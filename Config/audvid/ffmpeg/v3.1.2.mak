# ffmpeg v3.1.2			[ since v0.5.1, c.2010-10-13 ]
# last mod WmT, 2016-08-18	[ (c) and GPLv2 1999-2016* ]

ifneq (${HAVE_FFMPEG_CONFIG},y)
HAVE_FFMPEG_CONFIG:=y

#DESCRLIST+= "'nti-ffmpeg' -- ffmpeg"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${FFMPEG_VERSION},)
#FFMPEG_VERSION=0.5.1
#FFMPEG_VERSION=1.1.3
#FFMPEG_VERSION=2.6.3
#FFMPEG_VERSION=2.7.1
#FFMPEG_VERSION=2.8
#FFMPEG_VERSION=2.8.2
#FFMPEG_VERSION=2.8.3
FFMPEG_VERSION=3.1.2
endif
FFMPEG_SRC=${SOURCES}/f/ffmpeg-${FFMPEG_VERSION}.tar.bz2

URLS+= http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2

#include ${CFG_ROOT}/buildtools/yasm/v1.2.0.mak
#include ${CFG_ROOT}/buildtools/nasm/v2.11.08.mak
include ${CFG_ROOT}/buildtools/nasm/v2.12.mak
include ${CFG_ROOT}/audvid/lame/v3.99.5.mak

NTI_FFMPEG_TEMP=nti-ffmpeg-${FFMPEG_VERSION}

NTI_FFMPEG_EXTRACTED=${EXTTEMP}/${NTI_FFMPEG_TEMP}/configure
NTI_FFMPEG_CONFIGURED=${EXTTEMP}/${NTI_FFMPEG_TEMP}/config.log
NTI_FFMPEG_BUILT=${EXTTEMP}/${NTI_FFMPEG_TEMP}/ffmpeg
NTI_FFMPEG_INSTALLED=${NTI_TC_ROOT}/usr/bin/ffmpeg


## ,-----
## |	Extract
## +-----

${NTI_FFMPEG_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/ffmpeg-${FFMPEG_VERSION} ] || rm -rf ${EXTTEMP}/ffmpeg-${FFMPEG_VERSION}
	bzcat ${FFMPEG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FFMPEG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FFMPEG_TEMP}
	mv ${EXTTEMP}/ffmpeg-${FFMPEG_VERSION} ${EXTTEMP}/${NTI_FFMPEG_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_FFMPEG_CONFIGURED}: ${NTI_FFMPEG_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FFMPEG_TEMP} || exit 1 ;\
		CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-libmp3lame \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_FFMPEG_BUILT}: ${NTI_FFMPEG_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FFMPEG_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FFMPEG_INSTALLED}: ${NTI_FFMPEG_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FFMPEG_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-ffmpeg
#nti-ffmpeg: nti-yasm ${NTI_FFMPEG_INSTALLED}
nti-ffmpeg: nti-nasm \
		nti-lame ${NTI_FFMPEG_INSTALLED}

ALL_NTI_TARGETS+= nti-ffmpeg

endif	# HAVE_FFMPEG_CONFIG
