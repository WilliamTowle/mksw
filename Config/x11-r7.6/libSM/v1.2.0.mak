# libSM v1.2.0			[ since v1.1.0 c.2009-09-08 ]
# last mod WmT, 2018-01-15	[ (c) and GPLv2 1999-2018* ]

ifneq (${HAVE_LIBSM_CONFIG},y)
HAVE_LIBSM_CONFIG:=y

#DESCRLIST+= "'nti-libSM' -- libSM"

#include ${CFG_ROOT}/ENV/ifbuild.env
#ifeq (${ACTION},buildn)
#include ${CFG_ROOT}/ENV/native.mak
#else
#include ${CFG_ROOT}/ENV/target.mak
#endif
#
#ifneq (${HAVE_CROSS_GCC_VERSION},)
#include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VERSION}.mak
#include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VERSION}.mak
#endif


ifeq (${LIBSM_VERSION},)
#LIBSM_VERSION=1.1.1
LIBSM_VERSION=1.2.0
endif
#LIBSM_SRC=${SOURCES}/l/libsm_1.1.0.orig.tar.gz
LIBSM_SRC=${SOURCES}/l/libSM-${LIBSM_VERSION}.tar.bz2

#URLS+= http://www.x.org/releases/X11R7.5/src/lib/libSM-1.1.1.tar.bz2
URLS+= http://www.x.org/releases/X11R7.6/src/lib/libSM-1.2.0.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.6/libICE/v1.0.7.mak

NTI_LIBSM_TEMP=nti-libSM-${LIBSM_VERSION}

NTI_LIBSM_EXTRACTED=${EXTTEMP}/${NTI_LIBSM_TEMP}/configure
NTI_LIBSM_CONFIGURED=${EXTTEMP}/${NTI_LIBSM_TEMP}/config.status
NTI_LIBSM_BUILT=${EXTTEMP}/${NTI_LIBSM_TEMP}/sm.pc
NTI_LIBSM_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/sm.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBSM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libSM-${LIBSM_VERSION} ] || rm -rf ${EXTTEMP}/libSM-${LIBSM_VERSION}
	bzcat ${LIBSM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBSM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBSM_TEMP}
	mv ${EXTTEMP}/libSM-${LIBSM_VERSION} ${EXTTEMP}/${NTI_LIBSM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBSM_CONFIGURED}: ${NTI_LIBSM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBSM_TEMP} || exit 1 ;\
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
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			--without-libuuid \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LIBSM_BUILT}: ${NTI_LIBSM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBSM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBSM_INSTALLED}: ${NTI_LIBSM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBSM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libSM
nti-libSM: nti-pkg-config nti-libICE nti-x11proto ${NTI_LIBSM_INSTALLED}

ALL_NTI_TARGETS+= nti-libSM

endif	# HAVE_LIBSM_CONFIG
