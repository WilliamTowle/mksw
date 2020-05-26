# uae vUNKNOWN			[ since v0.8.25, c.2005-04-05 ]
# last mod WmT, 2018-03-05	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_UAE_CONFIG},y)
HAVE_UAE_CONFIG:=y

#DESCRLIST+= "'nti-uae' -- uae (amiga emulator)"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/tools/unzip/v60.mak


ifeq (${UAE_VERSION},)
#UAE_VERSION=0.8.25
#UAE_VERSION=0.8.29
#UAE_VERSION=0.8.29-WIP4
UAE_VERSION=UNKNOWN-janus
#UAE_VERSION=UNKNOWN-keirf
endif

## amigaemulator.org defunct
##URLS+=http://www.amigaemulator.org/files/sources/develop/uae-${UAE_VERSION}.tar.bz2

## ibiblio gentoo mirror also has uae 0.8.29, e-uae 0.8.{28|29-WIP4}
##URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/uae-${UAE_VERSION}.tar.bz2
##URLS+=http://www.amigaemulator.org/files/sources/develop/uae-${UAE_VERSION}.tar.gz
#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/e-uae-${UAE_VERSION}.tar.bz2
URLS+= http://aminet.net/misc/emu/janus-uae-src.tar.gz
#URLS+= https://github.com/keirf/e-uae/archive/master.zip

#UAE_SRC=${SOURCES}/u/uae-${UAE_VERSION}.tar.bz2
#UAE_SRC=${SOURCES}/u/uae-${UAE_VERSION}.tar.gz
#UAE_SRC=${SOURCES}/e/e-uae-${UAE_VERSION}.tar.bz2
UAE_SRC=${SOURCES}/j/janus-uae-src.tar.gz
#UAE_SRC=${SOURCES}/m/master.zip


ifeq (${UAE_WITH_SDL},true)	# see also SDL_WITH_X11
#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/audvid/alsa-lib/v1.1.0.mak
else
#include ${CFG_ROOT}/libX11/v1.2.2.mak
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/audvid/alsa-lib/v1.1.0.mak
endif
#include ${CFG_ROOT}/misc/zlib/v1.2.7.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak


NTI_UAE_TEMP=nti-uae-${UAE_VERSION}

NTI_UAE_EXTRACTED=${EXTTEMP}/${NTI_UAE_TEMP}/configure.in
NTI_UAE_CONFIGURED=${EXTTEMP}/${NTI_UAE_TEMP}/config.status
NTI_UAE_BUILT=${EXTTEMP}/${NTI_UAE_TEMP}/src/uae
NTI_UAE_INSTALLED=${NTI_TC_ROOT}/usr/bin/uae


## ,-----
## |	Extract
## +-----

${NTI_UAE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	#[ ! -d ${EXTTEMP}/uae-${UAE_VERSION} ] || rm -rf ${EXTTEMP}/uae-${UAE_VERSION}
	#[ ! -d ${EXTTEMP}/e-uae-${UAE_VERSION} ] || rm -rf ${EXTTEMP}/e-uae-${UAE_VERSION}
	#[ ! -d ${EXTTEMP}/e-uae-master ] || rm -rf ${EXTTEMP}/e-uae-master
	[ ! -d ${EXTTEMP}/j-uae-1.2 ] || rm -rf ${EXTTEMP}/j-uae-1.2
	#bzcat ${UAE_SRC} | tar xvf - -C ${EXTTEMP}
	zcat ${UAE_SRC} | tar xvf - -C ${EXTTEMP}
	#unzip -d ${EXTTEMP} ${UAE_SRC}
	[ ! -d ${EXTTEMP}/${NTI_UAE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UAE_TEMP}
	#mv ${EXTTEMP}/uae-${UAE_VERSION} ${EXTTEMP}/${NTI_UAE_TEMP}
	#mv ${EXTTEMP}/e-uae-${UAE_VERSION} ${EXTTEMP}/${NTI_UAE_TEMP}
	#mv ${EXTTEMP}/e-uae-master ${EXTTEMP}/${NTI_UAE_TEMP}
	mv ${EXTTEMP}/j-uae-1.2 ${EXTTEMP}/${NTI_UAE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_UAE_CONFIGURED}: ${NTI_UAE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UAE_TEMP} || exit 1 ;\
		case "${UAE_VERSION}" in \
		0.8.29|0.8.29-WIP4) \
			case "${UAE_WITH_SDL}" in \
			true) \
				PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
				PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			  SDL_CONFIG=${NTI_TC_ROOT}/usr/bin/sdl-config \
				./configure \
					--prefix=${NTI_TC_ROOT}/usr \
					--disable-ui --disable-gtktest \
					--with-sdl --with-sdl-gfx \
					--with-alsa \
					--with-zlib=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix zlib ` \
					|| exit 1 \
			;; \
			*) \
				PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
				PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
				CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
				LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
				./configure \
					--prefix=${NTI_TC_ROOT}/usr \
					--disable-ui --disable-gtktest \
					--with-x \
						--x-includes=${NTI_TC_ROOT}/usr/include \
					--with-alsa \
					--with-zlib=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix zlib ` \
					|| exit 1 \
			;; \
			esac \
		;; \
		UNKNOWN-janus) \
			cd janus-uae || exit 1 ;\
			PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
			PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
			LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--disable-ui --disable-gtktest \
				--with-x \
					--x-includes=${NTI_TC_ROOT}/usr/include \
				--with-alsa \
				--with-zlib=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix zlib ` \
				|| exit 1 \
		;; \
		UNKNOWN-keirf) \
			autoconf || exit 1 ;\
			PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
			PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
			LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--disable-ui --disable-gtktest \
				--with-x \
					--x-includes=${NTI_TC_ROOT}/usr/include \
				--with-alsa \
				--with-zlib=` ${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config --variable=prefix zlib ` \
				|| exit 1 \
		;; \
		*) \
			echo "UAE_VERSION: not covered" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


## ,-----
## |	Build
## +-----

${NTI_UAE_BUILT}: ${NTI_UAE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_UAE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_UAE_INSTALLED}: ${NTI_UAE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_UAE_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-uae
ifeq (${UAE_WITH_SDL},true)
#nti-uae: nti-pkg-config \
#	nti-SDL nti-alsa-lib nti-zlib \
#	${NTI_UAE_INSTALLED}
else
#nti-uae: nti-unzip \
#	nti-libX11 nti-alsa-lib nti-zlib \
#	${NTI_UAE_INSTALLED}
nti-uae: \
	nti-libX11 nti-alsa-lib nti-zlib \
	${NTI_UAE_INSTALLED}
endif

ALL_NTI_TARGETS+= nti-uae

endif	# HAVE_UAE_CONFIG
