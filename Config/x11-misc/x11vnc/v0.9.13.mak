# x11vnc v0.9.13		[ EARLIEST v0.9.13, 2014-03-15 ]
# last mod WmT, 2014-03-15	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_X11VNC_CONFIG},y)
HAVE_X11VNC_CONFIG:=y

#DESCRLIST+= "'nti-x11vnc' -- x11vnc"

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
#include ${CFG_ROOT}/audvid/jpegsrc/v6b.mak
#include ${CFG_ROOT}/audvid/libpng/v1.2.33.mak
#include ${CFG_ROOT}/audvid/libpng/v1.4.12.mak
#include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
#include ${CFG_ROOT}/audvid/libtiff/v4.0.3.mak

ifeq (${X11VNC_VERSION},)
X11VNC_VERSION=0.9.13
endif

X11VNC_SRC=${SOURCES}/x/x11vnc-${X11VNC_VERSION}.tar.gz
URLS+= 'http://downloads.sourceforge.net/project/libvncserver/x11vnc/0.9.13/x11vnc-0.9.13.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Flibvncserver%2Ffiles%2Fx11vnc%2F0.9.13%2F&ts=1394871624&use_mirror=heanet'

NTI_X11VNC_TEMP=nti-x11vnc-${X11VNC_VERSION}

NTI_X11VNC_EXTRACTED=${EXTTEMP}/${NTI_X11VNC_TEMP}/configure
NTI_X11VNC_CONFIGURED=${EXTTEMP}/${NTI_X11VNC_TEMP}/config.status
NTI_X11VNC_BUILT=${EXTTEMP}/${NTI_X11VNC_TEMP}/x11vnc
NTI_X11VNC_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/x11vnc


## ,-----
## |	Extract
## +-----

${NTI_X11VNC_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/x11vnc-${X11VNC_VERSION} ] || rm -rf ${EXTTEMP}/x11vnc-${X11VNC_VERSION}
	zcat ${X11VNC_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11VNC_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11VNC_TEMP}
	mv ${EXTTEMP}/x11vnc-${X11VNC_VERSION} ${EXTTEMP}/${NTI_X11VNC_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11VNC_CONFIGURED}: ${NTI_X11VNC_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_X11VNC_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			--without-x \
			--with-sdl-config=${NTI_TC_ROOT}/usr/bin/sdl-config \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11VNC_BUILT}: ${NTI_X11VNC_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_X11VNC_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11VNC_INSTALLED}: ${NTI_X11VNC_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_X11VNC_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-x11vnc
nti-x11vnc: nti-SDL ${NTI_X11VNC_INSTALLED}
#nti-x11vnc: nti-jpegsrc nti-libpng nti-tiff ${NTI_X11VNC_INSTALLED}

ALL_NTI_TARGETS+= nti-x11vnc

endif	# HAVE_X11VNC_CONFIG
