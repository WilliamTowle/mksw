# DirectFB-SDL v1.7.6		[ EARLIEST v0.9.21, c.2009-02-25? ]
# last mod WmT, 2017-04-10	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DIRECTFB_CONFIG},y)
HAVE_DIRECTFB_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-DirectFB' -- DirectFB"

include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

ifeq (${DIRECTFB_VERSION},)
#DIRECTFB_VERSION=1.3.1
#DIRECTFB_VERSION=1.6.3
DIRECTFB_VERSION=1.7.6
endif

DIRECTFB_SRC=${SOURCES}/d/DirectFB-${DIRECTFB_VERSION}.tar.gz
#URLS+= http://www.directfb.net/downloads/Core/DirectFB-1.6/DirectFB-1.6.3.tar.gz
URLS+= http://www.directfb.net/downloads/Core/DirectFB-1.7/DirectFB-1.7.6.tar.gz


# [2017-04-06] v1.2.15 incompatible with modern X11?
include ${CFG_ROOT}/audvid/freetype2/v2.7.1.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.28.mak
include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
include ${CFG_ROOT}/audvid/giflib/v5.0.6.mak
ifeq (${DIRECTFB_WITH_SDL},true)
#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL/v2.0.3.mak
endif
#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak
ifeq (${DIRECTFB_WITH_X11},true)
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
endif

NTI_DIRECTFB_TEMP=nti-DirectFB-${DIRECTFB_VERSION}

NTI_DIRECTFB_EXTRACTED=${EXTTEMP}/${NTI_DIRECTFB_TEMP}/configure
NTI_DIRECTFB_CONFIGURED=${EXTTEMP}/${NTI_DIRECTFB_TEMP}/config.log
NTI_DIRECTFB_BUILT=${EXTTEMP}/${NTI_DIRECTFB_TEMP}/src/libdirectfb.la
NTI_DIRECTFB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/directfb.pc


## ,-----
## |	Extract
## +-----

${NTI_DIRECTFB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/DIRECTFB-${DIRECTFB_VERSION} ] || rm -rf ${EXTTEMP}/DIRECTFB-${DIRECTFB_VERSION}
	zcat ${DIRECTFB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIRECTFB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIRECTFB_TEMP}
	mv ${EXTTEMP}/DirectFB-${DIRECTFB_VERSION} ${EXTTEMP}/${NTI_DIRECTFB_TEMP}


## ,-----
## |	Configure
## +-----

DIRECTFB_CONFIGURE_OPTS= --enable-fbdev
DIRECTFB_DEPS=
ifeq (${DIRECTFB_WITH_SDL},true)
DIRECTFB_CONFIGURE_OPTS = \
			--disable-fbdev \
			--enable-sdl \
			--enable-x11 --disable-x11vdpau
DIRECTFB_DEPS+= nti-SDL
else
DIRECTFB_CONFIGURE_OPTS += --disable-sdl
endif
ifeq (${DIRECTFB_WITH_X11},true)
DIRECTFB_CONFIGURE_OPTS = \
			--disable-fbdev \
			--disable-sdl \
			--enable-x11
DIRECTFB_DEPS+= nti-libX11
else
DIRECTFB_CONFIGURE_OPTS += --disable-x11
endif

${NTI_DIRECTFB_CONFIGURED}: ${NTI_DIRECTFB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		for SD in . lib/direct lib/fusion ; do \
			[ -r $${SD}/Makefile.in.OLD ] || mv $${SD}/Makefile.in $${SD}/Makefile.in.OLD || exit 1 ;\
			cat $${SD}/Makefile.in.OLD \
				| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
				> $${SD}/Makefile.in ;\
		done ;\
		CFLAGS='-O2' \
		  LIBTOOL=${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				${DIRECTFB_CONFIGURE_OPTS} \
				--without-cdda \
				--without-mad \
				--without-timidity \
				--without-vorbis \
				--disable-egl \
				--disable-flux --without-flux \
				--enable-freetype \
				--enable-gif \
				--disable-jpeg \
				--disable-mesa \
				--disable-osx \
				--enable-png \
				--disable-tiff \
				--disable-vnc \
				--disable-zlib \
				--with-gfxdrivers=none \
				--without-tools \
				|| exit 1 ;\
		case ${DIRECTFB_VERSION} in \
		1.6.3|1.7.6) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^SUBDIRS/,// { s/docs	*// }' \
				> Makefile ;\
			[ -r docs/html/Makefile.OLD ] || mv docs/html/Makefile docs/html/Makefile.OLD || exit 1 ;\
			cat docs/html/Makefile.OLD \
				| sed '/^stamp-docs:/,// { s/^	/#needs perl#	/ }' \
				> docs/html/Makefile \
		;; \
		*) \
			echo "[CONFIGURE] Unexpected DIRECTFB_VERSION ${DIRECTFB_VERSION}" 1>&2 ; exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Build
## +-----

${NTI_DIRECTFB_BUILT}: ${NTI_DIRECTFB_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool \
	)


## ,-----
## |	Install
## +-----

${NTI_DIRECTFB_INSTALLED}: ${NTI_DIRECTFB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)
#		mkdir -p ${NTI_TC_ROOT}/etc ;\
#		cp fb.modes ${NTI_TC_ROOT}/etc || exit 1 ;\
#		cp gfxdrivers/davinci/directfbrc ${NTI_TC_ROOT}/etc || exit 1 ;\

##

.PHONY: nti-DirectFB
nti-DirectFB: nti-libtool nti-pkg-config \
	${DIRECTFB_DEPS} \
	nti-freetype2 nti-giflib nti-libpng \
	${NTI_DIRECTFB_INSTALLED}
#	nti-zlib

ALL_NTI_TARGETS+= nti-DirectFB

endif	# HAVE_DIRECTFB_CONFIG
