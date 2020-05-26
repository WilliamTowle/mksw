# uade v2.13			[ EARLIEST v?.?? ]
# last mod WmT, 2015-04-09	[ (c) and GPLv2 1999-2015 ]

ifneq (${HAVE_UADE_CONFIG},y)
HAVE_UADE_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${UADE_VERSION},)
UADE_VERSION=2.13
endif

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/audvid/libao/v1.1.0.mak
include ${CFG_ROOT}/audvid/libao/v1.2.0.mak
include ${CFG_ROOT}/misc/libiconv/v1.12.mak

UADE_SRC=${SOURCES}/u/uade-${UADE_VERSION}.tar.bz2

#URLS+= http://mirrorservice.org/sites/distfiles.gentoo.org/distfiles/uade-2.13.tar.bz2
URLS+= http://zakalwe.fi/uade/uade2/uade-2.13.tar.bz2

NTI_UADE_TEMP=nti-uade-${UADE_VERSION}

NTI_UADE_EXTRACTED=${EXTTEMP}/${NTI_UADE_TEMP}/configure
NTI_UADE_CONFIGURED=${EXTTEMP}/${NTI_UADE_TEMP}/uade.pc
NTI_UADE_BUILT=${EXTTEMP}/${NTI_UADE_TEMP}/src/uadecore
NTI_UADE_INSTALLED=${NTI_TC_ROOT}/usr/bin/uade123


## ,-----
## |	Extract
## +-----

${NTI_UADE_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/uade-${UADE_VERSION} ] || rm -rf ${EXTTEMP}/uade-${UADE_VERSION}
	bzcat ${UADE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_UADE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_UADE_TEMP}
	mv ${EXTTEMP}/uade-${UADE_VERSION} ${EXTTEMP}/${NTI_UADE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_UADE_CONFIGURED}: ${NTI_UADE_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_UADE_TEMP} || exit 1 ;\
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		CFLAGS='-O2' \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--without-xmms \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_UADE_BUILT}: ${NTI_UADE_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_UADE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_UADE_INSTALLED}: ${NTI_UADE_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_UADE_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/uade.pc ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ \
	)

##

.PHONY: nti-uade
nti-uade: nti-pkg-config nti-libao nti-libiconv ${NTI_UADE_INSTALLED}

ALL_NTI_TARGETS+= nti-uade

endif	# HAVE_UADE_CONFIG
