## smpeg v0.4.5			[ since v0.4.5, c.2017-07-20 ]
## last mod WmT, 2017-08-03	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_SMPEG_CONFIG},y)
HAVE_SMPEG_CONFIG:=y

#DESCRLIST+= "'nti-smpeg' -- smpeg"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${SMPEG_VERSION},)
SMPEG_VERSION=0.4.5
endif

SMPEG_SRC=${SOURCES}/d/distrotech-smpeg-${SMPEG_VERSION}.tar.gz
URLS+= https://github.com/Distrotech/smpeg/archive/distrotech-smpeg-0.4.5.tar.gz

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak

NTI_SMPEG_TEMP=nti-smpeg-${SMPEG_VERSION}

NTI_SMPEG_EXTRACTED=${EXTTEMP}/${NTI_SMPEG_TEMP}/configure
NTI_SMPEG_CONFIGURED=${EXTTEMP}/${NTI_SMPEG_TEMP}/config.log
NTI_SMPEG_BUILT=${EXTTEMP}/${NTI_SMPEG_TEMP}/plaympeg
NTI_SMPEG_INSTALLED=${NTI_TC_ROOT}/usr/bin/plaympeg


# Helpers for external use (post-installation)
SMPEG_CONFIG_TOOL= ${NTI_TC_ROOT}/usr/bin/smpeg-config


## ,-----
## |	Extract
## +-----

${NTI_SMPEG_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	#[ ! -d ${EXTTEMP}/smpeg-${SMPEG_VERSION} ] || rm -rf ${EXTTEMP}/smpeg-${SMPEG_VERSION}
	[ ! -d ${EXTTEMP}/smpeg-distrotech-smpeg-${SMPEG_VERSION} ] || rm -rf ${EXTTEMP}/smpeg-distrotech-smpeg-${SMPEG_VERSION}
	zcat ${SMPEG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_SMPEG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_SMPEG_TEMP}
	#mv ${EXTTEMP}/smpeg-${SMPEG_VERSION} ${EXTTEMP}/${NTI_SMPEG_TEMP}
	mv ${EXTTEMP}/smpeg-distrotech-smpeg-${SMPEG_VERSION} ${EXTTEMP}/${NTI_SMPEG_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_SMPEG_CONFIGURED}: ${NTI_SMPEG_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SMPEG_TEMP} || exit 1 ;\
		sh autogen.sh || exit 1 ;\
		case ${SMPEG_VERSION} in \
		0.4.5) \
			[ -r audio/hufftable.cpp.OLD ] || mv audio/hufftable.cpp audio/hufftable.cpp.OLD || exit 1 ;\
			cat audio/hufftable.cpp.OLD \
				| sed '/"MPEGaudio.h"/		s/^/#include <climits>\n/' \
				| sed '/HUFFMANCODETABLE/,/^}/	s/0-1/UINT_MAX/g' \
				>  audio/hufftable.cpp \
		;; \
		*) \
			echo "Unexpected SMPEG_VERSION ${SMPEG_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac ;\
		LIBTOOL=${LIBTOOL_HOST_TOOL} \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		SDL_CONFIG=${SDL_CONFIG_TOOL} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-gtk-player \
			--disable-opengl-player \
			--with-sdl-prefix=` ${PKG_CONFIG_CONFIG_HOST_TOOL} --variable=prefix sdl ` \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_SMPEG_BUILT}: ${NTI_SMPEG_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SMPEG_TEMP} || exit 1 ;\
		make LIBTOOL=${LIBTOOL_HOST_TOOL} \
	)


## ,-----
## |	Install
## +-----

${NTI_SMPEG_INSTALLED}: ${NTI_SMPEG_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_SMPEG_TEMP} || exit 1 ;\
		make install LIBTOOL=${LIBTOOL_HOST_TOOL} \
	)

##

.PHONY: nti-smpeg
nti-smpeg: nti-autoconf nti-automake \
	nti-SDL \
	${NTI_SMPEG_INSTALLED}

ALL_NTI_TARGETS+= nti-smpeg

endif	# HAVE_SMPEG_CONFIG
