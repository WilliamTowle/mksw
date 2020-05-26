# freetype v2.8.1		[ since v2.3.9, c.2009-09-08 ]
# last mod WmT, 2017-11-01	[ (c) and GPLv2 1999-2017* ]

ifneq (${HAVE_FREETYPE2_CONFIG},y)
HAVE_FREETYPE2_CONFIG:=y

#DESCRLIST+= "'nti-freetype2' -- freetype2"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${FREETYPE2_VERSION},)
#FREETYPE2_VERSION=2.4.11
#FREETYPE2_VERSION=2.7.1
FREETYPE2_VERSION=2.8.1
endif

FREETYPE2_SRC=${SOURCES}/f/freetype-${FREETYPE2_VERSION}.tar.bz2
#URLS+= http://downloads.sourceforge.net/project/freetype/freetype2/2.4.11/freetype-2.4.11.tar.bz2?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ffreetype%2Ffiles%2Ffreetype2%2F2.4.11%2F&ts=1483714003&use_mirror=kent
URLS+= http://downloads.sourceforge.net/project/freetype/freetype2/${FREETYPE2_VERSION}/freetype-${FREETYPE2_VERSION}.tar.bz2?use_mirror=ignum

#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
##include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

NTI_FREETYPE2_TEMP=nti-freetype2-${FREETYPE2_VERSION}

NTI_FREETYPE2_EXTRACTED=${EXTTEMP}/${NTI_FREETYPE2_TEMP}/README
NTI_FREETYPE2_CONFIGURED=${EXTTEMP}/${NTI_FREETYPE2_TEMP}/config.mk
NTI_FREETYPE2_BUILT=${EXTTEMP}/${NTI_FREETYPE2_TEMP}/builds/unix/freetype2.pc
NTI_FREETYPE2_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/freetype2.pc

# Helpers for external use (post-installation)
FREETYPE2_CONFIG_TOOL= ${NTI_TC_ROOT}/usr/bin/freetype-config


## ,-----
## |	Extract
## +-----

#CTI_FREETYPE2_TEMP=cti-freetype2-${FREETYPE2_VERSION}
#
#CTI_FREETYPE2_EXTRACTED=${EXTTEMP}/${CTI_FREETYPE2_TEMP}/configure
#
#.PHONY: cti-freetype2-extracted
#
#cti-freetype2-extracted: ${CTI_FREETYPE2_EXTRACTED}
#${CTI_FREETYPE2_EXTRACTED}:
#	[ ! -d ${EXTTEMP}/${CTI_FREETYPE2_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_FREETYPE2_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${FREETYPE2_SRC}
#	mv ${EXTTEMP}/freetype-${FREETYPE2_VERSION} ${EXTTEMP}/${CTI_FREETYPE2_TEMP}

##

${NTI_FREETYPE2_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/freetype2-${FREETYPE2_VERSION} ] || rm -rf ${EXTTEMP}/freetype2-${FREETYPE2_VERSION}
	bzcat ${FREETYPE2_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_FREETYPE2_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_FREETYPE2_TEMP}
	mv ${EXTTEMP}/freetype-${FREETYPE2_VERSION} ${EXTTEMP}/${NTI_FREETYPE2_TEMP}



## ,-----
## |	Configure
## +-----

#CTI_FREETYPE2_CONFIGURED=${EXTTEMP}/${CTI_FREETYPE2_TEMP}/config.status
#
#.PHONY: cti-freetype2-configured
#
#cti-freetype2-configured: cti-freetype2-extracted ${CTI_FREETYPE2_CONFIGURED}
#
#${CTI_FREETYPE2_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CTI_FREETYPE2_TEMP} || exit 1 ;\
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

${NTI_FREETYPE2_CONFIGURED}: ${NTI_FREETYPE2_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_FREETYPE2_TEMP} || exit 1 ;\
		[ -r builds/unix/install.mk.OLD ] || mv builds/unix/install.mk builds/unix/install.mk.OLD || exit 1 ;\
		cat builds/unix/install.mk.OLD \
			| sed '/^[ 	]/	s%$$(libdir)/pkgconfig%'${NTI_TC_ROOT}'/usr/'${HOSTSPEC}/'lib/pkgconfig%' \
			> builds/unix/install.mk ;\
	  CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		./configure \
			--prefix=${NTI_TC_ROOT}'/usr/' \
		PKG_CONFIG_LIBDIR=${NTI_TC_ROOT}'/usr/'${HOSTSPEC}/'lib/pkgconfig' \
			|| exit 1 \
	)
#	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
#		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \


## ,-----
## |	Build
## +-----

#CTI_FREETYPE2_BUILT=${EXTTEMP}/${CTI_FREETYPE2_TEMP}/freetype2.pc
#
#.PHONY: cti-freetype2-built
#cti-freetype2-built: cti-freetype2-configured ${CTI_FREETYPE2_BUILT}
#
#${CTI_FREETYPE2_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${CTI_FREETYPE2_TEMP} || exit 1 ;\
#		make \
#	)

##

${NTI_FREETYPE2_BUILT}: ${NTI_FREETYPE2_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_FREETYPE2_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

#CTI_FREETYPE2_INSTALLED=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr/lib/pkgconfig/freetype2.pc
#
#.PHONY: cti-freetype2-installed
#
#cti-freetype2-installed: cti-freetype2-built ${CTI_FREETYPE2_INSTALLED}
#
#${CTI_FREETYPE2_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CTI_FREETYPE2_TEMP} || exit 1 ;\
#		make install \
#	)
#
#.PHONY: cti-freetype2
#cti-freetype2: cti-cross-gcc cti-cross-pkg-config cti-libSM cti-libX11 cti-x11proto cti-x11proto-kb cti-freetype2-installed
#
#CTARGETS+= cti-freetype2

##

${NTI_FREETYPE2_INSTALLED}: ${NTI_FREETYPE2_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_FREETYPE2_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-freetype2
nti-freetype2: ${NTI_FREETYPE2_INSTALLED}

ALL_NTI_TARGETS+= nti-freetype2

endif	# HAVE_FREETYPE2_CONFIG
