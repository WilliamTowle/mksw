# libX11 v1.6.2			[ since v1.1.4	2008-06-21 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBX11_CONFIG},y)
HAVE_LIBX11_CONFIG:=y

#DESCRLIST+= "'nti-libX11' -- libX11"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${LIBX11_VERSION},)
#LIBX11_VERSION=1.3.2
#LIBX11_VERSION=1.4.0
LIBX11_VERSION=1.6.2
endif

#LIBX11_SRC=${SOURCES}/l/libx11_${LIBX11_VERSION}.orig.tar.gz
LIBX11_SRC=${SOURCES}/l/libX11-${LIBX11_VERSION}.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.6/src/lib/libX11-${LIBX11_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/libX11-1.6.2.tar.bz2

# Always requires xproto, xextproto, xtrans, xcb
include ${CFG_ROOT}/x11-misc/libxcb/v1.13.mak
#include ${CFG_ROOT}/gui/libXau/v1.0.8.mak
include ${CFG_ROOT}/x11-misc/x11proto/v7.0.23.mak
include ${CFG_ROOT}/x11-misc/x11proto-input/v2.3.mak
include ${CFG_ROOT}/x11-misc/x11proto-kb/v1.0.6.mak
include ${CFG_ROOT}/x11-misc/x11proto-xext/v7.2.1.mak
include ${CFG_ROOT}/x11-misc/xtrans/v1.2.7.mak


NTI_LIBX11_TEMP=nti-libX11-${LIBX11_VERSION}

NTI_LIBX11_EXTRACTED=${EXTTEMP}/${NTI_LIBX11_TEMP}/configure
NTI_LIBX11_CONFIGURED=${EXTTEMP}/${NTI_LIBX11_TEMP}/config.status
NTI_LIBX11_BUILT=${EXTTEMP}/${NTI_LIBX11_TEMP}/x11.pc
NTI_LIBX11_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/x11.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBX11_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libX11-${LIBX11_VERSION} ] || rm -rf ${EXTTEMP}/libX11-${LIBX11_VERSION}
	bzcat ${LIBX11_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBX11_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBX11_TEMP}
	mv ${EXTTEMP}/libX11-${LIBX11_VERSION} ${EXTTEMP}/${NTI_LIBX11_TEMP}


## ,-----
## |	Configure
## +-----

## [2013-05-26] xcb (--without-xcb) is unavoidable for v1.5.0+

${NTI_LIBX11_CONFIGURED}: ${NTI_LIBX11_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		case ${LIBX11_VERSION} in \
		1.2.2|1.3.3) \
			mv configure configure.OLD || exit 1 ;\
			cat configure.OLD \
				| sed 's/`pkg-config/`$$PKG_CONFIG/' \
				> configure ;\
			chmod a+x configure \
		;; \
		esac ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --enable-shared --disable-static \
			  --disable-secure-rpc \
			  --disable-xf86bigfont \
			  --x-includes=${NTI_TC_ROOT}/usr/${HOSTSPEC}/include/X11 \
				|| exit 1 \
	)
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \
#			--disable-xlocale \
#			--disable-xlocaledir \


## ,-----
## |	Build
## +-----

${NTI_LIBX11_BUILT}: ${NTI_LIBX11_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBX11_INSTALLED}: ${NTI_LIBX11_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libX11
nti-libX11: nti-pkg-config \
	nti-libxcb \
	nti-x11proto \
	nti-x11proto-input nti-x11proto-kb \
	nti-x11proto-xcb nti-x11proto-xext \
	nti-xtrans ${NTI_LIBX11_INSTALLED}

ALL_NTI_TARGETS+= nti-libX11

##

endif	# HAVE_LIBX11_CONFIG
