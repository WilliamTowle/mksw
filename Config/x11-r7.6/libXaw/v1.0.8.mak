# libXaw v1.0.8			[ since v1.0.7,	2013-04-13 ]
# last mod WmT, 2015-10-21	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXAW_CONFIG},y)
HAVE_LIBXAW_CONFIG:=y

#DESCRLIST+= "'nti-libXaw' -- libXaw"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.6/libX11/v1.4.0.mak
include ${CFG_ROOT}/x11-r7.6/libXext/v1.2.0.mak
include ${CFG_ROOT}/x11-r7.6/libXmu/v1.1.0.mak
include ${CFG_ROOT}/x11-r7.6/libXt/v1.0.9.mak
include ${CFG_ROOT}/x11-r7.6/x11proto-xext/v7.1.2.mak

ifeq (${LIBXAW_VERSION},)
#LIBXAW_VERSION=1.0.7
LIBXAW_VERSION=1.0.8
endif

LIBXAW_SRC=${SOURCES}/l/libXaw-${LIBXAW_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/everything/libXaw-1.0.7.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/libXaw-1.0.8.tar.bz2

NTI_LIBXAW_TEMP=nti-libXaw-${LIBXAW_VERSION}

NTI_LIBXAW_EXTRACTED=${EXTTEMP}/${NTI_LIBXAW_TEMP}/configure
NTI_LIBXAW_CONFIGURED=${EXTTEMP}/${NTI_LIBXAW_TEMP}/config.status
NTI_LIBXAW_BUILT=${EXTTEMP}/${NTI_LIBXAW_TEMP}/xaw6.pc
NTI_LIBXAW_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xaw7.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXAW_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXaw-${LIBXAW_VERSION} ] || rm -rf ${EXTTEMP}/libXaw-${LIBXAW_VERSION}
	bzcat ${LIBXAW_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXAW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXAW_TEMP}
	mv ${EXTTEMP}/libXaw-${LIBXAW_VERSION} ${EXTTEMP}/${NTI_LIBXAW_TEMP}



## ,-----
## |	Configure
## +-----

## 2014-02-19: no specs: modern pdf/postscript generation tools barf :(

${NTI_LIBXAW_CONFIGURED}: ${NTI_LIBXAW_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			./configure \
			  --prefix=${NTI_TC_ROOT}/usr \
			  --bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
				|| exit 1 ;\
		mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^SUBDIRS/	s/spec[s]*//' \
			> Makefile || exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXAW_BUILT}: ${NTI_LIBXAW_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXAW_INSTALLED}: ${NTI_LIBXAW_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXaw
nti-libXaw: nti-pkg-config nti-libX11 nti-libXext nti-libXmu nti-libXt nti-x11proto-xext ${NTI_LIBXAW_INSTALLED}

ALL_NTI_TARGETS+= nti-libXaw

endif	# HAVE_LIBXAW_CONFIG
