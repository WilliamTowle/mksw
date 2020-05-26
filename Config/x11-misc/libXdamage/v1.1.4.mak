# libXdamage v1.1.4		[ since v1.1.3, 2015-09-23 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXDAMAGE_CONFIG},y)
HAVE_LIBXDAMAGE_CONFIG:=y

#DESCRLIST+= "'nti-libXdamage' -- libXdamage"

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXDAMAGE_VERSION},)
LIBXDAMAGE_VERSION=1.1.4
endif

LIBXDAMAGE_SRC=${SOURCES}/l/libXdamage-${LIBXDAMAGE_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/libXdamage-1.1.4.tar.bz2

include ${CFG_ROOT}/x11-misc/x11proto-damage/v1.2.0.mak
include ${CFG_ROOT}/x11-misc/libXfixes/v5.0.1.mak
include ${CFG_ROOT}/x11-misc/x11proto-fixes/v5.0.mak
include ${CFG_ROOT}/x11-misc/x11proto-xext/v7.2.1.mak
include ${CFG_ROOT}/x11-misc/libX11/v1.6.2.mak
include ${CFG_ROOT}/x11-misc/util-macros/v1.17.1.mak

NTI_LIBXDAMAGE_TEMP=nti-libXdamage-${LIBXDAMAGE_VERSION}

NTI_LIBXDAMAGE_EXTRACTED=${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP}/configure
NTI_LIBXDAMAGE_CONFIGURED=${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP}/config.status
NTI_LIBXDAMAGE_BUILT=${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP}/xdamage.pc
NTI_LIBXDAMAGE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xdamage.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXDAMAGE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXdamage-${LIBXDAMAGE_VERSION} ] || rm -rf ${EXTTEMP}/libXdamage-${LIBXDAMAGE_VERSION}
	bzcat ${LIBXDAMAGE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP}
	mv ${EXTTEMP}/libXdamage-${LIBXDAMAGE_VERSION} ${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXDAMAGE_CONFIGURED}: ${NTI_LIBXDAMAGE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP} || exit 1 ;\
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

${NTI_LIBXDAMAGE_BUILT}: ${NTI_LIBXDAMAGE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXDAMAGE_INSTALLED}: ${NTI_LIBXDAMAGE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXDAMAGE_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXdamage
nti-libXdamage: nti-pkg-config \
	nti-x11proto-damage nti-libXfixes nti-x11proto-fixes \
	nti-x11proto-xext \
	nti-libX11 nti-util-macros \
	${NTI_LIBXDAMAGE_INSTALLED}

ALL_NTI_TARGETS+= nti-libXdamage

endif	# HAVE_LIBXDAMAGE_CONFIG
