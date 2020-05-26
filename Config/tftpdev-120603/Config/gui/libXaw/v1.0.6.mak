# libXaw v1.0.6			[ since v1.0.6 c.2009-09-08 ]
# last mod WmT, 2011-09-23	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_LIBXAW_CONFIG},y)
HAVE_LIBXAW_CONFIG:=y

DESCRLIST+= "'nti-libXaw' -- libXaw"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
include ${CFG_ROOT}/gui/libXext/v1.0.99.1.mak
#include ${CFG_ROOT}/gui/libXext/v1.3.0.mak

LIBXAW_VER=1.0.6
LIBXAW_SRC=${SRCDIR}/l/libxaw_1.0.6.orig.tar.gz

URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/libx/libxaw/libxaw_1.0.6.orig.tar.gz


## ,-----
## |	Extract
## +-----

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
