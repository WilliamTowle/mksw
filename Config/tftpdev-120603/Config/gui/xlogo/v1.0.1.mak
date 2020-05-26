# xlogo v1.0.1			[ since v1.0.1	2009-09-09 ]
# last mod WmT, 2009-09-23	[ (c) and GPLv2 1999-2009 ]

ifneq (${HAVE_XLOGO_CONFIG},y)
HAVE_XLOGO_CONFIG:=y

DESCRLIST+= "'nti-xlogo' -- xlogo"

include ${CFG_ROOT}/ENV/ifbuild.env
include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/ENV/target.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.26.mak
include ${CFG_ROOT}/gui/libICE/v1.0.5.mak
include ${CFG_ROOT}/gui/libSM/v1.1.0.mak
include ${CFG_ROOT}/gui/libX11/v1.2.2.mak
include ${CFG_ROOT}/gui/libXaw/v1.0.6.mak
include ${CFG_ROOT}/gui/libXmu/v1.0.4.mak
include ${CFG_ROOT}/gui/libXrender/v0.9.4.mak

XLOGO_VER=1.0.1
XLOGO_SRC=${SRCDIR}/x/xlogo_1.0.1.orig.tar.gz

URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/x/xlogo/xlogo_1.0.1.orig.tar.gz


## ,-----
## |	Extract
## +-----

NTI_XLOGO_TEMP=nti-xlogo-${XLOGO_VER}

NTI_XLOGO_EXTRACTED=${EXTTEMP}/${NTI_XLOGO_TEMP}/configure

.PHONY: nti-xlogo-extracted
nti-xlogo-extracted: ${NTI_XLOGO_EXTRACTED}

${NTI_XLOGO_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_XLOGO_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XLOGO_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${XLOGO_SRC}
	mv ${EXTTEMP}/xlogo-X11R7.0-${XLOGO_VER} ${EXTTEMP}/${NTI_XLOGO_TEMP}


## ,-----
## |	Configure
## +-----

NTI_XLOGO_CONFIGURED=${EXTTEMP}/${NTI_XLOGO_TEMP}/config.status

.PHONY: nti-xlogo-configured
nti-xlogo-configured: nti-xlogo-extracted ${NTI_XLOGO_CONFIGURED}

${NTI_XLOGO_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XLOGO_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  LIBS='-L${NTI_TC_ROOT}/usr/lib -lXaw7 -lXmu -lXt -lX11 -lSM -lICE -lXext -lXrender' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 ;\
	)


## ,-----
## |	Build
## +-----

NTI_XLOGO_BUILT=${EXTTEMP}/${NTI_XLOGO_TEMP}/xlogo

.PHONY: nti-xlogo-built
nti-xlogo-built: nti-xlogo-configured ${NTI_XLOGO_BUILT}

${NTI_XLOGO_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XLOGO_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

NTI_XLOGO_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xlogo

.PHONY: nti-xlogo-installed
nti-xlogo-installed: nti-xlogo-built ${NTI_XLOGO_INSTALLED}

${NTI_XLOGO_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XLOGO_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xlogo
nti-xlogo: nti-pkg-config nti-libXaw nti-libXmu nti-libXt nti-libX11 nti-libSM nti-libICE nti-libXrender nti-xlogo-installed

NTARGETS+= nti-xlogo

endif	# HAVE_XLOGO_CONFIG
