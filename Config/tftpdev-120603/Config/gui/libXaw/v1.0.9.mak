# libXaw v1.0.9			[ since v1.0.6 c.2009-09-08 ]
# last mod WmT, 2011-09-22	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LIBXAW_CONFIG},y)
HAVE_LIBXAW_CONFIG:=y

DESCRLIST+= "'nti-libXaw' -- libXaw"

include ${CFG_ROOT}/ENV/ifbuild.env
ifeq (${ACTION},buildn)
include ${CFG_ROOT}/ENV/native.mak
else
include ${CFG_ROOT}/ENV/target.mak
endif

ifneq (${HAVE_CROSS_GCC_VER},)
include ${CFG_ROOT}/distrotools-ng/cross-gcc/v${HAVE_CROSS_GCC_VER}.mak
include ${CFG_ROOT}/distrotools-ng/uClibc-rt/v${HAVE_TARGET_UCLIBC_VER}.mak
endif

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
#include ${CFG_ROOT}/gui/libXext/v1.0.99.1.mak
include ${CFG_ROOT}/gui/libXext/v1.3.0.mak
include ${CFG_ROOT}/gui/libXpm/v3.5.9.mak
include ${CFG_ROOT}/gui/libXt/v1.0.5.mak
#include ${CFG_ROOT}/gui/libXt/v1.1.1.mak

#LIBXAW_VER=1.0.5
LIBXAW_VER=1.0.9
#LIBXAW_SRC=${SRCDIR}/l/libxaw_1.0.6.orig.tar.gz
LIBXAW_SRC=${SRCDIR}/l/libXaw-1.0.9.tar.bz2

#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/libx/libxaw/libxaw_1.0.6.orig.tar.gz
URLS+= http://xorg.freedesktop.org/releases/individual/lib/libXaw-1.0.9.tar.bz2


## ,-----
## |	Extract
## +-----

CTI_LIBXAW_TEMP=cti-libXaw-${LIBXAW_VER}

CTI_LIBXAW_EXTRACTED=${EXTTEMP}/${CTI_LIBXAW_TEMP}/configure

.PHONY: cti-libXaw-extracted
cti-libXaw-extracted: ${CTI_LIBXAW_EXTRACTED}

${CTI_LIBXAW_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_LIBXAW_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_LIBXAW_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBXAW_SRC}
	mv ${EXTTEMP}/libXaw-${LIBXAW_VER} ${EXTTEMP}/${CTI_LIBXAW_TEMP}

##

NTI_LIBXAW_TEMP=nti-libXaw-${LIBXAW_VER}

NTI_LIBXAW_EXTRACTED=${EXTTEMP}/${NTI_LIBXAW_TEMP}/configure

.PHONY: nti-libXaw-extracted
nti-libXaw-extracted: ${NTI_LIBXAW_EXTRACTED}

${NTI_LIBXAW_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_LIBXAW_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBXAW_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${LIBXAW_SRC}
	mv ${EXTTEMP}/libXaw-${LIBXAW_VER} ${EXTTEMP}/${NTI_LIBXAW_TEMP}


## ,-----
## |	Configure
## +-----

CTI_LIBXAW_CONFIGURED=${EXTTEMP}/${CTI_LIBXAW_TEMP}/config.status

.PHONY: cti-libXaw-configured
cti-libXaw-configured: cti-libXaw-extracted ${CTI_LIBXAW_CONFIGURED}

${CTI_LIBXAW_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_LIBXAW_TEMP} || exit 1 ;\
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

NTI_LIBXAW_CONFIGURED=${EXTTEMP}/${NTI_LIBXAW_TEMP}/config.status

.PHONY: nti-libXaw-configured
nti-libXaw-configured: nti-libXaw-extracted ${NTI_LIBXAW_CONFIGURED}

${NTI_LIBXAW_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
	  CC=${NTI_GCC} \
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

CTI_LIBXAW_BUILT=${EXTTEMP}/${CTI_LIBXAW_TEMP}/xaw7.pc

.PHONY: cti-libXaw-built
cti-libXaw-built: cti-libXaw-configured ${CTI_LIBXAW_BUILT}

${CTI_LIBXAW_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_LIBXAW_TEMP} || exit 1 ;\
		make \
	)

##

NTI_LIBXAW_BUILT=${EXTTEMP}/${NTI_LIBXAW_TEMP}/xaw7.pc

.PHONY: nti-libXaw-built
nti-libXaw-built: nti-libXaw-configured ${NTI_LIBXAW_BUILT}

${NTI_LIBXAW_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

CTI_LIBXAW_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/xaw7.pc

.PHONY: cti-libXaw-installed
cti-libXaw-installed: cti-libXaw-built ${CTI_LIBXAW_INSTALLED}

${CTI_LIBXAW_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_LIBXAW_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cti-libXaw
cti-libXaw: cti-cross-gcc cti-cross-pkg-config cti-libXext cti-libXt cti-libXmu cti-libXpm cti-libXaw-installed

CTARGETS+= cti-libXaw

##

NTI_LIBXAW_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/xaw7.pc

.PHONY: nti-libXaw-installed
nti-libXaw-installed: nti-libXaw-built ${NTI_LIBXAW_INSTALLED}

${NTI_LIBXAW_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAW_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libXaw
nti-libXaw: nti-pkg-config nti-libXext nti-libXt nti-libXmu nti-libXpm nti-libXaw-installed

NTARGETS+= nti-libXaw

endif	# HAVE_LIBXAW_CONFIG
