# libXfixes v4.0.4		[ since v5.0, 2015-09-23 ]
# last mod WmT, 2017-04-07	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBXFIXES_CONFIG},y)
HAVE_LIBXFIXES_CONFIG:=y

#DESCRLIST+= "'nti-libXfixes' -- libXfixes"

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXFIXES_VERSION},)
LIBXFIXES_VERSION=4.0.4
endif

LIBXFIXES_SRC=${SOURCES}/l/libXfixes-${LIBXFIXES_VERSION}.tar.bz2
URLS+= https://www.x.org/releases/X11R7.5/src/lib/libXfixes-4.0.4.tar.bz2


include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-fixes/v4.1.1.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-xext/v7.1.1.mak

NTI_LIBXFIXES_TEMP=nti-libXfixes-${LIBXFIXES_VERSION}

NTI_LIBXFIXES_EXTRACTED=${EXTTEMP}/${NTI_LIBXFIXES_TEMP}/configure
NTI_LIBXFIXES_CONFIGURED=${EXTTEMP}/${NTI_LIBXFIXES_TEMP}/config.status
NTI_LIBXFIXES_BUILT=${EXTTEMP}/${NTI_LIBXFIXES_TEMP}/xfixes.pc
NTI_LIBXFIXES_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xfixes.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXFIXES_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXfixes-${LIBXFIXES_VERSION} ] || rm -rf ${EXTTEMP}/libXfixes-${LIBXFIXES_VERSION}
	bzcat ${LIBXFIXES_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXFIXES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXFIXES_TEMP}
	mv ${EXTTEMP}/libXfixes-${LIBXFIXES_VERSION} ${EXTTEMP}/${NTI_LIBXFIXES_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXFIXES_CONFIGURED}: ${NTI_LIBXFIXES_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXFIXES_TEMP} || exit 1 ;\
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
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_LIBXFIXES_BUILT}: ${NTI_LIBXFIXES_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXFIXES_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXFIXES_INSTALLED}: ${NTI_LIBXFIXES_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXFIXES_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXfixes
nti-libXfixes: nti-pkg-config \
	nti-libX11 \
	nti-x11proto nti-x11proto-fixes nti-x11proto-xext \
	${NTI_LIBXFIXES_INSTALLED}

ALL_NTI_TARGETS+= nti-libXfixes

endif	# HAVE_LIBXFIXES_CONFIG
