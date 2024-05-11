# libXrender v0.9.5             [ since v0.9.4 c.2009-09-09 ]
# last mod WmT, 2013-01-04	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXRENDER_CONFIG},y)
HAVE_LIBXRENDER_CONFIG:=y

#DESCRLIST+= "'nti-libXrender' -- libXrender"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXRENDER_VERSION},)
LIBXRENDER_VERSION=0.9.5
endif

LIBXRENDER_SRC=${SOURCES}/l/libXrender-${LIBXRENDER_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXrender-${LIBXRENDER_VERSION}.tar.bz2

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
#include ${CFG_ROOT}/gui/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.20.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-render/v0.11.mak

NTI_LIBXRENDER_TEMP=nti-libXrender-${LIBXRENDER_VERSION}

NTI_LIBXRENDER_EXTRACTED=${EXTTEMP}/${NTI_LIBXRENDER_TEMP}/configure
NTI_LIBXRENDER_CONFIGURED=${EXTTEMP}/${NTI_LIBXRENDER_TEMP}/config.status
NTI_LIBXRENDER_BUILT=${EXTTEMP}/${NTI_LIBXRENDER_TEMP}/xrender.pc
NTI_LIBXRENDER_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xrender.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXRENDER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXrender-${LIBXRENDER_VERSION} ] || rm -rf ${EXTTEMP}/libXrender-${LIBXRENDER_VERSION}
	bzcat ${LIBXRENDER_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXRENDER_TEMP}
	mv ${EXTTEMP}/libXrender-${LIBXRENDER_VERSION} ${EXTTEMP}/${NTI_LIBXRENDER_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBXRENDER_CONFIGURED}: ${NTI_LIBXRENDER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
	  ac_cv_search_gettext=no \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXRENDER_BUILT}: ${NTI_LIBXRENDER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXRENDER_INSTALLED}: ${NTI_LIBXRENDER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXrender
nti-libXrender: nti-pkg-config \
	nti-x11proto nti-x11proto-render \
	${NTI_LIBXRENDER_INSTALLED}

ALL_NTI_TARGETS+= nti-libXrender

endif	# HAVE_LIBXRENDER_CONFIG
