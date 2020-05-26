# wayland v1.8.1		[ since v1.8.1, c.2015-09-23 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_WAYLAND_CONFIG},y)
HAVE_WAYLAND_CONFIG:=y

#DESCRLIST+= "'nti-wayland' -- wayland"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
###include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${WAYLAND_VERSION},)
WAYLAND_VERSION=1.8.1
endif

WAYLAND_SRC=${SOURCES}/w/wayland-${WAYLAND_VERSION}.tar.xz
WAYLAND_PATCHES=
#WAYLAND_PATCHES=${CFG_ROOT}/gui/wayland/wayland-scanner-path.patch
URLS+= http://wayland.freedesktop.org/releases/wayland-1.8.1.tar.xz

# deps: LFS says 'libxslt' is for building manuals
include ${CFG_ROOT}/misc/libffi/v3.2.1.mak
include ${CFG_ROOT}/misc/expat/v2.1.0.mak
include ${CFG_ROOT}/gui/wayland-scanner/v1.8.1.mak

NTI_WAYLAND_TEMP=nti-wayland-${WAYLAND_VERSION}

NTI_WAYLAND_EXTRACTED=${EXTTEMP}/${NTI_WAYLAND_TEMP}/configure
NTI_WAYLAND_CONFIGURED=${EXTTEMP}/${NTI_WAYLAND_TEMP}/config.status
NTI_WAYLAND_BUILT=${EXTTEMP}/${NTI_WAYLAND_TEMP}/src/wayland-server.pc
NTI_WAYLAND_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/wayland-server.pc


## ,-----
## |	Extract
## +-----

${NTI_WAYLAND_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/wayland-${WAYLAND_VERSION} ] || rm -rf ${EXTTEMP}/wayland-${WAYLAND_VERSION}
	#bzcat ${WAYLAND_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${WAYLAND_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${WAYLAND_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${WAYLAND_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d wayland-${WAYLAND_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_WAYLAND_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WAYLAND_TEMP}
	mv ${EXTTEMP}/wayland-${WAYLAND_VERSION} ${EXTTEMP}/${NTI_WAYLAND_TEMP}


## ,-----
## |	Configure
## +-----

## from buildroot: wayland-scanner for building, irrelevant to target
## from freedesktop.org lists: CC_FOR_BUILD compiles the scanner

${NTI_WAYLAND_CONFIGURED}: ${NTI_WAYLAND_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_WAYLAND_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
		  CC_FOR_BUILD=${NTI_GCC} \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-static \
			--disable-documentation \
			--disable-scanner \
			|| exit 1 \
	)
#			--build=${HOSTSPEC} \
#			--host=${TARGSPEC} \


## ,-----
## |	Build
## +-----


${NTI_WAYLAND_BUILT}: ${NTI_WAYLAND_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_WAYLAND_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_WAYLAND_INSTALLED}: ${NTI_WAYLAND_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_WAYLAND_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-wayland
nti-wayland: \
	nti-wayland-scanner \
	nti-pkg-config nti-libffi nti-expat ${NTI_WAYLAND_INSTALLED}

ALL_NTI_TARGETS+= nti-wayland

endif	# HAVE_WAYLAND_CONFIG
