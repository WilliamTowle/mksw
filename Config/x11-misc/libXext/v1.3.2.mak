# libXext v1.3.2		[ since v1.0.99.1 c.2009-09-08 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXEXT_CONFIG},y)
HAVE_LIBXEXT_CONFIG:=y

#DESCRLIST+= "'nti-libXext' -- libXext"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXEXT_VERSION},)
#LIBXEXT_VERSION=1.1.1
#LIBXEXT_VERSION=1.2.0
LIBXEXT_VERSION=1.3.2
endif

#LIBXEXT_SRC=${SOURCES}/l/libxext_1.0.99.1.orig.tar.gz
#	${SRCDIR}/l/libxext_1.0.99.1-0ubuntu3.diff.gz
LIBXEXT_SRC=${SOURCES}/l/libXext-${LIBXEXT_VERSION}.tar.bz2

#URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/libx/libxext/libxext_${LIBXEXT_VERSION}.orig.tar.gz
#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXext-1.1.1.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/lib/libXext-1.2.0.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/libXext-1.3.2.tar.bz2

include ${CFG_ROOT}/x11-misc/libX11/v1.6.2.mak
include ${CFG_ROOT}/x11-misc/x11proto-xext/v7.2.1.mak


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
nti-libXext: nti-pkg-config \
	nti-libX11 nti-x11proto-xext \
	${NTI_LIBXEXT_INSTALLED}

ALL_NTI_TARGETS+= nti-libXext

endif	# HAVE_LIBXEXT_CONFIG
