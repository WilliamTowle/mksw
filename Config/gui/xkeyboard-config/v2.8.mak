# xkeyboard-config v2.8		[ since v2.7, c.2013-04-14 ]
# last mod WmT, 2013-04-14	[ (c) and GPLv2 1999-2013 ]

ifneq (${HAVE_XKEYBOARD_CONFIG},y)
HAVE_XKEYBOARD_CONFIG_CONFIG:=y

include ${CFG_ROOT}/ENV/buildtype.mak

#DESCRLIST+= "'nti-xkeyboard-config' -- xkeyboard-config"

ifeq (${XKEYBOARD_CONFIG_VERSION},)
XKEYBOARD_CONFIG_VERSION=2.8
endif

XKEYBOARD_CONFIG_SRC=${SOURCES}/x/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}.tar.bz2

URLS+= http://www.x.org/releases/individual/data/xkeyboard-config/xkeyboard-config-2.8.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/gui/x11proto/v7.0.23.mak

NTI_XKEYBOARD_CONFIG_TEMP=nti-xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}

NTI_XKEYBOARD_CONFIG_EXTRACTED=${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}/configure
NTI_XKEYBOARD_CONFIG_CONFIGURED=${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}/config.status
NTI_XKEYBOARD_CONFIG_BUILT=${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}/xkeyboard-config.pc
NTI_XKEYBOARD_CONFIG_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/xkeyboard-config.pc


## ,-----
## |	Extract
## +-----

#CTI_XKEYBOARD_CONFIG_TEMP=cti-xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}
#
#CTI_XKEYBOARD_CONFIG_EXTRACTED=${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP}/configure
#
#.PHONY: cti-xkeyboard-config-extracted
#
#cti-xkeyboard-config-extracted: ${CTI_XKEYBOARD_CONFIG_EXTRACTED}
#${CTI_XKEYBOARD_CONFIG_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${XKEYBOARD_CONFIG_SRC}
#	mv ${EXTTEMP}/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION} ${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP}

##

${NTI_XKEYBOARD_CONFIG_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION} ] || rm -rf ${EXTTEMP}/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION}
	bzcat ${XKEYBOARD_CONFIG_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}
	mv ${EXTTEMP}/xkeyboard-config-${XKEYBOARD_CONFIG_VERSION} ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP}


## ,-----
## |	Configure
## +-----

#CTI_XKEYBOARD_CONFIG_CONFIGURED=${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP}/config.status
#
#.PHONY: cti-xkeyboard-config-configured
#
#cti-xkeyboard-config-configured: cti-xkeyboard-config-extracted ${CTI_XKEYBOARD_CONFIG_CONFIGURED}
#
#${CTI_XKEYBOARD_CONFIG_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
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

${NTI_XKEYBOARD_CONFIG_CONFIGURED}: ${NTI_XKEYBOARD_CONFIG_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
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

#CTI_XKEYBOARD_CONFIG_BUILT=${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP}/xkeyboard-config.pc
#
#.PHONY: cti-xkeyboard-config-built
#cti-xkeyboard-config-built: cti-xkeyboard-config-configured ${CTI_XKEYBOARD_CONFIG_BUILT}
#
#${CTI_XKEYBOARD_CONFIG_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
#		make \
#	)

##

${NTI_XKEYBOARD_CONFIG_BUILT}: ${NTI_XKEYBOARD_CONFIG_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

#CTI_XKEYBOARD_CONFIG_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/xkeyboard-config.pc
#
#.PHONY: cti-xkeyboard-config-installed
#
#cti-xkeyboard-config-installed: cti-xkeyboard-config-built ${CTI_XKEYBOARD_CONFIG_INSTALLED}
#
#${CTI_XKEYBOARD_CONFIG_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: cti-xkeyboard-config
#cti-xkeyboard-config: cti-cross-pkg-config cti-xkeyboard-config-installed
#
#CTARGETS+= cti-xkeyboard-config

##

${NTI_XKEYBOARD_CONFIG_INSTALLED}: ${NTI_XKEYBOARD_CONFIG_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_XKEYBOARD_CONFIG_TEMP} || exit 1 ;\
		make install ;\
		cp ${NTI_TC_ROOT}/usr/share/pkgconfig/xkeyboard-config.pc ${NTI_XKEYBOARD_CONFIG_INSTALLED} \
	)

.PHONY: nti-xkeyboard-config
nti-xkeyboard-config: nti-pkg-config nti-x11proto ${NTI_XKEYBOARD_CONFIG_INSTALLED}
#nti-xkeyboard-config: nti-pkg-config ${NTI_XKEYBOARD_CONFIG_INSTALLED}

ALL_NTI_TARGETS+= nti-xkeyboard-config

endif	# HAVE_XKEYBOARD_CONFIG_CONFIG
