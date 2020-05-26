# x11proto-dri3 v1.0		[ since v2.6, c.2013-03-03 ]
# last mod WmT, 2015-10-09	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_DRI3_CONFIG},y)
HAVE_X11PROTO_DRI3_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-dri3' -- x11proto-dri3"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11PROTO_DRI3_VERSION},)
X11PROTO_DRI3_VERSION=1.0
endif

X11PROTO_DRI3_SRC=${SOURCES}/d/dri3proto-${X11PROTO_DRI3_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/proto/dri3proto-1.0.tar.bz2

## deps?

NTI_X11PROTO_DRI3_TEMP=nti-x11proto-dri3-${X11PROTO_DRI3_VERSION}

NTI_X11PROTO_DRI3_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP}/configure
NTI_X11PROTO_DRI3_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP}/config.status
NTI_X11PROTO_DRI3_BUILT=${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP}/dri3proto.pc
NTI_X11PROTO_DRI3_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/dri3proto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_DRI3_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/dri3proto-${X11PROTO_DRI3_VERSION} ] || rm -rf ${EXTTEMP}/dri3proto-${X11PROTO_DRI3_VERSION}
	bzcat ${X11PROTO_DRI3_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP}
	mv ${EXTTEMP}/dri3proto-${X11PROTO_DRI3_VERSION} ${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_DRI3_CONFIGURED}: ${NTI_X11PROTO_DRI3_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_DRI3_BUILT}: ${NTI_X11PROTO_DRI3_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_DRI3_INSTALLED}: ${NTI_X11PROTO_DRI3_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DRI3_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-dri3
nti-x11proto-dri3: nti-pkg-config ${NTI_X11PROTO_DRI3_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-dri3

endif	# HAVE_X11PROTO_DRI3_CONFIG
