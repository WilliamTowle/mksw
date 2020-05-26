# fbzx v2.10.0			[ EARLIEST v?.?? ]
# last mod WmT, 2017-03-01	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_FBZX_CONFIG},y)
HAVE_FBZX_CONFIG:=y

#DESCRLIST+= "'nti-fbzx' -- fbzx"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${FBZX_VERSION},)
FBZX_VERSION=2.10.0
endif

FBZX_SRC=${SOURCES}/f/fbzx-${FBZX_VERSION}.tar.bz2
#FBZX_SRC=${SOURCES}/f/fbzx_${FBZX_VERSION}.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/fbzx-2.10.0.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/contrib/f/fbzx/fbzx_2.10.0.orig.tar.gz
#URLS+= http://www.rastersoft.com/descargas/fbzx-${FBZX_VERSION}.tar.bz2

#include ${CFG_ROOT}/audvid/alsa-lib/v1.0.25.mak
#include ${CFG_ROOT}/audvid/alsa-lib/v1.0.27.2.mak
#include ${CFG_ROOT}/audvid/alsa-lib/v1.1.0.mak
include ${CFG_ROOT}/audvid/alsa-lib/v1.1.2.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak


NTI_FBZX_TEMP=nti-fbzx-${FBZX_VERSION}

NTI_FBZX_EXTRACTED=${EXTTEMP}/${NTI_FBZX_TEMP}/README
NTI_FBZX_CONFIGURED=${EXTTEMP}/${NTI_FBZX_TEMP}/Makefile.OLD
NTI_FBZX_BUILT=${EXTTEMP}/${NTI_FBZX_TEMP}/fbzx
NTI_FBZX_INSTALLED=${NTI_TC_ROOT}/usr/bin/fbzx


## ,-----
## |	Extract
## +-----

${NTI_FBZX_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/fbzx-${FBZX_VERSION} ] || rm -rf ${EXTTEMP}/fbzx-${FBZX_VERSION}
	bzcat ${FBZX_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${FBZX_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FBZX_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FBZX_TEMP}
	mv ${EXTTEMP}/fbzx-${FBZX_VERSION} ${EXTTEMP}/${NTI_FBZX_TEMP}


## ,-----
## |	Configure
## +-----

# using sdl-config so -I path doesn't include 'SDL' dir

${NTI_FBZX_CONFIGURED}: ${NTI_FBZX_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBZX_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
		cat Makefile.OLD \
			| sed '/^ifdef PREFIX/	s%^%PREFIX='${NTI_TC_ROOT}'\n%' \
			| sed '/^CFLAGS/	s%^%CC=gcc\n%' \
			| sed '/^CFLAGS/	s%`.*`%`'${NTI_TC_ROOT}'/usr/bin/sdl-config --cflags` `'${NTI_TC_ROOT}'/usr/bin/'${HOSTSPEC}'-pkg-config --cflags alsa`%' \
			| sed '/^CFLAGS/	{ s/-D *D_SOUND_PULSE// ; s/-D *D_SOUND_OSS// }' \
			| sed '/^LDFLAGS/	s%`.*`%`'${NTI_TC_ROOT}'/usr/bin/sdl-config --libs` `'${NTI_TC_ROOT}'/usr/bin/'${HOSTSPEC}'-pkg-config --libs alsa`%' \
			> Makefile || exit 1 ;\
		[ -r computer.c.OLD ] || mv computer.c computer.c.OLD || exit 1 ;\
		cat computer.c.OLD \
			| sed '/byte bus_empty/		s/^inline //' \
			| sed '/void emulate/		s/^inline //' \
			| sed '/void paint_one_pixel/	s/^inline //' \
			| sed '/void read_keyboard/	s/^inline //' \
			> computer.c || exit 1 ;\
		[ -r spk_ay.c.OLD ] || mv spk_ay.c spk_ay.c.OLD || exit 1 ;\
		cat spk_ay.c.OLD \
			| sed '/void play_ay/		s/^inline //' \
			| sed '/void play_sound/	s/^inline //' \
			> spk_ay.c || exit 1 ;\
		[ -r tape.c.OLD ] || mv tape.c tape.c.OLD || exit 1 ;\
		cat tape.c.OLD \
			| sed '/void tape_read/		s/^inline //' \
			> tape.c || exit 1 ;\
	)


## ,-----
## |	Build
## +-----

${NTI_FBZX_BUILT}: ${NTI_FBZX_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBZX_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_FBZX_INSTALLED}: ${NTI_FBZX_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_FBZX_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-fbzx
nti-fbzx: nti-SDL nti-alsa-lib ${NTI_FBZX_INSTALLED}

ALL_NTI_TARGETS+= nti-fbzx

endif	# HAVE_FBZX_CONFIG
