# xeyes v1.1.1			[ since v1.0.1	2009-09-04 ]
# last mod WmT, 2011-09-23	[ (c) and GPLv2 1999-2011 ]

ifneq (${HAVE_XEYES_CONFIG},y)
HAVE_XEYES_CONFIG:=y

DESCRLIST+= "'nti-xeyes' -- xeyes"

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
#	#include ${CFG_ROOT}/gui/libX11/v1.2.2.mak
#	include ${CFG_ROOT}/gui/libX11/v1.3.6.mak
#	include ${CFG_ROOT}/gui/libXaw/v1.0.9.mak
include ${CFG_ROOT}/gui/libXrender/v0.9.6.mak

XEYES_VER=1.1.1
XEYES_SRC=${SRCDIR}/x/xeyes-1.1.1.tar.bz2

URLS+= http://xorg.freedesktop.org/releases/individual/app/xeyes-1.1.1.tar.bz2


## ,-----
## |	Extract
## +-----

CUI_XEYES_TEMP=cui-xeyes-${XEYES_VER}
CUI_XEYES_INSTTEMP=${EXTTEMP}/insttemp

CUI_XEYES_EXTRACTED=${EXTTEMP}/${CUI_XEYES_TEMP}/configure

.PHONY: cui-xeyes-extracted

cui-xeyes-extracted: ${CUI_XEYES_EXTRACTED}
${CUI_XEYES_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${CUI_XEYES_TEMP} ] || rm -rf ${EXTTEMP}/${CUI_XEYES_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${XEYES_SRC}
	mv ${EXTTEMP}/xeyes-${XEYES_VER} ${EXTTEMP}/${CUI_XEYES_TEMP}

##

NTI_XEYES_TEMP=nti-xeyes-${XEYES_VER}

NTI_XEYES_EXTRACTED=${EXTTEMP}/${NTI_XEYES_TEMP}/configure

.PHONY: nti-xeyes-extracted

nti-xeyes-extracted: ${NTI_XEYES_EXTRACTED}
${NTI_XEYES_EXTRACTED}:
	[ ! -d ${EXTTEMP}/${NTI_XEYES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XEYES_TEMP}
	make -C ${TOPLEV} extract ARCHIVES=${XEYES_SRC}
	mv ${EXTTEMP}/xeyes-X11R7.0-${XEYES_VER} ${EXTTEMP}/${NTI_XEYES_TEMP}


## ,-----
## |	Configure
## +-----

CUI_XEYES_CONFIGURED=${EXTTEMP}/${CUI_XEYES_TEMP}/config.status

.PHONY: cui-xeyes-configured

cui-xeyes-configured: cui-xeyes-extracted ${CUI_XEYES_CONFIGURED}

${CUI_XEYES_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${CUI_XEYES_TEMP} || exit 1 ;\
	  CC=${CTI_GCC} \
	  CFLAGS='-O2' \
	  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
		./configure \
			--prefix=/usr/ \
			--bindir=/usr/X11R7/bin \
			--build=${NTI_SPEC} \
			--host=${CTI_SPEC} \
			|| exit 1 \
	)

##

NTI_XEYES_CONFIGURED=${EXTTEMP}/${NTI_XEYES_TEMP}/config.status

.PHONY: nti-xeyes-configured

nti-xeyes-configured: nti-xeyes-extracted ${NTI_XEYES_CONFIGURED}

${NTI_XEYES_CONFIGURED}:
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XEYES_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr/ \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

CUI_XEYES_BUILT=${EXTTEMP}/${CUI_XEYES_TEMP}/xeyes

.PHONY: cui-xeyes-built
cui-xeyes-built: cui-xeyes-configured ${CUI_XEYES_BUILT}

${CUI_XEYES_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${CUI_XEYES_TEMP} || exit 1 ;\
		make \
	)

##

NTI_XEYES_BUILT=${EXTTEMP}/${NTI_XEYES_TEMP}/xeyes

.PHONY: nti-xeyes-built
nti-xeyes-built: nti-xeyes-configured ${NTI_XEYES_BUILT}

${NTI_XEYES_BUILT}:
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XEYES_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

CUI_XEYES_INSTALLED=${CUI_XEYES_INSTTEMP}/usr/X11R7/bin/xeyes

.PHONY: cui-xeyes-installed

cui-xeyes-installed: cui-xeyes-built ${CUI_XEYES_INSTALLED}

${CUI_XEYES_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${CUI_XEYES_TEMP} || exit 1 ;\
		make install DESTDIR=${CUI_XEYES_INSTTEMP} \
	)

.PHONY: cui-xeyes
cui-xeyes: cti-cross-gcc cti-cross-pkg-config cti-libXrender cui-xeyes-installed
#cui-xclock: cti-cross-gcc cti-cross-pkg-config cti-libX11 cti-libXaw cti-libXrender cui-xclock-installed

CTARGETS+= cui-xeyes

##

NTI_XEYES_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xeyes

.PHONY: nti-xeyes-installed

nti-xeyes-installed: nti-xeyes-built ${NTI_XEYES_INSTALLED}

${NTI_XEYES_INSTALLED}:
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XEYES_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xeyes
nti-xeyes: nti-pkg-config nti-xeyes-installed

NTARGETS+= nti-xeyes

endif	# HAVE_XEYES_CONFIG
