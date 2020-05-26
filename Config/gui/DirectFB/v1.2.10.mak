# DirectFB-SDL v1.2.10		[ EARLIEST v0.9.21, c.2009-02-25? ]
# last mod WmT, 2018-02-05	[ (c) and GPLv2 1999-2018 ]

ifneq (${HAVE_DIRECTFB_CONFIG},y)
HAVE_DIRECTFB_CONFIG:=y

#DESCRLIST+= "'nti-DirectFB' -- DirectFB"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak


ifeq (${DIRECTFB_VERSION},)
DIRECTFB_VERSION=1.2.10
#DIRECTFB_VERSION=1.3.0
#DIRECTFB_VERSION=1.3.1
#DIRECTFB_VERSION=1.4.17
endif

## [2018-02-03] right dependencies for jpeg_destroy_compress()?

#DIRECTFB_SRC=${SOURCES}/d/DirectFB-${DIRECTFB_VERSION}.tar.gz
DIRECTFB_SRC=${SOURCES}/d/directfb_${DIRECTFB_VERSION}.0.orig.tar.gz
#DIRECTFB_PATCHES= ${SOURCES}/d/directfb-1.2.10_libpng-1.5.patch
#URLS+= http://www.directfb.net/downloads/Core/DirectFB-1.4/DirectFB-${DIRECTFB_VERSION}.tar.gz
#URLS+= http://sources.buildroot.net/DirectFB-${DIRECTFB_VERSION}.tar.gz
URLS+= http://http.debian.net/debian/pool/main/d/directfb/directfb_${DIRECTFB_VERSION}.0.orig.tar.gz
ifneq (${DIRECTFB_PATCHES},)
URLS+= https://sources.debian.org/data/main/d/directfb/1.2.10.0-8/debian/patches/directfb-1.2.10_libpng-1.5.patch
endif


##include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
#include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
# Optional (depending on examples, etc). See configure step
#include ${CFG_ROOT}/audvid/giflib/v5.0.6.mak
include ${CFG_ROOT}/audvid/freetype2/v2.7.1.mak
include ${CFG_ROOT}/audvid/jpegsrc/v9.mak
#include ${CFG_ROOT}/audvid/libjpeg-turbo/v1.5.3.mak
include ${CFG_ROOT}/audvid/libpng/v1.6.28.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak


NTI_DIRECTFB_TEMP=nti-DirectFB-${DIRECTFB_VERSION}

NTI_DIRECTFB_EXTRACTED=${EXTTEMP}/${NTI_DIRECTFB_TEMP}/configure
NTI_DIRECTFB_CONFIGURED=${EXTTEMP}/${NTI_DIRECTFB_TEMP}/config.status
NTI_DIRECTFB_BUILT=${EXTTEMP}/${NTI_DIRECTFB_TEMP}/tools/dfbmaster
NTI_DIRECTFB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/directfb.pc


## ,-----
## |	Extract
## +-----

${NTI_DIRECTFB_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/DirectFB-${DIRECTFB_VERSION} ] || rm -rf ${EXTTEMP}/DirectFB-${DIRECTFB_VERSION}
	#[ ! -d ${EXTTEMP}/DIRECTFB-${DIRECTFB_VERSION} ] || rm -rf ${EXTTEMP}/DIRECTFB-${DIRECTFB_VERSION}
	zcat ${DIRECTFB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIRECTFB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIRECTFB_TEMP}
ifneq (${DIRECTFB_PATCHES},)
	echo "[PATCHING...]"
	for PF in ${DIRECTFB_PATCHES} ; do cat $${PF} | ( cd ${EXTTEMP}/DirectFB-${DIRECTFB_VERSION} && patch -Np1 -i - ) ; done
endif
	mv ${EXTTEMP}/DirectFB-${DIRECTFB_VERSION} ${EXTTEMP}/${NTI_DIRECTFB_TEMP}
	#mv ${EXTTEMP}/DIRECTFB-${DIRECTFB_VERSION} ${EXTTEMP}/${NTI_DIRECTFB_TEMP}


## ,-----
## |	Configure
## +-----

## gendoc.pl fails under hbOS (no perl-in-toolchain dependency)

${NTI_DIRECTFB_CONFIGURED}: ${NTI_DIRECTFB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		CPPFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		LIBTOOL=${HOSTSPEC}-libtool \
	        PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			  --disable-multi \
			  --disable-unique \
			  --disable-devmem \
			  --disable-egl \
			  --enable-fbdev \
			  --enable-freetype \
			  --disable-gif \
			  --enable-jpeg \
			  --disable-osx \
			  --enable-png \
			  --disable-sdl \
			  --enable-vnc \
			  --disable-x11 \
			  --disable-zlib \
			|| exit 1 ;\
		for MF in Makefile lib/*/Makefile ; do \
			[ -r $${MF}.OLD ] || mv $${MF} $${MF}.OLD ;\
			cat $${MF}.OLD \
				| sed '/^DIST_SUBDIRS/	s/docs//' \
				| sed '/^	/	s/docs	//' \
				| sed '/^pkgconfigdir/	s%=.*%= '${NTI_TC_ROOT}'/usr/'${HOSTSPEC}'/lib/pkgconfig%' \
				> $${MF} ;\
		done \
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

# [v1.3.1]: 'disable-module=linux_input' may fix keypress repetition?
# [v1.3.1]: 'disable-module=keyboard' may fix keypress repetition?

${NTI_DIRECTFB_INSTALLED}: ${NTI_DIRECTFB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)
#		mkdir -p ${NTI_TC_ROOT}/etc ;\
#		cp fb.modes ${NTI_TC_ROOT}/etc ;\
#		( cat gfxdrivers/davinci/directfbrc ;\
#		  echo 'disable-module=keyboard' ) \
#			> ${NTI_TC_ROOT}/etc/directfbrc ;\
#		make install LIBTOOL=${HOSTSPEC}-libtool \
#
##		  echo 'disable-module=linux_input' ) \

##

.PHONY: nti-DirectFB
nti-DirectFB: nti-libtool nti-pkg-config \
	nti-freetype2 nti-jpegsrc nti-libpng \
	${NTI_DIRECTFB_INSTALLED}
#nti-DirectFB: nti-libtool nti-pkg-config \
#	nti-SDL nti-freetype2 nti-jpegsrc nti-libpng \
#	${NTI_DIRECTFB_INSTALLED}


ALL_NTI_TARGETS+= nti-DirectFB

endif	# HAVE_DIRECTFB_CONFIG
