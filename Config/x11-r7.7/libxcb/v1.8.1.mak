# libxcb v1.8.1			[ since v1.9, c.2013-01-04 ]
# last mod WmT, 2018-03-12	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBXCB_CONFIG},y)
HAVE_LIBXCB_CONFIG:=y

#DESCRLIST+= "'nti-libxcb' -- libxcb"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${LIBXCB_VERSION},)
#LIBXCB_VERSION=1.7
LIBXCB_VERSION=1.8.1
endif

LIBXCB_SRC=${SOURCES}/l/libxcb-${LIBXCB_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.6/src/xcb/libxcb-1.7.tar.bz2
URLS+= http://www.x.org/releases/X11R7.7/src/xcb/libxcb-1.8.1.tar.bz2

include ${CFG_ROOT}/x11-r7.7/x11proto/v7.0.23.mak
include ${CFG_ROOT}/x11-r7.7/x11proto-xcb/v1.7.1.mak
include ${CFG_ROOT}/x11-r7.7/libpthread-stubs/v0.3.mak
include ${CFG_ROOT}/x11-r7.7/libXau/v1.0.7.mak
include ${CFG_ROOT}/misc/libxslt/v1.1.28.mak

NTI_LIBXCB_TEMP=nti-libxcb-${LIBXCB_VERSION}

NTI_LIBXCB_EXTRACTED=${EXTTEMP}/${NTI_LIBXCB_TEMP}/configure
NTI_LIBXCB_CONFIGURED=${EXTTEMP}/${NTI_LIBXCB_TEMP}/config.status
NTI_LIBXCB_BUILT=${EXTTEMP}/${NTI_LIBXCB_TEMP}/xcb.pc
NTI_LIBXCB_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xcb.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXCB_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libxcb-${LIBXCB_VERSION} ] || rm -rf ${EXTTEMP}/libxcb-${LIBXCB_VERSION}
	bzcat ${LIBXCB_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXCB_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXCB_TEMP}
	mv ${EXTTEMP}/libxcb-${LIBXCB_VERSION} ${EXTTEMP}/${NTI_LIBXCB_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXCB_CONFIGURED}: ${NTI_LIBXCB_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
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
			  --enable-shared --disable-static \
				|| exit 1 \
	)
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----

${NTI_LIBXCB_BUILT}: ${NTI_LIBXCB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXCB_INSTALLED}: ${NTI_LIBXCB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libxcb
nti-libxcb: nti-pkg-config nti-libxslt \
	nti-x11proto nti-x11proto-xcb nti-libpthread-stubs nti-libXau \
	${NTI_LIBXCB_INSTALLED}

ALL_NTI_TARGETS+= nti-libxcb

endif	# HAVE_LIBXCB_CONFIG
