# mesalib v9.2.0		[ earliest v9.2.0, c.2015-09-22 ]
# last mod WmT, 2015-10-20	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_MESALIB_CONFIG},y)
HAVE_MESALIB_CONFIG:=y

#DESCRLIST+= "'nti-mesalib' -- mesalib"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/autoconf/v2.69.mak
#include ${CFG_ROOT}/buildtools/automake/v1.14.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
#include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${MESALIB_VERSION},)
MESALIB_VERSION=9.2.0
endif

MESALIB_SRC=${SOURCES}/m/MesaLib-9.2.0.tar.bz2
#URLS+= ftp://ftp.freedesktop.org/pub/mesa/11.0.2/mesa-11.0.2.tar.gz
URLS+= ftp://ftp.freedesktop.org/pub/mesa/older-versions/9.x/9.2/MesaLib-9.2.0.tar.bz2

## also needs: python, python-libxml2, libexpat1-dev
include ${CFG_ROOT}/gui/x11proto-gl/v1.4.16.mak
include ${CFG_ROOT}/gui/libdrm/v2.4.46.mak
include ${CFG_ROOT}/gui/x11proto-dri2/v2.6.mak
#include ${CFG_ROOT}/gui/x11proto-dri3/v1.0.mak
#include ${CFG_ROOT}/gui/x11proto-present/v1.0.mak
#include ${CFG_ROOT}/gui/libxcb/v1.9.1.mak
#include ${CFG_ROOT}/gui/libxshmfence/v1.2.mak
include ${CFG_ROOT}/x11-misc/libX11/v1.6.2.mak
include ${CFG_ROOT}/x11-misc/libXext/v1.3.2.mak
include ${CFG_ROOT}/x11-misc/libXdamage/v1.1.4.mak
### ...
#include ${CFG_ROOT}/misc/expat/v2.1.0.mak
##include ${CFG_ROOT}/misc/libudev/v175.mak

NTI_MESALIB_TEMP=nti-MesaLib-${MESALIB_VERSION}

NTI_MESALIB_EXTRACTED=${EXTTEMP}/${NTI_MESALIB_TEMP}/autogen.sh
NTI_MESALIB_CONFIGURED=${EXTTEMP}/${NTI_MESALIB_TEMP}/config.log
NTI_MESALIB_BUILT=${EXTTEMP}/${NTI_MESALIB_TEMP}/lib/libEGL.so.1
NTI_MESALIB_INSTALLED=${NTI_TC_ROOT}/usr/lib/libEGL.so.1


## ,-----
## |	Extract
## +-----

${NTI_MESALIB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/Mesa-${MESALIB_VERSION} ] || rm -rf ${EXTTEMP}/Mesa-${MESALIB_VERSION}
	bzcat ${MESALIB_SRC} | tar xvf - -C ${EXTTEMP}
	#zcat ${MESALIB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_MESALIB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_MESALIB_TEMP}
	mv ${EXTTEMP}/Mesa-${MESALIB_VERSION} ${EXTTEMP}/${NTI_MESALIB_TEMP}


## ,-----
## |	Configure
## +-----

## --enable-dri because "egl requires --enable-dri"?
## imx6 config: see http://pushpopmov.blogspot.co.uk/2015/01/xserver-from-scratch-on-imx6.html
## imx6: checks for 'XF86VIDMODE'; doesn't fail
## imx6: is "i915, i965" in $DRI_DIRS? (implies libdrm_intel requirement?)

MESALIB_UNAME_M:=$(shell uname -m)
ifeq (${MESALIB_UNAME_M},armv7l)
## [2015-10-13] recommended to fix "relocation ..." problem
MESALIB_CFLAGS=-fPIC
## [2015-10-13] can want libdrm_intel, which is not built
#MESALIB_CONFIGURE_ARGS=--build=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --host=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --target=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --with-dri-drivers=swrast
## [2015-10-13] full "minimum Mesa configuration" [pushpopmov.blogspot.co.uk]
#MESALIB_CONFIGURE_ARGS=--build=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --host=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --target=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --with-dri-drivers=swrast --disable-egl --disable-gbm --disable-gallium-egl --disable-gallium-llvm --disable-gallium-gbm --with-gallium-drivers="" --disable-shared-glapi --disable-glx
MESALIB_CONFIGURE_ARGS=--build=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --host=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --target=${MESALIB_UNAME_M}-unknown-linux-gnueabihf --with-dri-drivers=swrast --disable-egl --disable-gbm --disable-gallium-egl --disable-gallium-llvm --disable-gallium-gbm --with-gallium-drivers="" --disable-shared-glapi
else
## [2015-10-12] --host=x86_64 alone causes ld/nm detection failure
MESALIB_CFLAGS=
#MESALIB_CONFIGURE_ARGS=--host=${MESALIB_UNAME_M}
MESALIB_CONFIGURE_ARGS=--disable-gallium-egl --disable-gallium-llvm \
			 --disable-gallium-gbm --with-gallium-drivers=""
endif

${NTI_MESALIB_CONFIGURED}: ${NTI_MESALIB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_MESALIB_TEMP} || exit 1 ;\
		for SD in src/mesa src/mesa/drivers/dri src/egl/main ; do \
			[ -r $${SD}/Makefile.am.OLD ] || cp $${SD}/Makefile.am $${SD}/Makefile.am.OLD || exit 1 ;\
			cat $${SD}/Makefile.am.OLD \
				| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
				> $${SD}/Makefile.am ;\
		done ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		cat configure.OLD \
			| sed 's/`pkg-config/`$${PKG_CONFIG}/' \
			> configure ;\
		ACLOCAL='aclocal -I'${NTI_TC_ROOT}'/usr/share/aclocal' \
		  autoreconf -fi || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS="${MESALIB_CFLAGS}" \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
	  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-intel --disable-radeon --disable-nouveau \
			  ${MESALIB_CONFIGURE_ARGS} \
			--enable-shared --disable-static \
			|| exit 1 \
	)
#	  CC=${NTI_GCC} \
#	  CFLAGS='-O2' \
#	  LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \
# ...
#			--enable-udev \
#			--enable-dri --enable-sysfs \
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_MESALIB_BUILT}: ${NTI_MESALIB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_MESALIB_TEMP} || exit 1 ;\
		make \
	)
#			LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \


## ,-----
## |	Install
## +-----

${NTI_MESALIB_INSTALLED}: ${NTI_MESALIB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_MESALIB_TEMP} || exit 1 ;\
		make install \
	)
#			LIBTOOL=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-libtool \

##

.PHONY: nti-mesalib
nti-mesalib: nti-pkg-config \
	nti-x11proto-dri2 \
	nti-x11proto-gl \
	nti-libdrm \
	nti-libX11 \
	nti-libXext \
	nti-libXdamage \
	${NTI_MESALIB_INSTALLED}
# buildroot mesa3d: deps on xproto_xf86driproto, libxcb
#nti-mesalib: nti-libtool nti-pkg-config ...
#nti-mesa: nti-pkg-config \
#	nti-x11proto-dri3 \
#	nti-x11proto-gl nti-x11proto-present \
#	nti-libxcb nti-libxshmfence \
#	\
#	${NTI_MESALIB_INSTALLED}
##	nti-expat \
##	nti-libudev \

ALL_NTI_TARGETS+= nti-mesalib

endif	# HAVE_MESALIB_CONFIG
