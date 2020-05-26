# alsa-utils v1.0.25		[ EARLIEST v?.?? ]
# last mod WmT, 2012-11-08	[ (c) and GPLv2 1999-2012 ]

ifneq (${HAVE_ALSA_UTILS_CONFIG},y)
HAVE_ALSA_UTILS_CONFIG:=y

#DESCRLIST+= "'nti-alsa-utils' -- alsa-utils"
#
#include ${CFG_ROOT}/ENV/ifbuild.env
#include ${CFG_ROOT}/ENV/native.mak
##include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/audvid/alsa-lib/v1.0.25.mak
#include ${CFG_ROOT}/tui/ncurses/v5.6.mak

ifeq (${ALSA_UTILS_VERSION},)
#ALSA_UTILS_VERSION=1.0.9
ALSA_UTILS_VERSION=1.0.25
endif
ALSA_UTILS_SRC=${SOURCES}/a/alsa-utils-${ALSA_UTILS_VERSION}.tar.bz2

URLS+= ftp://ftp.alsa-project.org/pub/utils/alsa-utils-${ALSA_UTILS_VERSION}.tar.bz2

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

# FIXME: CURSES_CFLAGS
${NTI_ALSA_UTILS_CONFIGURED}: ${NTI_ALSA_UTILS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
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
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ALSA_UTILS_BUILT}: ${NTI_ALSA_UTILS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ALSA_UTILS_INSTALLED}: ${NTI_ALSA_UTILS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ALSA_UTILS_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-alsa-utils
nti-alsa-utils: nti-alsa-lib ${NTI_ALSA_UTILS_INSTALLED}
#nti-alsa-utils: nti-alsa-lib nti-ncurses ${NTI_ALSA_UTILS_INSTALLED}

ALL_NTI_TARGETS+= nti-alsa-utils

endif	# HAVE_ALSA_UTILS_CONFIG
