# xorg-server v1.7.1		[ earliest v1.7.0, since c. 2011-09-23 ]
# last mod WmT, 2014-08-17	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_XORG_SERVER_CONFIG},y)
HAVE_XORG_SERVER_CONFIG:=y

#DESCRLIST+= "'nti-xorg-server' -- xorg-server"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XORG_SERVER_VERSION},)
XORG_SERVER_VERSION=1.7.1
#XORG_SERVER_VERSION=1.12.2
endif

XORG_SERVER_SRC=${SOURCES}/x/xorg-server-${XORG_SERVER_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/xserver/xorg-server-${XORG_SERVER_VERSION}.tar.bz2
#URLS+= http://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${XORG_SERVER_VERSION}.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-misc/libX11/v1.5.0.mak
include ${CFG_ROOT}/x11-r7.5/libXfont/v1.4.1.mak
include ${CFG_ROOT}/x11-r7.5/libxkbfile/v1.0.6.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-randr/v1.3.1.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-render/v0.11.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-fixes/v4.1.1.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-damage/v1.2.0.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-fonts/v2.1.0.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-video/v2.3.0.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-resource/v1.1.0.mak
#include ${CFG_ROOT}/network/openssl/v1.0.1i.mak
include ${CFG_ROOT}/network/openssl/v1.0.1u.mak
include ${CFG_ROOT}/gui/pixman/v0.29.4.mak

NTI_XORG_SERVER_TEMP=nti-xorg-server-${XORG_SERVER_VERSION}

NTI_XORG_SERVER_EXTRACTED=${EXTTEMP}/${NTI_XORG_SERVER_TEMP}/configure
NTI_XORG_SERVER_CONFIGURED=${EXTTEMP}/${NTI_XORG_SERVER_TEMP}/config.status
NTI_XORG_SERVER_BUILT=${EXTTEMP}/${NTI_XORG_SERVER_TEMP}/xorg-server
NTI_XORG_SERVER_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xorg-server


## ,-----
## |	Extract
## +-----

${NTI_XORG_SERVER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION} ] || rm -rf ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION}
	bzcat ${XORG_SERVER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XORG_SERVER_TEMP}
	mv ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION} ${EXTTEMP}/${NTI_XORG_SERVER_TEMP}


## ,-----
## |	Configure
## +-----

## 2013-03-03: excluding Mesa with '--disable-glx', dri, dri2

${NTI_XORG_SERVER_CONFIGURED}: ${NTI_XORG_SERVER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			--enable-kdrive \
			--disable-xorg \
			--disable-xvfb \
			--disable-aiglx \
			--disable-glx \
			--disable-composite \
			--disable-dri --disable-dri2 \
			--disable-screensaver \
			--disable-xdmcp \
			--disable-xevie \
			--disable-xinerama \
			--disable-xnest \
			--disable-ipv6 \
			|| exit 1 \
	)
#		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
#		cat Makefile.in.OLD \
#			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
#			> Makefile.in ;\


## ,-----
## |	Build
## +-----

${NTI_XORG_SERVER_BUILT}: ${NTI_XORG_SERVER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XORG_SERVER_INSTALLED}: ${NTI_XORG_SERVER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xorg-server
nti-xorg-server: nti-pkg-config nti-libX11 nti-libXfont nti-libxkbfile nti-x11proto-randr nti-x11proto-render nti-x11proto-fixes nti-x11proto-damage nti-x11proto-fonts nti-x11proto-video nti-x11proto-resource nti-openssl nti-pixman ${NTI_XORG_SERVER_INSTALLED}

ALL_NTI_TARGETS+= nti-xorg-server

endif	# HAVE_XORG_SERVER_CONFIG
