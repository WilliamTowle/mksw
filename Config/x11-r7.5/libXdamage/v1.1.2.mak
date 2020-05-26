# libXdamage v1.1.2		[ since v1.1.2, c. 2017-04-07 ]
# last mod WmT, 2017-04-07	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_LIBXDAMAGE_CONFIG},y)
HAVE_LIBXDAMAGE_CONFIG:=y

#DESCRLIST+= "'nti-libXdamage' -- libXdamage"

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXDAMAGE_VERSION},)
LIBXDAMAGE_VERSION=1.1.2
endif

LIBXDAMAGE_SRC=${SOURCES}/l/libXdamage-${LIBXDAMAGE_VERSION}.tar.bz2
URLS+= https://www.x.org/releases/X11R7.5/src/lib/libXdamage-1.1.2.tar.bz2


include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/libXfixes/v4.0.4.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-damage/v1.2.0.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-fixes/v4.1.1.mak

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
	nti-libX11 nti-libXfixes \
	nti-x11proto-damage nti-x11proto-fixes \
	${NTI_LIBXDAMAGE_INSTALLED}

ALL_NTI_TARGETS+= nti-libXdamage

endif	# HAVE_LIBXDAMAGE_CONFIG
