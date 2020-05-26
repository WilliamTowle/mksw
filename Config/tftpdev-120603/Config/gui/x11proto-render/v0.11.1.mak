# x11proto-render v0.11.1	[ since v0.9.3, c.2008-06-01 ]
# last mod WmT, 2011-09-23	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_X11PROTO_RENDER_CONFIG},y)
HAVE_X11PROTO_RENDER_CONFIG:=y

DESCRLIST+= "'nti-x11proto-render' -- x11proto-render"
DESCRLIST+= "'cti-x11proto-render' -- x11proto-render"

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

#X11PROTO_RENDER_VER=0.9.3
X11PROTO_RENDER_VER=0.11.1
X11PROTO_RENDER_SRC=${SRCDIR}/x/x11proto-render_0.9.3.orig.tar.gz
X11PROTO_RENDER_SRC=${SRCDIR}/r/renderproto-0.11.1.tar.bz2

#URLS+= http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/x/x11proto-render/x11proto-render_0.9.3.orig.tar.gz
URLS+= http://xorg.freedesktop.org/releases/individual/proto/renderproto-0.11.1.tar.bz2


## ,-----
## |	Extract
## +-----

CTI_X11PROTO_RENDER_TEMP=cti-x11proto-render-${X11PROTO_RENDER_VER}

CTI_X11PROTO_RENDER_EXTRACTED=${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP}/configure

.PHONY: cti-x11proto-render-extracted

cti-x11proto-render-extracted: ${CTI_X11PROTO_RENDER_EXTRACTED}
${CTI_X11PROTO_RENDER_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${X11PROTO_RENDER_SRC}
	mv ${EXTTEMP}/renderproto-${X11PROTO_RENDER_VER} ${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP}

##

NTI_X11PROTO_RENDER_TEMP=nti-x11proto-render-${X11PROTO_RENDER_VER}

NTI_X11PROTO_RENDER_EXTRACTED=${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}/configure

.PHONY: nti-x11proto-render-extracted

nti-x11proto-render-extracted: ${NTI_X11PROTO_RENDER_EXTRACTED}
${NTI_X11PROTO_RENDER_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${X11PROTO_RENDER_SRC}
	mv ${EXTTEMP}/renderproto-${X11PROTO_RENDER_VER} ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}


## ,-----
## |	Configure
## +-----

CTI_X11PROTO_RENDER_CONFIGURED=${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP}/config.status

.PHONY: cti-x11proto-render-configured

cti-x11proto-render-configured: cti-x11proto-render-extracted ${CTI_X11PROTO_RENDER_CONFIGURED}

${CTI_X11PROTO_RENDER_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
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

NTI_X11PROTO_RENDER_CONFIGURED=${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}/config.status

.PHONY: nti-x11proto-render-configured

nti-x11proto-render-configured: nti-x11proto-render-extracted ${NTI_X11PROTO_RENDER_CONFIGURED}

${NTI_X11PROTO_RENDER_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
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

CTI_X11PROTO_RENDER_BUILT=${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP}/renderproto.pc

.PHONY: cti-x11proto-render-built
cti-x11proto-render-built: cti-x11proto-render-configured ${CTI_X11PROTO_RENDER_BUILT}

${CTI_X11PROTO_RENDER_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
		make \
	)

##

NTI_X11PROTO_RENDER_BUILT=${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP}/renderproto.pc

.PHONY: nti-x11proto-render-built
nti-x11proto-render-built: nti-x11proto-render-configured ${NTI_X11PROTO_RENDER_BUILT}

${NTI_X11PROTO_RENDER_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

CTI_X11PROTO_RENDER_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/renderproto.pc

.PHONY: cti-x11proto-render-installed

cti-x11proto-render-installed: cti-x11proto-render-built ${CTI_X11PROTO_RENDER_INSTALLED}

${CTI_X11PROTO_RENDER_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: cti-x11proto-render
cti-x11proto-render: cti-cross-gcc cti-cross-pkg-config cti-x11proto-render-installed

CTARGETS+= cti-x11proto-render

##

NTI_X11PROTO_RENDER_INSTALLED=${NTI_TC_ROOT}/usr/lib/pkgconfig/renderproto.pc

.PHONY: nti-x11proto-render-installed

nti-x11proto-render-installed: nti-x11proto-render-built ${NTI_X11PROTO_RENDER_INSTALLED}

${NTI_X11PROTO_RENDER_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_X11PROTO_RENDER_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-x11proto-render
nti-x11proto-render: nti-pkg-config nti-x11proto-render-installed

NTARGETS+= nti-x11proto-render

endif	# HAVE_X11PROTO_RENDER_CONFIG
