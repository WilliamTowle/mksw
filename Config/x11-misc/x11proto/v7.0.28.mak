# x11proto v7.0.28		[ since v7.0.12, c. 2008-06-01 ]
# last mod WmT, 2015-10-16	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_CONFIG},y)
HAVE_X11PROTO_CONFIG:=y

#DESCRLIST+= "'nti-x11proto' -- x11proto"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11PROTO_VERSION},)
#X11PROTO_VERSION=7.0.16
#X11PROTO_VERSION=7.0.20
#X11PROTO_VERSION=7.0.23
X11PROTO_VERSION=7.0.28
endif

X11PROTO_SRC=${SOURCES}/x/xproto-${X11PROTO_VERSION}.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.5/src/proto/xproto-7.0.16.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/proto/xproto-7.0.20.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/proto/xproto-7.0.23.tar.bz2

include ${CFG_ROOT}/gui/util-macros/v1.17.1.mak
#include ${CFG_ROOT}/gui/x11proto-xext/v7.2.1.mak
#include ${CFG_ROOT}/gui/xtrans/v1.2.7.mak

NTI_X11PROTO_TEMP=nti-x11proto-${X11PROTO_VERSION}

NTI_X11PROTO_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_TEMP}/configure
NTI_X11PROTO_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_TEMP}/config.status
NTI_X11PROTO_BUILT=${EXTTEMP}/${NTI_X11PROTO_TEMP}/xproto.pc
NTI_X11PROTO_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xproto-${X11PROTO_VERSION} ] || rm -rf ${EXTTEMP}/xproto-${X11PROTO_VERSION}
	bzcat ${X11PROTO_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_TEMP}
	mv ${EXTTEMP}/xproto-${X11PROTO_VERSION} ${EXTTEMP}/${NTI_X11PROTO_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_CONFIGURED}: ${NTI_X11PROTO_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_TEMP} || exit 1 ;\
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
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_BUILT}: ${NTI_X11PROTO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_INSTALLED}: ${NTI_X11PROTO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto
nti-x11proto: nti-pkg-config \
	nti-util-macros \
	${NTI_X11PROTO_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto

endif	# HAVE_X11PROTO_CONFIG
