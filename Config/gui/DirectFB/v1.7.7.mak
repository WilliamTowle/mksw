# DirectFB v1.7.7		[ EARLIEST v0.9.21, c.2009-02-25? ]
# last mod WmT, 2018-02-05	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_DIRECTFB_CONFIG},y)
HAVE_DIRECTFB_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-DirectFB' -- DirectFB"

ifeq (${DIRECTFB_VERSION},)
#DIRECTFB_VERSION=1.2.10
#DIRECTFB_VERSION=1.3.1
#DIRECTFB_VERSION=1.4.17
#DIRECTFB_VERSION=1.5.3
#DIRECTFB_VERSION=1.6.3
#DIRECTFB_VERSION=1.7.6
DIRECTFB_VERSION=1.7.7
endif

DIRECTFB_SRC=${SOURCES}/d/DirectFB-${DIRECTFB_VERSION}.tar.gz
#DIRECTFB_SRC=${SOURCES}/d/DIRECTFB_1_7_7.tar.gz
#URLS+= http://www.directfb.net/downloads/Core/DirectFB-1.7/DirectFB-${DIRECTFB_VERSION}.tar.gz
#URLS+= https://github.com/Distrotech/DirectFB/archive/DIRECTFB_1_7_7.tar.gz
URLS+= http://sources.buildroot.net/DirectFB-1.7.7.tar.gz

include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

# Optional. See configure step
#include ${CFG_ROOT}/audvid/giflib/v5.0.6.mak
include ${CFG_ROOT}/audvid/freetype2/v2.7.1.mak
include ${CFG_ROOT}/audvid/jpegsrc/v9.mak
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
	#mv ${EXTTEMP}/DirectFB-DIRECTFB_1_7_7 ${EXTTEMP}/${NTI_DIRECTFB_TEMP}


## ,-----
## |	Configure
## +-----

# [v1.3.1] 'disable-module=linux_input' may fix keypress repetition?
# [v1.3.1] 'disable-module=keyboard' may fix keypress repetition?
# [v1.4.17] --without-tools, due to C++ code
# [v1.5.3] --disable-flux due to C++ dependency
# [v1.7.3] '--disable-multi' due to enforced 'fusion' dependency

${NTI_DIRECTFB_CONFIGURED}: ${NTI_DIRECTFB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		[ -r autogen.sh.OLD ] || mv autogen.sh autogen.sh.OLD || exit 1 ;\
		cat autogen.sh.OLD \
			| sed '/libtoolize/	{ /^echo/ ! s/libtoolize/'${HOSTSPEC}'-libtoolize/ }' \
			> autogen.sh ;\
		chmod a+x autogen.sh ;\
		CPPFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		LIBTOOL=${HOSTSPEC}-libtool \
	        PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./autogen.sh \
			--prefix=${NTI_TC_ROOT}/usr \
			  --disable-multi \
			  --disable-unique \
			  --disable-flux --without-flux \
			  --disable-devmem \
			  --disable-egl \
			  --enable-fbdev \
			  --enable-freetype \
			  --disable-gif \
			  --enable-jpeg \
			  --disable-osx \
			  --enable-png \
			  --disable-sdl \
			  --disable-x11 \
			  --disable-zlib \
			  --without-tools \
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

${NTI_DIRECTFB_INSTALLED}: ${NTI_DIRECTFB_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		mkdir -p ${NTI_TC_ROOT}/etc ;\
		cp fb.modes ${NTI_TC_ROOT}/etc ;\
		cp gfxdrivers/davinci/directfbrc ${NTI_TC_ROOT}/etc ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)

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
