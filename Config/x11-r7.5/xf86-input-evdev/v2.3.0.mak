# xf86-input-evdev v2.3.0	[ since v1.5.0, c. 2013-05-27 ]
# last mod WmT, 2014-02-26	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_XF86_INPUT_EVDEV_CONFIG},y)
HAVE_XF86_INPUT_EVDEV_CONFIG:=y

#DESCRLIST+= "'nti-xf86-input-evdev' -- xf86-input-evdev"
#DESCRLIST+= "'cti-xf86-input-evdev' -- xf86-input-evdev"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XF86_INPUT_EVDEV_VERSION},)
XF86_INPUT_EVDEV_VERSION=2.3.0
endif

XF86_INPUT_EVDEV_SRC=${SOURCES}/x/xf86-input-evdev-2.3.0.tar.bz2

URLS+= http://www.x.org/releases/X11R7.5/src/driver/xf86-input-evdev-2.3.0.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak

include ${CFG_ROOT}/x11-r7.5/xorg-server/v1.7.1-xorgfb.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak


NTI_XF86_INPUT_EVDEV_TEMP=nti-xf86-input-evdev-${XF86_INPUT_EVDEV_VERSION}

NTI_XF86_INPUT_EVDEV_EXTRACTED=${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP}/configure
NTI_XF86_INPUT_EVDEV_CONFIGURED=${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP}/config.status
NTI_XF86_INPUT_EVDEV_BUILT= ${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP}/src/evdev_drv.la
NTI_XF86_INPUT_EVDEV_INSTALLED= ${NTI_TC_ROOT}/usr/lib/xorg/modules/input/evdev_drv.la


## ,-----
## |	Extract
## +-----

${NTI_XF86_INPUT_EVDEV_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xf86-input-evdev-${XF86_INPUT_EVDEV_VERSION} ] || rm -rf ${EXTTEMP}/xf86-input-evdev-${XF86_INPUT_EVDEV_VERSION}
	bzcat ${XF86_INPUT_EVDEV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP}
	mv ${EXTTEMP}/xf86-input-evdev-${XF86_INPUT_EVDEV_VERSION} ${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_XF86_INPUT_EVDEV_CONFIGURED}: ${NTI_XF86_INPUT_EVDEV_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)
#		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
#		cat Makefile.in.OLD \
#			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
#			> Makefile.in ;\


## ,-----
## |	Build
## +-----

${NTI_XF86_INPUT_EVDEV_BUILT}: ${NTI_XF86_INPUT_EVDEV_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XF86_INPUT_EVDEV_INSTALLED}: ${NTI_XF86_INPUT_EVDEV_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_INPUT_EVDEV_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xf86-input-evdev
nti-xf86-input-evdev: nti-pkg-config nti-x11proto nti-xorg-server ${NTI_XF86_INPUT_MOUSE_INSTALLED}

ALL_NTI_TARGETS+= nti-xf86-input-evdev

endif	# HAVE_XF86_INPUT_EVDEV_CONFIG
