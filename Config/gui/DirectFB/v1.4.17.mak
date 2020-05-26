# DirectFB v1.4.17		[ EARLIEST v0.9.21, c.2009-02-25? ]
# last mod WmT, 2017-03-06	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_DIRECTFB_CONFIG},y)
HAVE_DIRECTFB_CONFIG:=y

#DESCRLIST+= "'nti-DirectFB' -- DirectFB"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${DIRECTFB_VERSION},)
#DIRECTFB_VERSION=1.3.0
#DIRECTFB_VERSION=1.3.1
DIRECTFB_VERSION=1.4.17
endif

DIRECTFB_SRC=${SOURCES}/d/DirectFB-${DIRECTFB_VERSION}.tar.gz
URLS+= http://www.directfb.net/downloads/Core/DirectFB-1.4/DirectFB-${DIRECTFB_VERSION}.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.2.10.mak

#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak

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
	[ ! -d ${EXTTEMP}/DIRECTFB-${DIRECTFB_VERSION} ] || rm -rf ${EXTTEMP}/DIRECTFB-${DIRECTFB_VERSION}
	zcat ${DIRECTFB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_DIRECTFB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_DIRECTFB_TEMP}
	mv ${EXTTEMP}/DirectFB-${DIRECTFB_VERSION} ${EXTTEMP}/${NTI_DIRECTFB_TEMP}


## ,-----
## |	Configure
## +-----

## gendoc.pl fails under hbOS (no perl-in-toolchain dependency)

${NTI_DIRECTFB_CONFIGURED}: ${NTI_DIRECTFB_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_DIRECTFB_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		LIBTOOL=${HOSTSPEC}-libtool \
	        PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			  --disable-multi \
			  --disable-osx \
			  --enable-fbdev \
			  --disable-sdl \
			  --disable-x11 \
			  --disable-zlib \
			  --disable-gif \
			  --disable-jpeg \
			  --disable-png \
			  --disable-freetype \
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
		mkdir -p ${NTI_TC_ROOT}/etc ;\
		cp fb.modes ${NTI_TC_ROOT}/etc ;\
		( cat gfxdrivers/davinci/directfbrc ;\
		  echo 'disable-module=keyboard' ) \
			> ${NTI_TC_ROOT}/etc/directfbrc ;\
		make install LIBTOOL=${HOSTSPEC}-libtool \
	)
#		  echo 'disable-module=linux_input' ) \

##

.PHONY: nti-DirectFB
nti-DirectFB: nti-libtool nti-pkg-config ${NTI_DIRECTFB_INSTALLED}

ALL_NTI_TARGETS+= nti-DirectFB

endif	# HAVE_DIRECTFB_CONFIG
