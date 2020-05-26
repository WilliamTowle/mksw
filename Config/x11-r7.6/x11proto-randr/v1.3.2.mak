# x11proto-randr v1.3.1		[ since v1.3.1, c.2013-03-03 ]
# last mod WmT, 2018-01-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_X11PROTO_RANDR_CONFIG},y)
HAVE_X11PROTO_RANDR_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-randr' -- x11proto-randr"

ifeq (${X11PROTO_RANDR_VERSION},)
X11PROTO_RANDR_VERSION=1.3.1
endif

X11PROTO_RANDR_SRC=${SOURCES}/r/randrproto-${X11PROTO_RANDR_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/proto/randrproto-1.3.1.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_RANDR_TEMP=nti-x11proto-randr-${X11PROTO_RANDR_VERSION}

NTI_X11PROTO_RANDR_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP}/configure
NTI_X11PROTO_RANDR_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP}/config.status
NTI_X11PROTO_RANDR_BUILT=${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP}/randrproto.pc
NTI_X11PROTO_RANDR_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/randrproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_RANDR_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/randrproto-${X11PROTO_RANDR_VERSION} ] || rm -rf ${EXTTEMP}/randrproto-${X11PROTO_RANDR_VERSION}
	bzcat ${X11PROTO_RANDR_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP}
	mv ${EXTTEMP}/randrproto-${X11PROTO_RANDR_VERSION} ${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_RANDR_CONFIGURED}: ${NTI_X11PROTO_RANDR_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_RANDR_BUILT}: ${NTI_X11PROTO_RANDR_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_RANDR_INSTALLED}: ${NTI_X11PROTO_RANDR_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RANDR_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-randr
nti-x11proto-randr: nti-pkg-config ${NTI_X11PROTO_RANDR_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-randr

endif	# HAVE_X11PROTO_RANDR_CONFIG
