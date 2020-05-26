# libXrender v0.9.6		[ since v0.9.4 c.2009-09-09 ]
# last mod WmT, 2011-09-22	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LIBXRENDER_CONFIG},y)
HAVE_LIBXRENDER_CONFIG:=y

DESCRLIST+= "'nti-libXrender' -- libXrender"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
#include ${CFG_ROOT}/gui/libX11/v1.3.3.mak
include ${CFG_ROOT}/gui/libX11/v1.3.6.mak
#include ${CFG_ROOT}/gui/x11proto-render/v0.9.3.mak
include ${CFG_ROOT}/gui/x11proto-render/v0.11.1.mak

LIBXRENDER_VER=0.9.6
#LIBXRENDER_SRC=${SRCDIR}/l/libxrender_0.9.4.orig.tar.gz
LIBXRENDER_SRC=${SRCDIR}/l/libXrender-0.9.6.tar.bz2

#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/libx/libxrender/libxrender_0.9.4.orig.tar.gz
URLS+= http://xorg.freedesktop.org/releases/individual/lib/libXrender-0.9.6.tar.bz2


## ,-----
## |	Extract
## +-----

CTI_LIBXRENDER_TEMP=cti-libXrender-${LIBXRENDER_VER}

CTI_LIBXRENDER_EXTRACTED=${EXTTEMP}/${CTI_LIBXRENDER_TEMP}/configure

.PHONY: cti-libXrender-extracted

cti-libXrender-extracted: ${CTI_LIBXRENDER_EXTRACTED}
${CTI_LIBXRENDER_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_LIBXRENDER_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBXRENDER_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBXRENDER_SRC}
	mv ${EXTTEMP}/libXrender-${LIBXRENDER_VER} ${EXTTEMP}/${CTI_LIBXRENDER_TEMP}

##

NTI_LIBXRENDER_TEMP=nti-libXrender-${LIBXRENDER_VER}

NTI_LIBXRENDER_EXTRACTED=${EXTTEMP}/${NTI_LIBXRENDER_TEMP}/configure

.PHONY: nti-libXrender-extracted

nti-libXrender-extracted: ${NTI_LIBXRENDER_EXTRACTED}
${NTI_LIBXRENDER_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXRENDER_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBXRENDER_SRC}
	mv ${EXTTEMP}/libXrender-${LIBXRENDER_VER} ${EXTTEMP}/${NTI_LIBXRENDER_TEMP}


## ,-----
## |	Configure
## +-----

CTI_LIBXRENDER_CONFIGURED=${EXTTEMP}/${CTI_LIBXRENDER_TEMP}/config.status

.PHONY: cti-libXrender-configured

cti-libXrender-configured: cti-libXrender-extracted ${CTI_LIBXRENDER_CONFIGURED}

${CTI_LIBXRENDER_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LIBXRENDER_TEMP} || exit 1 ;\
	  CC=${CTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
		./configure \
			--prefix=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
			|| exit 1 \
	)

##

NTI_LIBXRENDER_CONFIGURED=${EXTTEMP}/${NTI_LIBXRENDER_TEMP}/config.status

.PHONY: nti-libXrender-configured

nti-libXrender-configured: nti-libXrender-extracted ${NTI_LIBXRENDER_CONFIGURED}

${NTI_LIBXRENDER_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

CTI_LIBXRENDER_BUILT=${EXTTEMP}/${CTI_LIBXRENDER_TEMP}/xrender.pc

.PHONY: cti-libXrender-built
cti-libXrender-built: cti-libXrender-configured ${CTI_LIBXRENDER_BUILT}

${CTI_LIBXRENDER_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LIBXRENDER_TEMP} || exit 1 ;\
		make \
	)

##

NTI_LIBXRENDER_BUILT=${EXTTEMP}/${NTI_LIBXRENDER_TEMP}/xrender.pc

.PHONY: nti-libXrender-built
nti-libXrender-built: nti-libXrender-configured ${NTI_LIBXRENDER_BUILT}

${NTI_LIBXRENDER_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

CTI_LIBXRENDER_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/xrender.pc

.PHONY: cti-libXrender-installed

cti-libXrender-installed: cti-libXrender-built ${CTI_LIBXRENDER_INSTALLED}

${CTI_LIBXRENDER_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LIBXRENDER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cti-libXrender
cti-libXrender: cti-cross-gcc cti-cross-pkg-config cti-libX11 cti-x11proto-render cti-libXrender-installed

CTARGETS+= cti-libXrender

##

NTI_LIBXRENDER_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/xrender.pc

.PHONY: nti-libXrender-installed

nti-libXrender-installed: nti-libXrender-built ${NTI_LIBXRENDER_INSTALLED}

${NTI_LIBXRENDER_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXRENDER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXrender
nti-libXrender: nti-pkg-config nti-libX11 nti-x11proto-render nti-libXrender-installed

NTARGETS+= nti-libXrender

endif	# HAVE_LIBXRENDER_CONFIG
