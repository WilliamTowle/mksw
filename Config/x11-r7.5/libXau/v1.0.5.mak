# libXau v1.0.5			[ since v1.0.4	2008-06-12 ]
# last mod WmT, 2013-03-06	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBXAU_CONFIG},y)
HAVE_LIBXAU_CONFIG:=y

#DESCRLIST+= "'nti-libXau' -- libXau"
#DESCRLIST+= "'cti-libXau' -- libXau"

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak

ifeq (${LIBXAU_VERSION},)
LIBXAU_VERSION=1.0.5
endif

LIBXAU_SRC=${SOURCES}/l/libXau-${LIBXAU_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/X11R7.5/src/lib/libXau-1.0.5.tar.bz2

include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.23.mak


NTI_LIBXAU_TEMP=nti-libXau-${LIBXAU_VERSION}

NTI_LIBXAU_EXTRACTED=${EXTTEMP}/${NTI_LIBXAU_TEMP}/configure
NTI_LIBXAU_CONFIGURED=${EXTTEMP}/${NTI_LIBXAU_TEMP}/config.status
NTI_LIBXAU_BUILT=${EXTTEMP}/${NTI_LIBXAU_TEMP}/xau.pc
NTI_LIBXAU_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xau.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXAU_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXau-${LIBXAU_VERSION} ] || rm -rf ${EXTTEMP}/libXau-${LIBXAU_VERSION}
	bzcat ${LIBXAU_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXAU_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXAU_TEMP}
	mv ${EXTTEMP}/libXau-${LIBXAU_VERSION} ${EXTTEMP}/${NTI_LIBXAU_TEMP}



## ,-----
## |	Configure
## +-----

${NTI_LIBXAU_CONFIGURED}: ${NTI_LIBXAU_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAU_TEMP} || exit 1 ;\
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
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBXAU_BUILT}: ${NTI_LIBXAU_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAU_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXAU_INSTALLED}: ${NTI_LIBXAU_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAU_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXau
nti-libXau: nti-pkg-config nti-x11proto ${NTI_LIBXAU_INSTALLED}

ALL_NTI_TARGETS+= nti-libXau

endif	# HAVE_LIBXAU_CONFIG
