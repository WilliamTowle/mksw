# x11proto-resource v1.1.1	[ since v1.14, c.2015-10-20 ]
# last mod WmT, 2018-01-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_X11PROTO_RESOURCE_CONFIG},y)
HAVE_X11PROTO_RESOURCE_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-resource' -- x11proto-resource"

ifeq (${X11PROTO_RESOURCE_VERSION},)
X11PROTO_RESOURCE_VERSION=1.1.1
endif

X11PROTO_RESOURCE_SRC=${SOURCES}/r/resourceproto-${X11PROTO_RESOURCE_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/proto/resourceproto-1.1.0.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/proto/resourceproto-${X11PROTO_RESOURCE_VERSION}.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_RESOURCE_TEMP=nti-x11proto-resource-${X11PROTO_RESOURCE_VERSION}

NTI_X11PROTO_RESOURCE_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP}/configure
NTI_X11PROTO_RESOURCE_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP}/config.status
NTI_X11PROTO_RESOURCE_BUILT=${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP}/resourceproto.pc
NTI_X11PROTO_RESOURCE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/resourceproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_RESOURCE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/resourceproto-${X11PROTO_RESOURCE_VERSION} ] || rm -rf ${EXTTEMP}/resourceproto-${X11PROTO_RESOURCE_VERSION}
	bzcat ${X11PROTO_RESOURCE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP}
	mv ${EXTTEMP}/resourceproto-${X11PROTO_RESOURCE_VERSION} ${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_RESOURCE_CONFIGURED}: ${NTI_X11PROTO_RESOURCE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_X11PROTO_RESOURCE_BUILT}: ${NTI_X11PROTO_RESOURCE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_RESOURCE_INSTALLED}: ${NTI_X11PROTO_RESOURCE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RESOURCE_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-resource
nti-x11proto-resource: nti-pkg-config ${NTI_X11PROTO_RESOURCE_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-resource

endif	# HAVE_X11PROTO_RESOURCE_CONFIG
