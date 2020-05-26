# x11proto-render v0.11.1	[ since v0.11, c.2013-03-03 ]
# last mod WmT, 2015-10-21	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_RENDER_CONFIG},y)
HAVE_X11PROTO_RENDER_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-x11proto-render' -- x11proto-render"

ifeq (${X11PROTO_RENDER_VERSION},)
#X11PROTO_RENDER_VERSION=0.11
X11PROTO_RENDER_VERSION=0.11.1
endif

X11PROTO_RENDER_SRC=${SOURCES}/r/renderproto-${X11PROTO_RENDER_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/proto/renderproto-0.11.tar.bz2
URLS+= http://www.x.org/releases/individual/proto/renderproto-${X11PROTO_RENDER_VERSION}.tar.bz2

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


NTI_X11PROTO_RENDER_TEMP=nti-x11proto-render-${X11PROTO_RENDER_VERSION}

NTI_X11PROTO_RENDER_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}/configure
NTI_X11PROTO_RENDER_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}/config.status
NTI_X11PROTO_RENDER_BUILT=${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}/renderproto.pc
NTI_X11PROTO_RENDER_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/renderproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_RENDER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/renderproto-${X11PROTO_RENDER_VERSION} ] || rm -rf ${EXTTEMP}/renderproto-${X11PROTO_RENDER_VERSION}
	bzcat ${X11PROTO_RENDER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}
	mv ${EXTTEMP}/renderproto-${X11PROTO_RENDER_VERSION} ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_RENDER_CONFIGURED}: ${NTI_X11PROTO_RENDER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_RENDER_BUILT}: ${NTI_X11PROTO_RENDER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_RENDER_INSTALLED}: ${NTI_X11PROTO_RENDER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
		make install \
	)
#		mkdir -p ` dirname ${NTI_X11PROTO_RENDER_INSTALLED} ` ;\
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/renderproto.pc ${NTI_X11PROTO_RENDER_INSTALLED} \

.PHONY: nti-x11proto-render
nti-x11proto-render: nti-pkg-config ${NTI_X11PROTO_RENDER_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-render

endif	# HAVE_X11PROTO_RENDER_CONFIG
