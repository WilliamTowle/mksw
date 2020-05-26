# xf86-video-fbdev v0.4.1	[ since v1.5.0, c. 2013-05-27 ]
# last mod WmT, 2014-03-02	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_XF86_VIDEO_FBDEV_CONFIG},y)
HAVE_XF86_VIDEO_FBDEV_CONFIG:=y

#DESCRLIST+= "'nti-xf86-video-fbdev' -- xf86-video-fbdev"
#DESCRLIST+= "'cti-xf86-video-fbdev' -- xf86-video-fbdev"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XF86_VIDEO_FBDEV_VERSION},)
XF86_VIDEO_FBDEV_VERSION=0.4.1
endif

XF86_VIDEO_FBDEV_SRC=${SOURCES}/x/xf86-video-fbdev-0.4.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/driver/xf86-video-fbdev-0.4.1.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak

include ${CFG_ROOT}/x11-r7.5/xorg-server/v1.7.1-xorgfb.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-fonts/v2.1.0.mak

NTI_XF86_VIDEO_FBDEV_TEMP=nti-xf86-video-fbdev-${XF86_VIDEO_FBDEV_VERSION}

NTI_XF86_VIDEO_FBDEV_EXTRACTED=${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP}/configure
NTI_XF86_VIDEO_FBDEV_CONFIGURED=${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP}/config.status
NTI_XF86_VIDEO_FBDEV_BUILT= ${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP}/src/fbdev_drv.la
NTI_XF86_VIDEO_FBDEV_INSTALLED= ${NTI_TC_ROOT}/usr/lib/xorg/modules/drivers/fbdev_drv.la


## ,-----
## |	Extract
## +-----

${NTI_XF86_VIDEO_FBDEV_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xf86-video-fbdev-${XF86_VIDEO_FBDEV_VERSION} ] || rm -rf ${EXTTEMP}/xf86-video-fbdev-${XF86_VIDEO_FBDEV_VERSION}
	bzcat ${XF86_VIDEO_FBDEV_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP}
	mv ${EXTTEMP}/xf86-video-fbdev-${XF86_VIDEO_FBDEV_VERSION} ${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_XF86_VIDEO_FBDEV_CONFIGURED}: ${NTI_XF86_VIDEO_FBDEV_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP} || exit 1 ;\
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

${NTI_XF86_VIDEO_FBDEV_BUILT}: ${NTI_XF86_VIDEO_FBDEV_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XF86_VIDEO_FBDEV_INSTALLED}: ${NTI_XF86_VIDEO_FBDEV_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_VIDEO_FBDEV_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xf86-video-fbdev
nti-xf86-video-fbdev: nti-pkg-config nti-x11proto nti-x11proto-fonts nti-xorg-server ${NTI_XF86_VIDEO_INTEL_INSTALLED}

ALL_NTI_TARGETS+= nti-xf86-video-fbdev

endif	# HAVE_XF86_VIDEO_FBDEV_CONFIG
