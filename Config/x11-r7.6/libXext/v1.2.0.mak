# libXext v1.2.0		[ since v1.0.99.1 c.2009-09-08 ]
# last mod WmT, 2018-01-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBXEXT_CONFIG},y)
HAVE_LIBXEXT_CONFIG:=y

#DESCRLIST+= "'nti-libXext' -- libXext"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBXEXT_VERSION},)
#LIBXEXT_VERSION=1.1.1
LIBXEXT_VERSION=1.2.0
endif

#LIBXEXT_SRC=${SOURCES}/l/libxext_1.0.99.1.orig.tar.gz
#	${SRCDIR}/l/libxext_1.0.99.1-0ubuntu3.diff.gz
LIBXEXT_SRC=${SOURCES}/l/libXext-${LIBXEXT_VERSION}.tar.bz2

#URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/libx/libxext/libxext_${LIBXEXT_VERSION}.orig.tar.gz
#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXext-1.1.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/lib/libXext-1.2.0.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.6/x11proto/v7.0.20.mak
#include ${CFG_ROOT}/gui/x11proto-xext/v7.1.1.mak
include ${CFG_ROOT}/x11-r7.6/x11proto-xext/v7.1.2.mak
NTI_LIBXEXT_TEMP=nti-libXext-${LIBXEXT_VERSION}

NTI_LIBXEXT_EXTRACTED=${EXTTEMP}/${NTI_LIBXEXT_TEMP}/configure
NTI_LIBXEXT_CONFIGURED=${EXTTEMP}/${NTI_LIBXEXT_TEMP}/config.status
NTI_LIBXEXT_BUILT=${EXTTEMP}/${NTI_LIBXEXT_TEMP}/xext.pc
NTI_LIBXEXT_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xext.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXEXT_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXext-${LIBXEXT_VERSION} ] || rm -rf ${EXTTEMP}/libXext-${LIBXEXT_VERSION}
	bzcat ${LIBXEXT_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXEXT_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXEXT_TEMP}
	mv ${EXTTEMP}/libXext-${LIBXEXT_VERSION} ${EXTTEMP}/${NTI_LIBXEXT_TEMP}
ifeq (${LIBXEXT_VERSION},1.0.99.1)
	( cd ${EXTTEMP}/${NTI_LIBXEXT_TEMP} || exit 1 ;\
		zcat ${SRCDIR}/l/libxext_1.0.99.1-0ubuntu3.diff.gz | patch -Np1 - ;\
		chmod a+x configure \
	)
endif

## ,-----
## |	Configure
## +-----

${NTI_LIBXEXT_CONFIGURED}: ${NTI_LIBXEXT_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXEXT_TEMP} || exit 1 ;\
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

${NTI_LIBXEXT_BUILT}: ${NTI_LIBXEXT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXEXT_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXEXT_INSTALLED}: ${NTI_LIBXEXT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXEXT_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXext
nti-libXext: nti-pkg-config nti-x11proto nti-libX11 nti-x11proto-xext ${NTI_LIBXEXT_INSTALLED}
#nti-libXext: nti-pkg-config nti-x11proto nti-libX11 nti-x11proto-xext nti-libXau ${NTI_LIBXEXT_INSTALLED}

ALL_NTI_TARGETS+= nti-libXext

endif	# HAVE_LIBXEXT_CONFIG
