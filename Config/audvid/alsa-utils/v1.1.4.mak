# alsa-utils v1.1.4		[ EARLIEST v1.0.9, ????-??-?? ]
# last mod WmT, 2017-11-10	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_ALSA_UTILS_CONFIG},y)
HAVE_ALSA_UTILS_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-alsa-utils' -- alsa-utils"

ifeq (${ALSA_UTILS_VERSION},)
#ALSA_UTILS_VERSION=1.0.9
#ALSA_UTILS_VERSION=1.0.25
#ALSA_UTILS_VERSION=1.0.27.2
#ALSA_UTILS_VERSION=1.0.28
#ALSA_UTILS_VERSION=1.0.29
#ALSA_UTILS_VERSION=1.1.0
#ALSA_UTILS_VERSION=1.1.2
ALSA_UTILS_VERSION=1.1.4
endif

ALSA_UTILS_SRC=${SOURCES}/a/alsa-utils-${ALSA_UTILS_VERSION}.tar.bz2
URLS+= ftp://ftp.alsa-project.org/pub/utils/alsa-utils-${ALSA_UTILS_VERSION}.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

# Needs fftw from v1.1.0+
#include ${CFG_ROOT}/audvid/alsa-lib/v1.1.2.mak
include ${CFG_ROOT}/audvid/alsa-lib/v1.1.4.1.mak
#include ${CFG_ROOT}/misc/fftw/v3.3.4.mak
include ${CFG_ROOT}/misc/fftw/v3.3.6-pl1.mak
#include ${CFG_ROOT}/tui/ncurses/v5.6.mak


NTI_ALSA_UTILS_TEMP=nti-alsa-utils-${ALSA_UTILS_VERSION}

NTI_ALSA_UTILS_EXTRACTED=${EXTTEMP}/${NTI_ALSA_UTILS_TEMP}/README
NTI_ALSA_UTILS_CONFIGURED=${EXTTEMP}/${NTI_ALSA_UTILS_TEMP}/config.log
NTI_ALSA_UTILS_BUILT=${EXTTEMP}/${NTI_ALSA_UTILS_TEMP}/aplay/aplay
NTI_ALSA_UTILS_INSTALLED=${NTI_TC_ROOT}/usr/bin/aplay


## ,-----
## |	Extract
## +-----

${NTI_ALSA_UTILS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/alsa-utils-${ALSA_UTILS_VERSION} ] || rm -rf ${EXTTEMP}/alsa-utils-${ALSA_UTILS_VERSION}
	bzcat ${ALSA_UTILS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP}
	mv ${EXTTEMP}/alsa-utils-${ALSA_UTILS_VERSION} ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP}


## ,-----
## |	Configure
## +-----

# v1.0.25: curses dependency in test/example programs?
# v1.0.27.2: --disable-alsatest (requires: libasound)
# v1.1.0: fix bat/signal.h reinclusion failure under hbOS

${NTI_ALSA_UTILS_CONFIGURED}: ${NTI_ALSA_UTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP} || exit 1 ;\
		case ${ALSA_UTILS_VERSION} in \
		1.1.0) \
			[ -r bat/signal.h.OLD ] || mv bat/signal.h bat/signal.h.OLD || exit 1 ;\
			cat bat/signal.h.OLD \
				| sed '/sin_generator_init/	s%^%#ifndef __BAT_SIGNAL_H__\n#define __BAT_SIGNAL_H__\n\n%' \
				| sed '/sin_generator_init/	s/^/#include "common.h"\n\n/' \
				| sed '/generate_sine_wave/	s%$$%\n\n#endif	/* __BAT_SIGNAL_H__ */%' \
				> bat/signal.h ;\
			[ -r bat/common.h.OLD ] || mv bat/common.h bat/common.h.OLD || exit 1 ;\
			cat bat/common.h.OLD \
				| sed '/asoundlib.h/	s%^%#ifndef __BAT_COMMON_H__\n#define __BAT_COMMON_H__\n\n%' \
				| sed '/asoundlib.h/	s/$$/\n#include <stdbool.h>\n/' \
				| sed '/struct sin_generator;/	{ s%^%/* % ; s%$$% */% } '\
				| sed '/write_wav_header/	s%$$%\n\n#endif	/* __BAT_COMMON_H__ */%' \
				> bat/common.h \
		;; \
		esac ;\
		CFLAGS='-O2 -I../' \
		  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --with-alsa-inc-prefix=${NTI_TC_ROOT}/usr/include \
			  --with-alsa-prefix=${NTI_TC_ROOT}/usr/lib \
			  --disable-xmlto \
			  --without-udev-rules-dir \
			  --without-asound-state-dir \
			  --disable-alsamixer \
			  --disable-alsaconf \
			  --disable-alsaloop \
			  --disable-alsatest \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ALSA_UTILS_BUILT}: ${NTI_ALSA_UTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_ALSA_UTILS_INSTALLED}: ${NTI_ALSA_UTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

##

.PHONY: cui-alsa-utils
cui-alsa-utils: cui-alsa-lib \
		${CUI_ALSA_UTILS_INSTALLED}
#cui-alsa-utils: cti-libtool cti-pkg-config \
#		cui-alsa-lib \
#		${CUI_ALSA_UTILS_INSTALLED}

ALL_CUI_TARGETS+= cui-alsa-utils


.PHONY: nti-alsa-utils
nti-alsa-utils: nti-libtool nti-pkg-config \
		nti-alsa-lib nti-fftw3 \
		${NTI_ALSA_UTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-alsa-utils

endif	# HAVE_ALSA_UTILS_CONFIG
