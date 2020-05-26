# libdrm v2.4.46		[ since v2.4.15, 2014-03-06 ]
# last mod WmT, 2016-01-13	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_LIBDRM_CONFIG},y)
HAVE_LIBDRM_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-libdrm' -- libdrm"

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.6.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.29.mak

ifeq (${LIBDRM_VERSION},)
#LIBDRM_VERSION=2.4.15
LIBDRM_VERSION=2.4.46
endif

LIBDRM_SRC=${SOURCES}/l/libdrm-${LIBDRM_VERSION}.tar.bz2
URLS+= http://dri.freedesktop.org/libdrm/libdrm-${LIBDRM_VERSION}.tar.bz2
LIBDRM_PATCHES=${SOURCES}/d/drm-update-arm.patch
URLS+= https://raw.githubusercontent.com/Freescale/meta-fsl-arm/master/recipes-graphics/drm/libdrm/mx6/drm-update-arm.patch

include ${CFG_ROOT}/x11-misc/libpthread-stubs/v0.3.mak
include ${CFG_ROOT}/x11-misc/libpciaccess/v0.13.1.mak

NTI_LIBDRM_TEMP=nti-libdrm-${LIBDRM_VERSION}

NTI_LIBDRM_EXTRACTED=${EXTTEMP}/${NTI_LIBDRM_TEMP}/configure
NTI_LIBDRM_CONFIGURED=${EXTTEMP}/${NTI_LIBDRM_TEMP}/config.status
NTI_LIBDRM_BUILT=${EXTTEMP}/${NTI_LIBDRM_TEMP}/libdrm.pc
NTI_LIBDRM_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/libdrm.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBDRM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libdrm-${LIBDRM_VERSION} ] || rm -rf ${EXTTEMP}/libdrm-${LIBDRM_VERSION}
	bzcat ${LIBDRM_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${LIBDRM_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${LIBDRM_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} || exit 1 ;\
			patch --batch -d libdrm-${LIBDRM_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_LIBDRM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBDRM_TEMP}
	mv ${EXTTEMP}/libdrm-${LIBDRM_VERSION} ${EXTTEMP}/${NTI_LIBDRM_TEMP}


## ,-----
## |	Configure
## +-----

# on intel, for desktop? or under simulation, for imx6?
LIBDRM_UNAME_M:=$(shell uname -m)
ifeq (${LIBDRM_UNAME_M},armv7l)
LIBDRM_CFLAGS=		-fPIC
LIBDRM_CONFIGURE_OPTS=	--build=${HOSTSPEC} \
			--host=arm
else
LIBDRM_CFLAGS=
LIBDRM_CONFIGURE_OPTS=	--build=${HOSTSPEC} \
			--host=${HOSTSPEC} \
			--enable-intel
endif

${NTI_LIBDRM_CONFIGURED}: ${NTI_LIBDRM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBDRM_TEMP} || exit 1 ;\
		[ -r configure.OLD ] || mv configure configure.OLD || exit 1 ;\
		cat configure.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$${prefix}/'${HOSTSPEC}'/lib/pkgconfig%' \
			> configure ;\
		chmod a+x configure ;\
		CC=${NTI_GCC} \
		  CFLAGS=${LIBDRM_CFLAGS} \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  	./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  ${LIBDRM_CONFIGURE_OPTS} \
			  --enable-shared --disable-static \
				|| exit 1 \
	)
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_LIBDRM_BUILT}: ${NTI_LIBDRM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBDRM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBDRM_INSTALLED}: ${NTI_LIBDRM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBDRM_TEMP} || exit 1 ;\
		make install \
	)
#		mkdir -p ` dirname ${NTI_LIBDRM_INSTALLED} ` ;\
#		cp libdrm.pc libdrm_intel.pc ` dirname ${NTI_LIBDRM_INSTALLED} ` \

.PHONY: nti-libdrm
nti-libdrm: nti-pkg-config \
	nti-libpciaccess nti-libpthread-stubs \
	${NTI_LIBDRM_INSTALLED}

ALL_NTI_TARGETS+= nti-libdrm

endif	# HAVE_LIBDRM_CONFIG
