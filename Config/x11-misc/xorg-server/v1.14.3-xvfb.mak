# xorg-server v1.14.3		[ earliest v1.5.1, since c. 2011-09-23 ]
# last mod WmT, 2015-10-21	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_XORG_SERVER_CONFIG},y)
HAVE_XORG_SERVER_CONFIG:=y

#DESCRLIST+= "'nti-xorg-server' -- xorg-server"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${XORG_SERVER_VERSION},)
#XORG_SERVER_VERSION=1.7.1
XORG_SERVER_VERSION=1.14.3
endif

XORG_SERVER_SRC=${SOURCES}/x/xorg-server-${XORG_SERVER_VERSION}.tar.bz2
#URLS+= http://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${XORG_SERVER_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/xserver/xorg-server-1.14.3.tar.bz2

#XORG_SERVER_PATCHES=${SOURCES}/x/xdirectfb-1.6.4.tar.bz2
#URLS+= http://directfb.net/downloads/Misc/xdirectfb-1.6.4.tar.bz2

include ${CFG_ROOT}/x11-misc/libX11/v1.6.2.mak
include ${CFG_ROOT}/x11-misc/x11proto/v7.0.28.mak
include ${CFG_ROOT}/x11-misc/x11proto-bigreqs/v1.1.1.mak
# dri >= 7.8.0
include ${CFG_ROOT}/x11-misc/x11proto-fixes/v5.0.mak
include ${CFG_ROOT}/x11-misc/x11proto-fonts/v2.1.1.mak
include ${CFG_ROOT}/x11-misc/x11proto-gl/v1.4.16.mak
include ${CFG_ROOT}/x11-misc/x11proto-input/v2.3.mak
include ${CFG_ROOT}/x11-misc/x11proto-kb/v1.0.4.mak
include ${CFG_ROOT}/x11-misc/x11proto-randr/v1.4.0.mak
include ${CFG_ROOT}/x11-misc/x11proto-record/v1.14.2.mak
include ${CFG_ROOT}/x11-misc/x11proto-render/v0.11.1.mak
include ${CFG_ROOT}/x11-misc/x11proto-resource/v1.2.0.mak
include ${CFG_ROOT}/x11-misc/x11proto-video/v2.3.1.mak
include ${CFG_ROOT}/x11-misc/x11proto-xext/v7.2.1.mak
include ${CFG_ROOT}/x11-misc/x11proto-xcmisc/v1.2.1.mak
include ${CFG_ROOT}/x11-misc/xf86driproto/v2.1.0.mak

include ${CFG_ROOT}/x11-misc/libXfont/v1.4.2.mak
include ${CFG_ROOT}/x11-misc/libxkbfile/v1.0.7.mak
include ${CFG_ROOT}/x11-misc/x11pciacess/v0.13.1.mak
include ${CFG_ROOT}/x11-misc/xtrans/v1.2.7.mak

# TODO: video for gpu-viv (imx6) somehow??
#include ${CFG_ROOT}/x11-misc/xf86-input-mouse/v1.5.0.mak
#include ${CFG_ROOT}/x11-misc/xf86-input-keyboard/v1.4.0.mak
#include ${CFG_ROOT}/x11-misc/xf86-video-fbdev/v0.4.1.mak
#include ${CFG_ROOT}/x11-misc/xf86-video-vesa/v2.2.1.mak

include ${CFG_ROOT}/x11-misc/libXau/v1.0.8.mak
include ${CFG_ROOT}/x11-misc/libXdamage/v1.1.4.mak
include ${CFG_ROOT}/x11-misc/mesalib/v9.2.0.mak
#include ${CFG_ROOT}/misc/openssl/v1.0.1i.mak
include ${CFG_ROOT}/network/openssl/v1.0.2d.mak
include ${CFG_ROOT}/x11-misc/pixman/v0.29.4.mak
#include ${CFG_ROOT}/x11-misc/xkeyboard-config/v2.1.mak

NTI_XORG_SERVER_TEMP=nti-xorg-server-${XORG_SERVER_VERSION}

NTI_XORG_SERVER_EXTRACTED=${EXTTEMP}/${NTI_XORG_SERVER_TEMP}/configure
NTI_XORG_SERVER_CONFIGURED=${EXTTEMP}/${NTI_XORG_SERVER_TEMP}/config.status
NTI_XORG_SERVER_BUILT=${EXTTEMP}/${NTI_XORG_SERVER_TEMP}/xorg-server.pc
#NTI_XORG_SERVER_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xorg-server
NTI_XORG_SERVER_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xorg-server.pc


## ,-----
## |	Extract
## +-----

# NB. 'xdirectfb' patches are a tarball, against xorg-server v1.6.4

${NTI_XORG_SERVER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION} ] || rm -rf ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION}
	bzcat ${XORG_SERVER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XORG_SERVER_TEMP}
#ifneq (${XORG_SERVER_PATCHES},)
#	bzcat ${XORG_SERVER_PATCHES} | tar xvf - -C ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION}
#endif
	mv ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION} ${EXTTEMP}/${NTI_XORG_SERVER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_XORG_SERVER_CONFIGURED}: ${NTI_XORG_SERVER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr/ \
			  --bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			  --disable-kdrive \
			  --disable-xorg \
			  --disable-xephyr \
			  --disable-xfake \
			  --disable-xfbdev \
			  --enable-xvfb \
			  --disable-aiglx \
			  --disable-composite \
			  --disable-screensaver \
			  --disable-xdmcp \
			  --disable-xevie \
			  --disable-xinerama \
			  --disable-xnest \
			  --disable-xprint \
			  --disable-xwin \
			  --disable-ipv6 \
				|| exit 1 \
	)


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
		make install ;\
		cp xorg-server.pc ${NTI_XORG_SERVER_INSTALLED} \
	)

.PHONY: nti-xorg-server
nti-xorg-server: nti-pkg-config \
	nti-x11proto \
	nti-x11proto-bigreqs \
	nti-x11proto-fixes \
	nti-x11proto-fonts \
	nti-x11proto-gl nti-x11proto-input \
	nti-x11proto-kb \
	nti-x11proto-randr \
	nti-x11proto-record \
	nti-x11proto-render \
	nti-x11proto-resource \
	nti-x11proto-video \
	nti-x11proto-xcmisc \
	nti-x11proto-xext \
	nti-xf86-driproto \
	\
	nti-libX11 \
	nti-libXau \
	nti-libXdamage nti-libXfont \
	nti-libxkbfile \
	nti-x11pciaccess \
	nti-xtrans \
	\
	nti-mesalib nti-openssl \
	nti-pixman \
	${NTI_XORG_SERVER_INSTALLED}
#nti-xorg-server: nti-pkg-config nti-libX11 nti-libXfont nti-libxkbfile nti-x11proto-randr nti-x11proto-render nti-x11proto-fixes nti-x11proto-damage nti-x11proto-fonts nti-x11proto-video nti-x11proto-resource nti-openssl nti-pixman nti-x11pciaccess nti-xkeyboard-config ${NTI_XORG_SERVER_INSTALLED}

ALL_NTI_TARGETS+= nti-xorg-server

endif	# HAVE_XORG_SERVER_CONFIG
