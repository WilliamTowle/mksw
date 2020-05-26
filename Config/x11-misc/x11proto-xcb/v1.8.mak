# x11proto-xcb v1.8		[ since v1.6, c. 2010-08-02 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_XCB_CONFIG},y)
HAVE_X11PROTO_XCB_CONFIG:=y

DESCRLIST+= "'nti-x11proto-xcb' -- x11proto-xcb"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${X11PROTO_XCB_VERSION},)
#X11PROTO_XCB_VERSION=1.6
X11PROTO_XCB_VERSION=1.8
endif

X11PROTO_XCB_SRC=${SOURCES}/x/xcb-proto-${X11PROTO_XCB_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/xcb/xcb-proto-1.6.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.7/src/xcb/xcb-proto-1.7.1.tar.bz2
URLS+= http://www.x.org/releases/individual/xcb/xcb-proto-1.8.tar.bz2

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

# NB. use native python install here
#include ${CFG_ROOT}/python/python2/v2.7.9.mak

NTI_X11PROTO_XCB_TEMP=nti-x11proto-xcb-${X11PROTO_XCB_VERSION}

NTI_X11PROTO_XCB_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP}/configure
NTI_X11PROTO_XCB_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP}/config.status
NTI_X11PROTO_XCB_BUILT=${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP}/xcb-proto.pc
NTI_X11PROTO_XCB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xcb-proto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_XCB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xcb-proto-${X11PROTO_XCB_VERSION} ] || rm -rf ${EXTTEMP}/xcb-proto-${X11PROTO_XCB_VERSION}
	bzcat ${X11PROTO_XCB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP}
	mv ${EXTTEMP}/xcb-proto-${X11PROTO_XCB_VERSION} ${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_XCB_CONFIGURED}: ${NTI_X11PROTO_XCB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$(libdir)%$$(prefix)/'${HOSTSPEC}'/lib%' \
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
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_XCB_BUILT}: ${NTI_X11PROTO_XCB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_XCB_INSTALLED}: ${NTI_X11PROTO_XCB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XCB_TEMP} || exit 1 ;\
		make install \
	)

# v1.6+ needs python

.PHONY: nti-x11proto-xcb
nti-x11proto-xcb: nti-pkg-config \
	${NTI_X11PROTO_XCB_INSTALLED}
#cti-x11proto-xcb: nti-python2 cti-pkg-config \
#	${CTI_X11PROTO_XCB_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-xcb

endif	# HAVE_X11PROTO_XCB_CONFIG
