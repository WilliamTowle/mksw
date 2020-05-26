# x11proto-gl v1.4.16		[ earliest v1.4.10, c.2013-03-03 ]
# last mod WmT, 2015-10-20	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_X11PROTO_GL_CONFIG},y)
HAVE_X11PROTO_GL_CONFIG:=y

#DESCRLIST+= "'nti-x11proto-gl' -- x11proto-gl"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${X11PROTO_GL_VERSION},)
#X11PROTO_GL_VERSION=1.4.10
#X11PROTO_GL_VERSION=1.4.14
X11PROTO_GL_VERSION=1.4.16
endif

X11PROTO_GL_SRC=${SOURCES}/g/glproto-${X11PROTO_GL_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/proto/glproto-1.4.10.tar.bz2
URLS+= http://www.x.org/releases/individual/proto/glproto-${X11PROTO_GL_VERSION}.tar.bz2

include ${CFG_ROOT}/gui/util-macros/v1.17.1.mak

NTI_X11PROTO_GL_TEMP=nti-x11proto-gl-${X11PROTO_GL_VERSION}

NTI_X11PROTO_GL_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_GL_TEMP}/configure
NTI_X11PROTO_GL_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_GL_TEMP}/config.status
NTI_X11PROTO_GL_BUILT=${EXTTEMP}/${NTI_X11PROTO_GL_TEMP}/glproto.pc
NTI_X11PROTO_GL_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/glproto.pc


## ,-----
## |	Extract
## +-----

${NTI_X11PROTO_GL_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/glproto-${X11PROTO_GL_VERSION} ] || rm -rf ${EXTTEMP}/glproto-${X11PROTO_GL_VERSION}
	bzcat ${X11PROTO_GL_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_GL_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_GL_TEMP}
	mv ${EXTTEMP}/glproto-${X11PROTO_GL_VERSION} ${EXTTEMP}/${NTI_X11PROTO_GL_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_X11PROTO_GL_CONFIGURED}: ${NTI_X11PROTO_GL_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_GL_TEMP} || exit 1 ;\
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

${NTI_X11PROTO_GL_BUILT}: ${NTI_X11PROTO_GL_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_GL_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_X11PROTO_GL_INSTALLED}: ${NTI_X11PROTO_GL_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_GL_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-gl
nti-x11proto-gl: nti-pkg-config \
	nti-util-macros ${NTI_X11PROTO_GL_INSTALLED}

ALL_NTI_TARGETS+= nti-x11proto-gl

endif	# HAVE_X11PROTO_GL_CONFIG
