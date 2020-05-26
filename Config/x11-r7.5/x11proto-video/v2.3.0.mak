# x11proto-video v2.3.0		[ since v2.3.0, c.2013-03-03 ]
# last mod WmT, 2016-12-25	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_X11PROTO_VIDEO_CONFIG},y)
HAVE_X11PROTO_VIDEO_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-video' -- x11proto-video"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${X11PROTO_VIDEO_VERSION},)
X11PROTO_VIDEO_VERSION=2.3.0
endif

X11PROTO_VIDEO_SRC=${SOURCES}/v/videoproto-${X11PROTO_VIDEO_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/proto/videoproto-2.3.0.tar.bz2
#URLS+= http://www.x.org/releases/individual/proto/videoproto-2.3.0.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_VIDEO_TEMP=nti-x11proto-video-${X11PROTO_VIDEO_VERSION}

NTI_X11PROTO_VIDEO_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP}/configure
NTI_X11PROTO_VIDEO_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP}/config.status
NTI_X11PROTO_VIDEO_BUILT=${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP}/videoproto.pc
NTI_X11PROTO_VIDEO_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/videoproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_VIDEO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/videoproto-${X11PROTO_VIDEO_VERSION} ] || rm -rf ${EXTTEMP}/videoproto-${X11PROTO_VIDEO_VERSION}
	bzcat ${X11PROTO_VIDEO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP}
	mv ${EXTTEMP}/videoproto-${X11PROTO_VIDEO_VERSION} ${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_VIDEO_CONFIGURED}: ${NTI_X11PROTO_VIDEO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP} || exit 1 ;\
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
			  --bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_VIDEO_BUILT}: ${NTI_X11PROTO_VIDEO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_VIDEO_INSTALLED}: ${NTI_X11PROTO_VIDEO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_VIDEO_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-video
nti-x11proto-video: nti-pkg-config ${NTI_X11PROTO_VIDEO_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-video

endif	# HAVE_X11PROTO_VIDEO_CONFIG
