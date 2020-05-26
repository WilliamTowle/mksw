# mesa v12.0.6			[ since v11.0.0, c.2015-09-22 ]
# last mod WmT, 2015-09-22	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBGL_MESA_CONFIG},y)
HAVE_LIBGL_MESA_CONFIG:=y

#DESCRLIST+= "'nti-mesa' -- mesa"

include ${CFG_ROOT}/ENV/buildtype.mak

##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak


ifeq (${MESA_VERSION},)
#MESA_VERSION=11.0.0
#MESA_VERSION=11.0.2
MESA_VERSION=12.0.6
endif

#MESA_SRC=${SOURCES}/m/mesa_${MESA_VERSION}.orig.tar.gz
MESA_SRC=${SOURCES}/m/mesa-${MESA_VERSION}.tar.gz
#URLS+= http://www.mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mesa/mesa_11.0.0.orig.tar.gz
URLS+= ftp://ftp.freedesktop.org/pub/mesa/12.0.6/mesa-12.0.6.tar.gz

#include ${CFG_ROOT}/gui/x11proto-gl/v1.4.15.mak
#include ${CFG_ROOT}/gui/libdrm/v2.4.65.mak
#include ${CFG_ROOT}/gui/x11proto-dri2/v2.6.mak
#include ${CFG_ROOT}/x11-misc/x11proto-dri3/v1.0.mak
#include ${CFG_ROOT}/x11-r7.5/x11proto-present/v1.0.mak

#include ${CFG_ROOT}/gui/libxcb/v1.11.mak
#include ${CFG_ROOT}/gui/libxshmfence/v1.2.mak
#include ${CFG_ROOT}/x11-misc/libX11/v1.5.0.mak
#include ${CFG_ROOT}/gui/libXext/v1.3.1.mak
#include ${CFG_ROOT}/gui/libXdamage/v1.1.3.mak
##...
#include ${CFG_ROOT}/misc/expat/v2.1.0.mak

NTI_LIBGL_MESA_TEMP=nti-mesa-${MESA_VERSION}

NTI_LIBGL_MESA_EXTRACTED=${EXTTEMP}/${NTI_LIBGL_MESA_TEMP}/autogen.sh
NTI_LIBGL_MESA_CONFIGURED=${EXTTEMP}/${NTI_LIBGL_MESA_TEMP}/config.log
NTI_LIBGL_MESA_BUILT=${EXTTEMP}/${NTI_LIBGL_MESA_TEMP}/src/mesa/libmesa.la
NTI_LIBGL_MESA_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/gl.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBGL_MESA_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/mesa-${MESA_VERSION} ] || rm -rf ${EXTTEMP}/mesa-${MESA_VERSION}
	zcat ${MESA_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBGL_MESA_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBGL_MESA_TEMP}
	mv ${EXTTEMP}/mesa-${MESA_VERSION} ${EXTTEMP}/${NTI_LIBGL_MESA_TEMP}


## ,-----
## |	Configure
## +-----

## --enable-dri because "egl requires --enable-dri"
## --enable-sysfs?

${NTI_LIBGL_MESA_CONFIGURED}: ${NTI_LIBGL_MESA_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBGL_MESA_TEMP} || exit 1 ;\
		[ -r src/Makefile.in.OLD ] || mv src/Makefile.in src/Makefile.in.OLD || exit 1 ;\
		cat src/Makefile.in.OLD \
			| sed '/^@HAVE_GLX_TRUE@pkgconfigdir/	s%=.*%= '${PKG_CONFIG_CONFIG_HOST_PATH}'%' \
			> src/Makefile.in ;\
		PKGCONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-dri --disable-dri3 \
			--disable-gbm --disable-egl \
			--without-gallium-drivers \
			--enable-glx=xlib \
			--disable-gles1 --disable-gles2 \
			--disable-osmesa \
			--disable-sysfs \
			--disable-va \
			|| exit 1 \
	)



## ,-----
## |	Build
## +-----

${NTI_LIBGL_MESA_BUILT}: ${NTI_LIBGL_MESA_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBGL_MESA_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBGL_MESA_INSTALLED}: ${NTI_LIBGL_MESA_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBGL_MESA_TEMP} || exit 1 ;\
		make install \
	)

##

.PHONY: nti-libgl-mesa
nti-libgl-mesa: nti-pkg-config \
	${NTI_LIBGL_MESA_INSTALLED}
#	nti-x11proto-gl nti-x11proto-dri2 nti-x11proto-dri3 nti-x11proto-present \
#	nti-libdrm nti-libxcb nti-libxshmfence \
#	nti-libX11 \
#	nti-libXext \
#	nti-libXdamage \
#	\
#	nti-expat \
#	${NTI_LIBGL_MESA_INSTALLED}

ALL_NTI_TARGETS+= nti-libgl-mesa

endif	# HAVE_LIBGL_MESA_CONFIG
