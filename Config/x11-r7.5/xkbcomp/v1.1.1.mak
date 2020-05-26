# xkbcomp v1.1.1		[ since v1.1.1, c.2013-04-13 ]
# last mod WmT, 2016-12-25	[ (c) and GPLv2 1999-2016 ]

ifneq (${HAVE_XKBCOMP_CONFIG},y)
HAVE_XKBCOMP_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xkbcomp' -- xkbcomp"

ifeq (${XKBCOMP_VERSION},)
XKBCOMP_VERSION=1.1.1
endif

XKBCOMP_SRC=${SOURCES}/x/xkbcomp-${XKBCOMP_VERSION}.tar.bz2

URLS+= http://www.x.org/releases/X11R7.5/src/everything/xkbcomp-1.1.1.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.5/libX11/v1.3.2.mak
include ${CFG_ROOT}/x11-r7.5/libxkbfile/v1.0.6.mak

NTI_XKBCOMP_TEMP=nti-xkbcomp-${XKBCOMP_VERSION}

NTI_XKBCOMP_EXTRACTED=${EXTTEMP}/${NTI_XKBCOMP_TEMP}/configure
NTI_XKBCOMP_CONFIGURED=${EXTTEMP}/${NTI_XKBCOMP_TEMP}/config.status
NTI_XKBCOMP_BUILT=${EXTTEMP}/${NTI_XKBCOMP_TEMP}/xkbcomp
NTI_XKBCOMP_INSTALLED=${NTI_TC_ROOT}/usr/X11R7/bin/xkbcomp


## ,-----
## |	Extract
## +-----

#CTI_XKBCOMP_TEMP=cti-xkbcomp-${XKBCOMP_VERSION}
#
#CTI_XKBCOMP_EXTRACTED=${EXTTEMP}/${CTI_XKBCOMP_TEMP}/configure
#
#.PHONY: cti-xkbcomp-extracted
#
#cti-xkbcomp-extracted: ${CTI_XKBCOMP_EXTRACTED}
#${CTI_XKBCOMP_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${CTI_XKBCOMP_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_XKBCOMP_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${XKBCOMP_SRC}
#	mv ${EXTTEMP}/xkbcomp-${XKBCOMP_VERSION} ${EXTTEMP}/${CTI_XKBCOMP_TEMP}

##

${NTI_XKBCOMP_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xkbcomp-${XKBCOMP_VERSION} ] || rm -rf ${EXTTEMP}/xkbcomp-${XKBCOMP_VERSION}
	bzcat ${XKBCOMP_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XKBCOMP_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XKBCOMP_TEMP}
	mv ${EXTTEMP}/xkbcomp-${XKBCOMP_VERSION} ${EXTTEMP}/${NTI_XKBCOMP_TEMP}


## ,-----
## |	Configure
## +-----

#CTI_XKBCOMP_CONFIGURED=${EXTTEMP}/${CTI_XKBCOMP_TEMP}/config.status
#
#.PHONY: cti-xkbcomp-configured
#
#cti-xkbcomp-configured: cti-xkbcomp-extracted ${CTI_XKBCOMP_CONFIGURED}
#
#${CTI_XKBCOMP_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CTI_XKBCOMP_TEMP} || exit 1 ;\
#	  CC=${CTI_GCC} \
#	  CFLAGS='-O2' \
#	  PKG_CONFIG=${CTI_TC_ROOT}/usr/bin/${CTI_SPEC}-pkg-config \
#		./configure \
#			--prefix=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr \
#			--build=${NTI_SPEC} \
#			--host=${CTI_SPEC} \
#			|| exit 1 \
#	)

##

${NTI_XKBCOMP_CONFIGURED}: ${NTI_XKBCOMP_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XKBCOMP_TEMP} || exit 1 ;\
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

#CTI_XKBCOMP_BUILT=${EXTTEMP}/${CTI_XKBCOMP_TEMP}/xkbcomp.pc
#
#.PHONY: cti-xkbcomp-built
#cti-xkbcomp-built: cti-xkbcomp-configured ${CTI_XKBCOMP_BUILT}
#
#${CTI_XKBCOMP_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CTI_XKBCOMP_TEMP} || exit 1 ;\
#		make \
#	)

##

${NTI_XKBCOMP_BUILT}: ${NTI_XKBCOMP_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XKBCOMP_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

#CTI_XKBCOMP_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/xkbcomp.pc
#
#.PHONY: cti-xkbcomp-installed
#
#cti-xkbcomp-installed: cti-xkbcomp-built ${CTI_XKBCOMP_INSTALLED}
#
#${CTI_XKBCOMP_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CTI_XKBCOMP_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: cti-xkbcomp
#cti-xkbcomp: cti-cross-pkg-config cti-xkbcomp-installed
#
#CTARGETS+= cti-xkbcomp

##

${NTI_XKBCOMP_INSTALLED}: ${NTI_XKBCOMP_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XKBCOMP_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-xkbcomp
nti-xkbcomp: nti-pkg-config nti-libX11 nti-libxkbfile ${NTI_XKBCOMP_INSTALLED}

ALL_NTI_TARGETS+= nti-xkbcomp

endif	# HAVE_XKBCOMP_CONFIG
