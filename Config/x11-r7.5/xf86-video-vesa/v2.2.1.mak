# xf86-video-vesa v2.2.1	[ since v2.2.1, c.2014-02-16 ]
# last mod WmT, 2014-03-02	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_XF86_VIDEO_VESA_CONFIG},y)
HAVE_XF86_VIDEO_VESA_CONFIG:=y

#DESCRLIST+= "'nti-xf86-video-vesa' -- xf86-video-vesa"
#DESCRLIST+= "'cti-xf86-video-vesa' -- xf86-video-vesa"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${XF86_VIDEO_VESA_VERSION},)
XF86_VIDEO_VESA_VERSION=2.2.1
endif

XF86_VIDEO_VESA_SRC=${SOURCES}/x/xf86-video-vesa-2.2.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/driver/xf86-video-vesa-2.2.1.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak

include ${CFG_ROOT}/x11-r7.5/xorg-server/v1.7.1-xorgfb.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-fonts/v2.1.0.mak


NTI_XF86_VIDEO_VESA_TEMP=nti-xf86-video-vesa-${XF86_VIDEO_VESA_VERSION}

NTI_XF86_VIDEO_VESA_EXTRACTED=${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP}/configure
NTI_XF86_VIDEO_VESA_CONFIGURED=${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP}/config.status
NTI_XF86_VIDEO_VESA_BUILT= ${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP}/src/vesa_drv.la
NTI_XF86_VIDEO_VESA_INSTALLED= ${NTI_TC_ROOT}/usr/lib/xorg/modules/drivers/vesa_drv.la


## ,-----
## |	Extract
## +-----

${NTI_XF86_VIDEO_VESA_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xf86-video-vesa-${XF86_VIDEO_VESA_VERSION} ] || rm -rf ${EXTTEMP}/xf86-video-vesa-${XF86_VIDEO_VESA_VERSION}
	bzcat ${XF86_VIDEO_VESA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP}
	mv ${EXTTEMP}/xf86-video-vesa-${XF86_VIDEO_VESA_VERSION} ${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_XF86_VIDEO_VESA_CONFIGURED}: ${NTI_XF86_VIDEO_VESA_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP} || exit 1 ;\
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

${NTI_XF86_VIDEO_VESA_BUILT}: ${NTI_XF86_VIDEO_VESA_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_XF86_VIDEO_VESA_INSTALLED}: ${NTI_XF86_VIDEO_VESA_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XF86_VIDEO_VESA_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xf86-video-vesa
nti-xf86-video-vesa: nti-pkg-config nti-x11proto nti-x11proto-fonts nti-xorg-server ${NTI_XF86_VIDEO_INTEL_INSTALLED}

ALL_NTI_TARGETS+= nti-xf86-video-vesa

endif	# HAVE_XF86_VIDEO_VESA_CONFIG
