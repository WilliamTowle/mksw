# libXi v1.6.1			[ since v1.6.1 c.2018-03-15 ]
# last mod WmT, 2018-03-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBXI_CONFIG},y)
HAVE_LIBXI_CONFIG:=y

#DESCRLIST+= "'nti-libXi' -- libXi"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXI_VERSION},)
LIBXI_VERSION=1.6.1
endif

LIBXI_SRC=${SOURCES}/l/libXi-${LIBXI_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/lib/libXi-1.6.1.tar.bz2


include ${CFG_ROOT}/x11-r7.7/x11proto/v7.0.23.mak
include ${CFG_ROOT}/x11-r7.7/x11proto-input/v2.2.mak
include ${CFG_ROOT}/x11-r7.7/x11proto-xext/v7.2.1.mak
include ${CFG_ROOT}/x11-r7.7/libX11/v1.5.0.mak
include ${CFG_ROOT}/x11-r7.7/libXext/v1.3.1.mak


NTI_LIBXI_TEMP=nti-libXi-${LIBXI_VERSION}

NTI_LIBXI_EXTRACTED=${EXTTEMP}/${NTI_LIBXI_TEMP}/configure
NTI_LIBXI_CONFIGURED=${EXTTEMP}/${NTI_LIBXI_TEMP}/config.status
NTI_LIBXI_BUILT=${EXTTEMP}/${NTI_LIBXI_TEMP}/xi.pc
NTI_LIBXI_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xi.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXI_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXi-${LIBXI_VERSION} ] || rm -rf ${EXTTEMP}/libXi-${LIBXI_VERSION}
	bzcat ${LIBXI_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXI_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXI_TEMP}
	mv ${EXTTEMP}/libXi-${LIBXI_VERSION} ${EXTTEMP}/${NTI_LIBXI_TEMP}
ifeq (${LIBXI_VERSION},1.0.99.1)
	( cd ${EXTTEMP}/${NTI_LIBXI_TEMP} || exit 1 ;\
		zcat ${SRCDIR}/l/libxext_1.0.99.1-0ubuntu3.diff.gz | patch -Np1 - ;\
		chmod a+x configure \
	)
endif

## ,-----
## |	Configure
## +-----

${NTI_LIBXI_CONFIGURED}: ${NTI_LIBXI_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXI_TEMP} || exit 1 ;\
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

${NTI_LIBXI_BUILT}: ${NTI_LIBXI_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXI_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXI_INSTALLED}: ${NTI_LIBXI_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXI_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXi
nti-libXi: \
	nti-pkg-config \
	nti-x11proto nti-x11proto-input nti-x11proto-xext \
	nti-libX11 nti-libXext \
	${NTI_LIBXI_INSTALLED}

ALL_NTI_TARGETS+= nti-libXi

endif	# HAVE_LIBXI_CONFIG
