# uae v0.8.29			[ since v0.8.25, c.2005-04-05 ]
# last mod WmT, 2013-01-12	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_UAE_CONFIG},y)
HAVE_UAE_CONFIG:=y

#DESCRLIST+= "'nti-uae' -- uae (amiga emulator)"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${UAE_VERSION},)
#UAE_VERSION=0.8.25
#UAE_VERSION=0.8.29
UAE_VERSION=0.8.29-WIP4
endif

#UAE_SRC=${SOURCES}/u/uae-${UAE_VERSION}.tar.bz2
#UAE_SRC=${SOURCES}/u/uae-${UAE_VERSION}.tar.gz
UAE_SRC=${SOURCES}/e/e-uae-${UAE_VERSION}.tar.bz2

# NB. gentoo mirror also has uae 0.8.29 and e-uae 0.8.28
#URLS+=http://www.amigaemulator.org/files/sources/develop/uae-${UAE_VERSION}.tar.bz2
#URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/uae-${UAE_VERSION}.tar.bz2
#URLS+=http://www.amigaemulator.org/files/sources/develop/uae-${UAE_VERSION}.tar.gz
URLS+= http://www.mirrorservice.org/sites/www.ibiblio.org/gentoo/distfiles/e-uae-${UAE_VERSION}.tar.bz2
#gone: http://www.amigaemulator.org/files/sources/develop/e-uae-${UAE_VERSION}.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${UAE_WITH_SDL},true)
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/audvid/alsa-lib/v1.1.0.mak
else
#include ${CFG_ROOT}/libX11/v1.2.2.mak
include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/audvid/alsa-lib/v1.1.0.mak
endif
#include ${CFG_ROOT}/misc/zlib/v1.2.7.mak
include ${CFG_ROOT}/misc/zlib/v1.2.8.mak


NTI_UAE_TEMP=nti-uae-${UAE_VERSION}

NTI_UAE_EXTRACTED=${EXTTEMP}/${NTI_UAE_TEMP}/configure
NTI_UAE_CONFIGURED=${EXTTEMP}/${NTI_UAE_TEMP}/config.status
NTI_UAE_BUILT=${EXTTEMP}/${NTI_UAE_TEMP}/src/uae
NTI_UAE_INSTALLED=${NTI_TC_ROOT}/usr/bin/uae


#	ifeq (${UAE_WITH_SDL},true)
#	
#	# TODO: double-check these!
#	# with --enable-gui:
#	# v0.8.25|26: no gui_display() (when no gtk+?)
#	# v0.8.27: nogui.c gui_init() - type conflict with gui.h
#	# v0.8.28|29: undefined references, including gui_message()
#	else
#	# 0.8.25|26: no gui_display() with/without --enable-ui
#	endif
#
#...	
#	
#	##	package extract
#	
#	HTC_UAE_TEMP=htc-uae-${UAE_VERSION}
#	
#	HTC_UAE_EXTRACTED=${EXTTEMP}/${HTC_UAE_TEMP}/Makefile
#	
#	.PHONY: htc-uae-extracted
#	
#	htc-uae-extracted: ${HTC_UAE_EXTRACTED}
#	
#	${HTC_UAE_EXTRACTED}:
#		[ ! -d ${EXTTEMP}/${HTC_UAE_TEMP} ] || rm -rf ${EXTTEMP}/${HTC_UAE_TEMP}
#		make -C ${TOPLEV} extract ARCHIVE=${UAE_SRC}
#		case ${UAE_VERSION} in \
#		*WIP*) \
#			mv ${EXTTEMP}/e-uae-${UAE_VERSION} ${EXTTEMP}/${HTC_UAE_TEMP} \
#		;; \
#		*) \
#			mv ${EXTTEMP}/uae-${UAE_VERSION} ${EXTTEMP}/${HTC_UAE_TEMP} \
#		;; \
#		esac
#		( cd ${EXTTEMP}/${HTC_UAE_TEMP} || exit 1 ;\
#			case ${UAE_VERSION} in \
#			0.8.25) \
#				zcat ${SRCDIR}/u/uae_0.8.25-6ubuntu1.diff.gz | patch -Np1 -i - \
#			;; \
#			0.8.28) \
#				zcat ${SRCDIR}/u/uae_0.8.28-3.diff.gz | patch -Np1 -i - \
#			;; \
#			0.8.29) \
#				zcat ${SRCDIR}/u/uae_0.8.29-4.diff.gz | patch -Np1 -i - \
#			;; \
#			esac \
#		)
#	
#	##	package configure
#	
#	HTC_UAE_CONFIGURED=${EXTTEMP}/${HTC_UAE_TEMP}/config.status
#	
#	.PHONY: htc-uae-configured
#	
#	htc-uae-configured: htc-uae-extracted ${HTC_UAE_CONFIGURED}
#	
#	${HTC_UAE_CONFIGURED}:
#		echo "*** $@ (CONFIGURED) ***"
#	
#	##	package build
#	
#	#HTC_UAE_BUILT=${EXTTEMP}/${HTC_UAE_TEMP}/uae
#	HTC_UAE_BUILT=${EXTTEMP}/${HTC_UAE_TEMP}/src/readdisk
#	
#	.PHONY: htc-uae-built
#	htc-uae-built: htc-uae-configured ${HTC_UAE_BUILT}
#	
#	# 1. When cross-compiling, some tools need to be forcibly built
#	# with the native compiler: build68k, cpuopti, genblitter, gencpu
#	${HTC_UAE_BUILT}:
#		echo "*** $@ (BUILT) ***"
#		( cd ${EXTTEMP}/${HTC_UAE_TEMP} || exit 1 ;\
#			make \
#		)
#	
#	##	package install
#	
#	HTC_UAE_INSTALLED=${NTI_TC_ROOT}/usr/bin/uae
#	
#	.PHONY: htc-uae-installed
#	
#	htc-uae-installed: htc-uae-built ${HTC_UAE_INSTALLED}
#	
#	${HTC_UAE_INSTALLED}:
#		echo "*** $@ (INSTALLED) ***"
#		( cd ${EXTTEMP}/${HTC_UAE_TEMP} || exit 1 ;\
#			make install \
#		)
#	
#	.PHONY: htc-uae
#	ifeq (${UAE_WITH_SDL},true)
#	htc-uae: htc-SDL htc-uae-installed
#	else
#	htc-uae: htc-libX11 htc-uae-installed
#	endif
#	
#	TARGETS+= htc-uae

NTI_UAE_TEMP=nti-uae-${UAE_VERSION}

NTI_UAE_EXTRACTED=${EXTTEMP}/${NTI_UAE_TEMP}/docs/README
NTI_UAE_CONFIGURED=${EXTTEMP}/${NTI_UAE_TEMP}/config.status
NTI_UAE_BUILT=${EXTTEMP}/${NTI_UAE_TEMP}/uae
NTI_UAE_INSTALLED=${NTI_TC_ROOT}/usr/bin/uae


## ,-----
## |	Extract
## +-----

${NTI_UAE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/uae-${UAE_VERSION} ] || rm -rf ${EXTTEMP}/uae-${UAE_VERSION}
	[ ! -d ${EXTTEMP}/e-uae-${UAE_VERSION} ] || rm -rf ${EXTTEMP}/e-uae-${UAE_VERSION}
	bzcat ${UAE_SRC} | tar xvf - -C ${EXTTEMP}
#	zcat ${UAE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UAE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UAE_TEMP}
#	mv ${EXTTEMP}/uae-${UAE_VERSION} ${EXTTEMP}/${NTI_UAE_TEMP}
	mv ${EXTTEMP}/e-uae-${UAE_VERSION} ${EXTTEMP}/${NTI_UAE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_UAE_CONFIGURED}: ${NTI_UAE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_UAE_TEMP} || exit 1 ;\
		mv configure configure.OLD ;\
		cat configure.OLD \
			| sed 's/pkg-config --/$$PKG_CONFIG --/' \
			> configure ;\
		chmod a+x configure ;\
		case "${UAE_VERSION}" in \
		0.8.25|0.8.26|0.8.27|0.8.28) \
			case "${UAE_WITH_SDL}" in \
			true) \
				PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
				PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			  SDL_CONFIG=${NTI_TC_ROOT}/usr/bin/sdl-config \
				./configure \
					--prefix=${NTI_TC_ROOT}/usr \
					--enable-ui \
					--with-sdl \
					|| exit 1 \
			;; \
			*) \
				./configure \
					--prefix=${NTI_TC_ROOT}/usr \
					--disable-ui --disable-gtktest \
					--with-x \
						--x-includes=${NTI_TC_ROOT}/usr/include \
					--with-alsa \
					|| exit 1 \
			;; \
			esac \
		;; \
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
nti-uae: nti-pkg-config \
	nti-SDL nti-alsa-lib nti-zlib \
	${NTI_UAE_INSTALLED}
else
nti-uae: nti-pkg-config \
	nti-libX11 nti-alsa-lib nti-zlib \
	${NTI_UAE_INSTALLED}
endif

ALL_NTI_TARGETS+= nti-uae

endif	# HAVE_UAE_CONFIG
