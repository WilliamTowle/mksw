# DirectFB-SDL v1.6.3		[ EARLIEST v0.9.21, c.2009-02-25? ]
# last mod WmT, 2018-02-07	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_DIRECTFB_CONFIG},y)
HAVE_DIRECTFB_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-DirectFB' -- DirectFB"

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

ifeq (${DIRECTFB_VERSION},)
#DIRECTFB_VERSION=1.3.1
DIRECTFB_VERSION=1.6.3
#DIRECTFB_VERSION=1.7.6
endif

DIRECTFB_SRC=${SOURCES}/d/DirectFB-${DIRECTFB_VERSION}.tar.gz
URLS+= http://www.directfb.net/downloads/Core/DirectFB-1.6/DirectFB-1.6.3.tar.gz
#URLS+= http://www.directfb.net/downloads/Core/DirectFB-1.7/DirectFB-1.7.6.tar.gz


# [2017-04-06] v1.2.15 incompatible with modern X11?
#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/gui/SDL/v2.0.3.mak
# Optional (depending on examples, etc). See configure step
include ${CFG_ROOT}/audvid/freetype2/v2.7.1.mak
#include ${CFG_ROOT}/audvid/giflib/v5.0.6.mak
include ${CFG_ROOT}/audvid/jpegsrc/v9.mak
#include ${CFG_ROOT}/audvid/libjpeg-turbo/v1.5.3.mak
include ${CFG_ROOT}/audvid/libpng/v1.6.28.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
#include ${CFG_ROOT}/misc/zlib/v1.2.8.mak

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

${NTI_DIRECTFB_CONFIGURED}: ${NTI_DIRECTFB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		for SD in . lib/direct lib/fusion ; do \
			[ -r $${SD}/Makefile.in.OLD ] || mv $${SD}/Makefile.in $${SD}/Makefile.in.OLD || exit 1 ;\
			cat $${SD}/Makefile.in.OLD \
				| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
				> $${SD}/Makefile.in ;\
		done ;\
		CPPFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		  LIBTOOL=${HOSTSPEC}-libtool \
	        PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				--disable-multi \
			  --disable-unique \
			  --disable-devmem \
				--disable-egl \
				--disable-fbdev \
				--disable-flux --without-flux \
				--enable-freetype \
				--disable-gif \
				--enable-jpeg \
				--disable-osx \
				--enable-png \
				--enable-sdl \
				--disable-x11 \
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
	nti-SDL nti-freetype2 nti-jpegsrc nti-libpng \
	${NTI_DIRECTFB_INSTALLED}

ALL_NTI_TARGETS+= nti-DirectFB

endif	# HAVE_DIRECTFB_CONFIG
