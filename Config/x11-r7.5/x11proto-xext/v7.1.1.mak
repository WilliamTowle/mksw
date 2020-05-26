# x11proto-xext v7.1.1		[ since v7.0.4, c.2008-06-08 ]
# last mod WmT, 2013-05-13	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_X11PROTO_XEXT_CONFIG},y)
HAVE_X11PROTO_XEXT_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-xext' -- x11proto-xext"

ifeq (${X11PROTO_XEXT_VERSION},)
X11PROTO_XEXT_VERSION=7.1.1
endif

X11PROTO_XEXT_SRC=${SOURCES}/x/xextproto-7.1.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/proto/xextproto-7.1.1.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_XEXT_TEMP=nti-x11proto-xext-${X11PROTO_XEXT_VERSION}

NTI_X11PROTO_XEXT_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP}/configure
NTI_X11PROTO_XEXT_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP}/config.status
NTI_X11PROTO_XEXT_BUILT=${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP}/xextproto.pc
NTI_X11PROTO_XEXT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xextproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_XEXT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xextproto-${X11PROTO_XEXT_VERSION} ] || rm -rf ${EXTTEMP}/xextproto-${X11PROTO_XEXT_VERSION}
	bzcat ${X11PROTO_XEXT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP}
	mv ${EXTTEMP}/xextproto-${X11PROTO_XEXT_VERSION} ${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_XEXT_CONFIGURED}: ${NTI_X11PROTO_XEXT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_XEXT_BUILT}: ${NTI_X11PROTO_XEXT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_XEXT_INSTALLED}: ${NTI_X11PROTO_XEXT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_XEXT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-xext
nti-x11proto-xext: nti-pkg-config ${NTI_X11PROTO_XEXT_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-xext

endif	# HAVE_X11PROTO_XEXT_CONFIG
