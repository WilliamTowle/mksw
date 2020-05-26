# x11proto-present v1.0		[ since v2.6, c.2013-03-03 ]
# last mod WmT, 2015-10-09	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_PRESENT_CONFIG},y)
HAVE_X11PROTO_PRESENT_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-present' -- x11proto-present"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${X11PROTO_PRESENT_VERSION},)
X11PROTO_PRESENT_VERSION=1.0
endif

X11PROTO_PRESENT_SRC=${SOURCES}/p/presentproto-${X11PROTO_PRESENT_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/proto/presentproto-1.0.tar.bz2

## deps?

NTI_X11PROTO_PRESENT_TEMP=nti-x11proto-present-${X11PROTO_PRESENT_VERSION}

NTI_X11PROTO_PRESENT_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP}/configure
NTI_X11PROTO_PRESENT_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP}/config.status
NTI_X11PROTO_PRESENT_BUILT=${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP}/presentproto.pc
NTI_X11PROTO_PRESENT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/presentproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_PRESENT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/presentproto-${X11PROTO_PRESENT_VERSION} ] || rm -rf ${EXTTEMP}/presentproto-${X11PROTO_PRESENT_VERSION}
	bzcat ${X11PROTO_PRESENT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP}
	mv ${EXTTEMP}/presentproto-${X11PROTO_PRESENT_VERSION} ${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_PRESENT_CONFIGURED}: ${NTI_X11PROTO_PRESENT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_PRESENT_BUILT}: ${NTI_X11PROTO_PRESENT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_PRESENT_INSTALLED}: ${NTI_X11PROTO_PRESENT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_PRESENT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-present
nti-x11proto-present: nti-pkg-config ${NTI_X11PROTO_PRESENT_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-present

endif	# HAVE_X11PROTO_PRESENT_CONFIG
