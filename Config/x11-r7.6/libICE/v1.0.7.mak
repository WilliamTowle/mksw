# libICE v1.0.7			[ since v1.0.5, c.2009-09-08 ]
# last mod WmT, 2013-01-04	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBICE_CONFIG},y)
HAVE_LIBICE_CONFIG:=y

DESCRLIST+= "'nti-libICE' -- libICE"

#	include ${CFG_ROOT}/ENV/ifbuild.env
#	ifeq (${ACTION},buildn)
#	include ${CFG_ROOT}/ENV/native.mak
#	else
#	include ${CFG_ROOT}/ENV/target.mak
#	endif
#	
#	ifneq (${HAVE_CROSS_GCC_VER},)
#	include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
#	include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
#	endif

ifeq (${LIBICE_VERSION},)
#LIBICE_VERSION=1.0.6
LIBICE_VERSION=1.0.7
endif

LIBICE_SRC=${SOURCES}/l/libICE-${LIBICE_VERSION}.tar.bz2
#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libICE-1.0.6.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/lib/libICE-1.0.7.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

#include ${CFG_ROOT}/gui/libXmu/v1.0.5.mak
include ${CFG_ROOT}/x11-r7.6/libXmu/v1.1.0.mak
#include ${CFG_ROOT}/gui/libXpm/v3.5.8.mak
include ${CFG_ROOT}/x11-r7.6/libXpm/v3.5.9.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.6/x11proto/v7.0.20.mak
#include ${CFG_ROOT}/gui/xtrans/v1.2.5.mak
include ${CFG_ROOT}/x11-r7.6/xtrans/v1.2.6.mak


NTI_LIBICE_TEMP=nti-libICE-${LIBICE_VERSION}

NTI_LIBICE_EXTRACTED=${EXTTEMP}/${NTI_LIBICE_TEMP}/configure
NTI_LIBICE_CONFIGURED=${EXTTEMP}/${NTI_LIBICE_TEMP}/config.status
NTI_LIBICE_BUILT=${EXTTEMP}/${NTI_LIBICE_TEMP}/ice.pc
NTI_LIBICE_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ice.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBICE_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libICE-${LIBICE_VERSION} ] || rm -rf ${EXTTEMP}/libICE-${LIBICE_VERSION}
	bzcat ${LIBICE_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBICE_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBICE_TEMP}
	mv ${EXTTEMP}/libICE-${LIBICE_VERSION} ${EXTTEMP}/${NTI_LIBICE_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBICE_CONFIGURED}: ${NTI_LIBICE_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBICE_TEMP} || exit 1 ;\
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
			  --bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBICE_BUILT}: ${NTI_LIBICE_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBICE_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBICE_INSTALLED}: ${NTI_LIBICE_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBICE_TEMP} || exit 1 ;\
		make install \
	)
#		cp ${NTI_TC_ROOT}/usr/lib/pkgconfig/ice.pc ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ice.pc \

.PHONY: nti-libICE
nti-libICE: nti-pkg-config nti-x11proto nti-xtrans ${NTI_LIBICE_INSTALLED}

ALL_NTI_TARGETS+= nti-libICE

endif	# HAVE_LIBICE_CONFIG
