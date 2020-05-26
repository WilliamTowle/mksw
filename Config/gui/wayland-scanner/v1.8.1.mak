# wayland-scanner v1.8.1	[ since v1.8.1, c.2015-09-23 ]
# last mod WmT, 2015-10-15	[ (c) and GPLv2 1999-2015* ]

ifneq (${HAVE_WAYLAND_SCANNER_CONFIG},y)
HAVE_WAYLAND_SCANNER_CONFIG:=y

#DESCRLIST+= "'nti-wayland-scanner' -- wayland-scanner"

include ${CFG_ROOT}/ENV/buildtype.mak

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
##include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
###include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

ifeq (${WAYLAND_SCANNER_VERSION},)
WAYLAND_SCANNER_VERSION=1.8.1
endif

WAYLAND_SCANNER_SRC=${SOURCES}/w/wayland-${WAYLAND_SCANNER_VERSION}.tar.xz
#WAYLAND_SCANNER_PATCHES=${CFG_ROOT}/gui/wayland/wayland-scanner-path.patch
URLS+= http://wayland.freedesktop.org/releases/wayland-1.8.1.tar.xz

# deps: LFS says 'libxslt' is for building manuals
include ${CFG_ROOT}/misc/libffi/v3.2.1.mak
include ${CFG_ROOT}/misc/expat/v2.1.0.mak

NTI_WAYLAND_SCANNER_TEMP=nti-wayland-scanner-${WAYLAND_SCANNER_VERSION}

NTI_WAYLAND_SCANNER_EXTRACTED=${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP}/configure
NTI_WAYLAND_SCANNER_CONFIGURED=${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP}/config.log
NTI_WAYLAND_SCANNER_BUILT=${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP}/wayland-scanner
NTI_WAYLAND_SCANNER_INSTALLED=${NTI_TC_ROOT}/usr/bin \
#NTI_WAYLAND_SCANNER_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/wayland-scanner.pc


## ,-----
## |	Extract
## +-----

${NTI_WAYLAND_SCANNER_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/wayland-scanner-${WAYLAND_SCANNER_VERSION} ] || rm -rf ${EXTTEMP}/wayland-scanner-${WAYLAND_SCANNER_VERSION}
	#bzcat ${WAYLAND_SCANNER_SRC} | tar xvf - -C ${EXTTEMP}
	xzcat ${WAYLAND_SCANNER_SRC} | tar xvf - -C ${EXTTEMP}
ifneq (${WAYLAND_SCANNER_PATCHES},)
	( cd ${EXTTEMP} || exit 1 ;\
		for PF in ${WAYLAND_SCANNER_PATCHES} ; do \
			echo "*** PATCHING -- $${PF} ***" ;\
			grep '+++' $${PF} ;\
			patch --batch -d wayland-${WAYLAND_SCANNER_VERSION} -Np1 < $${PF} ;\
		done \
	)
endif
	[ ! -d ${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP}
	mv ${EXTTEMP}/wayland-${WAYLAND_SCANNER_VERSION} ${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP}


## ,-----
## |	Configure
## +-----

## from buildroot: wayland-scanner for building, irrelevant to target

${NTI_WAYLAND_SCANNER_CONFIGURED}: ${NTI_WAYLAND_SCANNER_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=/usr/bin/gcc \
		  CFLAGS='-O2' \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--disable-static \
			--disable-documentation \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----


${NTI_WAYLAND_SCANNER_BUILT}: ${NTI_WAYLAND_SCANNER_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP} || exit 1 ;\
		make wayland-scanner \
	)


## ,-----
## |	Install
## +-----

${NTI_WAYLAND_SCANNER_INSTALLED}: ${NTI_WAYLAND_SCANNER_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_WAYLAND_SCANNER_TEMP} || exit 1 ;\
		cp wayland-scanner ${NTI_TC_ROOT}/usr/bin \
	)
#		make install

.PHONY: nti-wayland-scanner
nti-wayland-scanner: nti-pkg-config \
	nti-libffi nti-expat ${NTI_WAYLAND_SCANNER_INSTALLED}
ALL_NTI_TARGETS+= nti-wayland-scanner

endif	# HAVE_WAYLAND_SCANNER_CONFIG
