# xorg-server v1.5.1		[ earliest v1.5.1, since c. 2011-09-23 ]
# last mod WmT, 2014-08-17	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_XORG_SERVER_CONFIG},y)
HAVE_XORG_SERVER_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xorg-server' -- xorg-server"

ifeq (${XORG_SERVER_VERSION},)
#TODO: v1.5.1 in 'individual' tree (v1.7.1 chosen for x11-r7.5)
XORG_SERVER_VERSION=1.5.1
#XORG_SERVER_VERSION=1.7.1
endif

XORG_SERVER_SRC=${SOURCES}/x/xorg-server-${XORG_SERVER_VERSION}.tar.bz2
URLS+= http://xorg.freedesktop.org/releases/individual/xserver/xorg-server-${XORG_SERVER_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/xserver/xorg-server-1.7.1.tar.bz2
XORG_SERVER_PATCHES=${SOURCES}/x/xdirectfb-1.6.4.tar.bz2
URLS+= http://directfb.net/downloads/Misc/xdirectfb-1.6.4.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/x11-r7.5/libX11/v1.5.0.mak
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

#CUI_XORG_SERVER_TEMP=cui-xorg-server-${XORG_SERVER_VERSION}
#CUI_XORG_SERVER_INSTTEMP=${EXTTEMP}/insttemp
#
#CUI_XORG_SERVER_EXTRACTED=${EXTTEMP}/${CUI_XORG_SERVER_TEMP}/configure
#
#.PHONY: cui-xorg-xserver-extracted
#
#cui-xorg-server-extracted: ${CUI_XORG_SERVER_EXTRACTED}
#${CUI_XORG_SERVER_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${CUI_XORG_SERVER_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_XORG_SERVER_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${XORG_SERVER_SRC}
#	mv ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION} ${EXTTEMP}/${CUI_XORG_SERVER_TEMP}

##

# NB. 'xdirectfb' patches are a tarball, against xorg-server v1.6.4

${NTI_XORG_SERVER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION} ] || rm -rf ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION}
	bzcat ${XORG_SERVER_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${XORG_SERVER_PATCHES},)
	bzcat ${XORG_SERVER_PATCHES} | tar xvf - -C ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION}
endif
	[ ! -d ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XORG_SERVER_TEMP}
	mv ${EXTTEMP}/xorg-server-${XORG_SERVER_VERSION} ${EXTTEMP}/${NTI_XORG_SERVER_TEMP}


## ,-----
## |	Configure
## +-----

#CUI_XORG_SERVER_CONFIGURED=${EXTTEMP}/${CUI_XORG_SERVER_TEMP}/config.status
#
#.PHONY: cui-xorg-server-configured
#
#cui-xorg-server-configured: cui-xorg-server-extracted ${CUI_XORG_SERVER_CONFIGURED}
#
#${CUI_XORG_SERVER_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CUI_XORG_SERVER_TEMP} || exit 1 ;\
#	  CC=${CTI_GCC} \
#	  CFLAGS='-O2' \
#	  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
#		./configure \
#			--prefix=/usr/ \
#			--bindir=/usr/X11R7/bin \
#			--build=${NTI_SPEC} \
#			--host=${CTI_SPEC} \
#			|| exit 1 \
#	)

##

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
			--enable-xfbdev \
			--disable-xorg \
			--disable-xsdl \
			--disable-xvfb \
			--disable-aiglx \
			--disable-glx \
			--disable-composite \
			--disable-dri --disable-dri2 \
			--disable-screensaver \
			--disable-xdmcp \
			--disable-xevie \
			--disable-xephyr \
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

#CUI_XORG_SERVER_BUILT=${EXTTEMP}/${CUI_XORG_SERVER_TEMP}/xorg-server
#
#.PHONY: cui-xorg-server-built
#cui-xorg-server-built: cui-xorg-server-configured ${CUI_XORG_SERVER_BUILT}
#
#${CUI_XORG_SERVER_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CUI_XORG_SERVER_TEMP} || exit 1 ;\
#		make \
#	)

##

${NTI_XORG_SERVER_BUILT}: ${NTI_XORG_SERVER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

#CUI_XORG_SERVER_INSTALLED=${CUI_XORG_SERVER_INSTTEMP}/usr/X11R7/bin/xorg-server
#
#.PHONY: cui-xorg-server-installed
#
#cui-xorg-server-installed: cui-xorg-server-built ${CUI_XORG_SERVER_INSTALLED}
#
#${CUI_XORG_SERVER_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CUI_XORG_SERVER_TEMP} || exit 1 ;\
#		make install DESTDIR=${CUI_XORG_SERVER_INSTTEMP} \
#	)
#
#.PHONY: cui-xorg-server
#cui-xorg-server: cti-cross-gcc cti-cross-pkg-config cti-pixman cui-xorg-server-installed
#
#CTARGETS+= cui-xorg-server

##

${NTI_XORG_SERVER_INSTALLED}: ${NTI_XORG_SERVER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XORG_SERVER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xorg-server
#nti-xorg-server: nti-pkg-config nti-libX11 ${NTI_XORG_SERVER_INSTALLED}
nti-xorg-server: nti-pkg-config nti-libX11 nti-libXfont nti-libxkbfile nti-x11proto-randr nti-x11proto-render nti-x11proto-fixes nti-x11proto-damage nti-x11proto-fonts nti-x11proto-video nti-x11proto-resource nti-openssl nti-pixman ${NTI_XORG_SERVER_INSTALLED}

ALL_NTI_TARGETS+= nti-xorg-server

endif	# HAVE_XORG_SERVER_CONFIG
