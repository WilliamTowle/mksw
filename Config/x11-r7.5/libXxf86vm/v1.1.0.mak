# libXxf86vm v1.1.0		[ since v1.1.0 c.2017-04-07 ]
# last mod WmT, 2017-04-07	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_LIBXXF86VM_CONFIG},y)
HAVE_LIBXXF86VM_CONFIG:=y

DESCRLIST+= "'nti-libXxf86vm' -- libXxf86vm"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

ifeq (${LIBXXF86VM_VERSION},)
LIBXXF86VM_VERSION=1.1.0
endif

LIBXXF86VM_SRC=${SOURCES}/l/libXxf86vm-${LIBXXF86VM_VERSION}.tar.bz2
URLS+= https://www.x.org/releases/X11R7.5/src/lib/libXxf86vm-1.1.0.tar.bz2

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/libXext/v1.1.1.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-xext/v7.1.1.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-xf86vidmode/v2.3.mak


NTI_LIBXXF86VM_TEMP=nti-libXxf86vm-${LIBXXF86VM_VERSION}

NTI_LIBXXF86VM_EXTRACTED=${EXTTEMP}/${NTI_LIBXXF86VM_TEMP}/configure
NTI_LIBXXF86VM_CONFIGURED=${EXTTEMP}/${NTI_LIBXXF86VM_TEMP}/config.status
NTI_LIBXXF86VM_BUILT=${EXTTEMP}/${NTI_LIBXXF86VM_TEMP}/xxf86vm.pc
NTI_LIBXXF86VM_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xxf86vm.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBXXF86VM_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libXxf86vm-${LIBXXF86VM_VERSION} ] || rm -rf ${EXTTEMP}/libXxf86vm-${LIBXXF86VM_VERSION}
	bzcat ${LIBXXF86VM_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBXXF86VM_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXXF86VM_TEMP}
	mv ${EXTTEMP}/libXxf86vm-${LIBXXF86VM_VERSION} ${EXTTEMP}/${NTI_LIBXXF86VM_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_LIBXXF86VM_CONFIGURED}: ${NTI_LIBXXF86VM_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXXF86VM_TEMP} || exit 1 ;\
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

${NTI_LIBXXF86VM_BUILT}: ${NTI_LIBXXF86VM_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXXF86VM_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

.PHONY: cti-libXxf86vm
cti-libXxf86vm: cti-cross-gcc cti-cross-pkg-config cti-x11proto cti-libXxf86vm-installed

CTARGETS+= cti-libXxf86vm

##

${NTI_LIBXXF86VM_INSTALLED}: ${NTI_LIBXXF86VM_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXXF86VM_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXxf86vm
#nti-libXxf86vm: nti-pkg-config nti-x11proto nti-xtrans ${NTI_LIBXXF86VM_INSTALLED}
nti-libXxf86vm: nti-pkg-config \
	nti-libX11 nti-libXext \
	nti-x11proto nti-x11proto-xext nti-x11proto-xf86vidmode \
	${NTI_LIBXXF86VM_INSTALLED}

ALL_NTI_TARGETS+= nti-libXxf86vm

endif	# HAVE_LIBXXF86VM_CONFIG
