# x11proto-dri2 v2.6		[ since v2.6, c.2013-03-03 ]
# last mod WmT, 2015-10-09	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_DRI2_CONFIG},y)
HAVE_X11PROTO_DRI2_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-dri2' -- x11proto-dri2"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11PROTO_DRI2_VERSION},)
X11PROTO_DRI2_VERSION=2.6
endif

X11PROTO_DRI2_SRC=${SOURCES}/d/dri2proto-${X11PROTO_DRI2_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/proto/dri2proto-2.6.tar.bz2

## deps?

NTI_X11PROTO_DRI2_TEMP=nti-x11proto-dri2-${X11PROTO_DRI2_VERSION}

NTI_X11PROTO_DRI2_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP}/configure
NTI_X11PROTO_DRI2_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP}/config.status
NTI_X11PROTO_DRI2_BUILT=${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP}/dri2proto.pc
NTI_X11PROTO_DRI2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/dri2proto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_DRI2_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/dri2proto-${X11PROTO_DRI2_VERSION} ] || rm -rf ${EXTTEMP}/dri2proto-${X11PROTO_DRI2_VERSION}
	bzcat ${X11PROTO_DRI2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP}
	mv ${EXTTEMP}/dri2proto-${X11PROTO_DRI2_VERSION} ${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_DRI2_CONFIGURED}: ${NTI_X11PROTO_DRI2_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_DRI2_BUILT}: ${NTI_X11PROTO_DRI2_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_DRI2_INSTALLED}: ${NTI_X11PROTO_DRI2_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_DRI2_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-dri2
nti-x11proto-dri2: nti-pkg-config ${NTI_X11PROTO_DRI2_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-dri2

endif	# HAVE_X11PROTO_DRI2_CONFIG
