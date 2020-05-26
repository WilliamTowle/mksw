# x11proto-xf86vidmode v2.3	[ since v2.3, c.2017-04-07 ]
# last mod WmT, 2017-04-07	[ (c) and GPLv2 1999-2017 ]

ifneq (${HAVE_X11PROTO_XF86VIDMODE_CONFIG},y)
HAVE_X11PROTO_XF86VIDMODE_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-xf86vidmode' -- x11proto-xf86vidmode"

ifeq (${X11PROTO_XF86VIDMODE_VERSION},)
X11PROTO_XF86VIDMODE_VERSION=2.3
endif

X11PROTO_XF86VIDMODE_SRC=${SOURCES}/x/xf86vidmodeproto-2.3.tar.bz2
URLS+= https://www.x.org/releases/X11R7.5/src/proto/xf86vidmodeproto-2.3.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_XF86VIDMODE_TEMP=nti-x11proto-xf86vidmode-${X11PROTO_XF86VIDMODE_VERSION}

NTI_X11PROTO_XF86VIDMODE_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP}/configure
NTI_X11PROTO_XF86VIDMODE_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP}/config.status
NTI_X11PROTO_XF86VIDMODE_BUILT=${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP}/xf86vidmodeproto.pc
NTI_X11PROTO_XF86VIDMODE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xf86vidmodeproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_XF86VIDMODE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xf86vidmodeproto-${X11PROTO_XF86VIDMODE_VERSION} ] || rm -rf ${EXTTEMP}/xf86vidmodeproto-${X11PROTO_XF86VIDMODE_VERSION}
	bzcat ${X11PROTO_XF86VIDMODE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP}
	mv ${EXTTEMP}/xf86vidmodeproto-${X11PROTO_XF86VIDMODE_VERSION} ${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_XF86VIDMODE_CONFIGURED}: ${NTI_X11PROTO_XF86VIDMODE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_XF86VIDMODE_BUILT}: ${NTI_X11PROTO_XF86VIDMODE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_XF86VIDMODE_INSTALLED}: ${NTI_X11PROTO_XF86VIDMODE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XF86VIDMODE_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-xf86vidmode
nti-x11proto-xf86vidmode: nti-pkg-config ${NTI_X11PROTO_XF86VIDMODE_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-xf86vidmode

endif	# HAVE_X11PROTO_XF86VIDMODE_CONFIG
