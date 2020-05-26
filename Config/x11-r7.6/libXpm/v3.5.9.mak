# libXpm v3.5.9		[ since v3.5.7, c.2009-09-08 ]
# last mod WmT, 2013-01-04	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBXPM_CONFIG},y)
HAVE_LIBXPM_CONFIG:=y

#DESCRLIST+= "'nti-libXpm' -- libXpm"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LIBXPM_VERSION},)
#LIBXPM_VERSION=3.5.8
LIBXPM_VERSION=3.5.9
endif
#LIBXPM_SRC=${SOURCES}/l/libxpm_3.5.7.orig.tar.gz
LIBXPM_SRC=${SOURCES}/l/libXpm-${LIBXPM_VERSION}.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXpm-3.5.8.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/lib/libXpm-3.5.9.tar.bz2

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/gui/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.6/x11proto/v7.0.20.mak


NTI_LIBXPM_TEMP=nti-libXpm-${LIBXPM_VERSION}

NTI_LIBXPM_EXTRACTED=${EXTTEMP}/${NTI_LIBXPM_TEMP}/configure
NTI_LIBXPM_CONFIGURED=${EXTTEMP}/${NTI_LIBXPM_TEMP}/config.status
NTI_LIBXPM_BUILT=${EXTTEMP}/${NTI_LIBXPM_TEMP}/xpm.pc
NTI_LIBXPM_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xpm.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXPM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXpm-${LIBXPM_VERSION} ] || rm -rf ${EXTTEMP}/libXpm-${LIBXPM_VERSION}
	bzcat ${LIBXPM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXPM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXPM_TEMP}
	mv ${EXTTEMP}/libXpm-${LIBXPM_VERSION} ${EXTTEMP}/${NTI_LIBXPM_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBXPM_CONFIGURED}: ${NTI_LIBXPM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXPM_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ac_cv_search_gettext=no \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXPM_BUILT}: ${NTI_LIBXPM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXPM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXPM_INSTALLED}: ${NTI_LIBXPM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXPM_TEMP} || exit 1 ;\
		make install \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/xpm.pc ${NTI_LIBXPM_INSTALLED} \

.PHONY: nti-libXpm
nti-libXpm: nti-pkg-config nti-x11proto nti-libX11 ${NTI_LIBXPM_INSTALLED}

ALL_NTI_TARGETS+= nti-libXpm

endif	# HAVE_LIBXPM_CONFIG
