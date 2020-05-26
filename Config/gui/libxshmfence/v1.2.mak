# libxshmfence v1.2		[ since v1.2, c.2015-09-29 ]
# last mod WmT, 2015-10-14	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_LIBXSHMFENCE_CONFIG},y)
HAVE_LIBXSHMFENCE_CONFIG:=y

#DESCRLIST+= "'nti-libxshmfence' -- libxshmfence"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXSHMFENCE_VERSION},)
LIBXSHMFENCE_VERSION=1.2
endif
LIBXSHMFENCE_SRC=${SOURCES}/l/libxshmfence-${LIBXSHMFENCE_VERSION}.tar.bz2
URLS+= http://www.x.org/releases/individual/lib/libxshmfence-1.2.tar.bz2

## deps?
#include ${CFG_ROOT}/gui/libXau/v1.0.7.mak

NTI_LIBXSHMFENCE_TEMP=nti-libxshmfence-${LIBXSHMFENCE_VERSION}

NTI_LIBXSHMFENCE_EXTRACTED=${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP}/configure
NTI_LIBXSHMFENCE_CONFIGURED=${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP}/config.status
NTI_LIBXSHMFENCE_BUILT=${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP}/xshmfence.pc
NTI_LIBXSHMFENCE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xshmfence.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXSHMFENCE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libxshmfence-${LIBXSHMFENCE_VERSION} ] || rm -rf ${EXTTEMP}/libxshmfence-${LIBXSHMFENCE_VERSION}
	bzcat ${LIBXSHMFENCE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP}
	mv ${EXTTEMP}/libxshmfence-${LIBXSHMFENCE_VERSION} ${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXSHMFENCE_CONFIGURED}: ${NTI_LIBXSHMFENCE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP} || exit 1 ;\
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

${NTI_LIBXSHMFENCE_BUILT}: ${NTI_LIBXSHMFENCE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBXSHMFENCE_INSTALLED}: ${NTI_LIBXSHMFENCE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXSHMFENCE_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libxshmfence
nti-libxshmfence: nti-pkg-config \
	${NTI_LIBXSHMFENCE_INSTALLED}

ALL_NTI_TARGETS+= nti-libxshmfence

endif	# HAVE_LIBXSHMFENCE_CONFIG
