# zaz v0.8.0			[ since v0.8.0, c.2010-07-30 ]
# last mod WmT, 2017-08-21	[ (c) and GPLv2 1999-2017* ]

#ifneq (${HAVE_ZAZ_CONFIG},y)
#HAVE_ZAZ_CONFIG:=y
#
#DESCRLIST+= "'nti-zaz' -- host-toolchain zaz"
#
#include ${CFG_ROOT}/ENV/native.mak
#include ${CFG_ROOT}/distrotools-ng/native-gcc/v4.1.2.mak
#
#include ${CFG_ROOT}/av/libtheora/v1.1.1.mak
#include ${CFG_ROOT}/av/libogg/v1.2.0.mak
#include ${CFG_ROOT}/av/libvorbis/v1.3.1.mak
#include ${CFG_ROOT}/gui/SDL/v1.2.14.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#
#ZAZ_VER=0.8.0
#ZAZ_SRC=${SRCDIR}/z/zaz-0.8.0.tar.bz2
#
#URLS+=http://freefr.dl.sourceforge.net/project/zaz/zaz-0.8.0.tar.bz2
#
#NTI_ZAZ_TEMP=nti-zaz-${ZAZ_VER}
#NTI_ZAZ_INSTTEMP=nti-zaz-${ZAZ_VER}-insttemp
#
#
### ,-----
### |	package extract
### +-----
#
#NTI_ZAZ_EXTRACTED=${EXTTEMP}/${NTI_ZAZ_TEMP}/Makefile
#
#.PHONY: nti-zaz-extracted
#nti-zaz-extracted: ${NTI_ZAZ_EXTRACTED}
#
#${NTI_ZAZ_EXTRACTED}:
#	echo "*** $@ (EXTRACTED) ***"
#	[ ! -d ${EXTTEMP}/${NTI_ZAZ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZAZ_TEMP}
#	make -C ${TOPLEV} extract ARCHIVES=${ZAZ_SRC}
#	mv ${EXTTEMP}/zaz-${ZAZ_VER} ${EXTTEMP}/${NTI_ZAZ_TEMP}
#
#
### ,-----
### |	package configure
### +-----
#
#NTI_ZAZ_CONFIGURED=${EXTTEMP}/${NTI_ZAZ_TEMP}/config.status
#
#.PHONY: nti-zaz-configured
#nti-zaz-configured: nti-zaz-extracted ${NTI_ZAZ_CONFIGURED}
#
#${NTI_ZAZ_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${NTI_ZAZ_TEMP} || exit 1 ;\
#	  CC=${NTI_GCC} \
#		  CFLAGS='-O2' \
#	  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/pkg-config \
#			./configure \
#				--prefix=${HTC_ROOT}/usr \
#				|| exit 1 \
#	)
#
#
### ,-----
### |	package build
### +-----
#
#NTI_ZAZ_BUILT=${EXTTEMP}/${NTI_ZAZ_TEMP}/src/addtraction.lo
#
#.PHONY: nti-zaz-built
#nti-zaz-built: nti-zaz-configured ${NTI_ZAZ_BUILT}
#
#${NTI_ZAZ_BUILT}:
#	echo "*** $@ (BUILT) ***"
#	( cd ${EXTTEMP}/${NTI_ZAZ_TEMP} || exit 1 ;\
#		make || exit 1 \
#	)
#
#
### ,-----
### |	package install
### +-----
#
#NTI_ZAZ_INSTALLED=${HTC_ROOT}/usr/bin/dfbscreen
#
#.PHONY: nti-zaz-installed
#nti-zaz-installed: nti-zaz-built ${NTI_ZAZ_INSTALLED}
#
#${NTI_ZAZ_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${NTI_ZAZ_TEMP} || exit 1 ;\
#		make install || exit 1 \
#	)
#
#
#.PHONY: nti-zaz
#nti-zaz: nti-pkg-config nti-native-gcc nti-SDL nti-libtheora nti-libogg nti-libvorbis nti-zaz-installed
#
#TARGETS+= nti-zaz
#
#endif	# HAVE_ZAZ_CONFIG

ifneq (${HAVE_ZAZ_CONFIG},y)
HAVE_ZAZ_CONFIG:=y

#DESCRLIST+= "'nti-zaz' -- zaz"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak


ifeq (${ZAZ_VERSION},)
ZAZ_VERSION=0.8.0
endif

ZAZ_SRC=${SOURCES}/z/zaz-0.8.0.tar.bz2
URLS+=http://freefr.dl.sourceforge.net/project/zaz/zaz-0.8.0.tar.bz2

include ${CFG_ROOT}/gui/SDL/v1.2.15.mak
include ${CFG_ROOT}/audvid/libtheora/v1.1.1.mak
include ${CFG_ROOT}/audvid/libvorbis/v1.3.5.mak
include ${CFG_ROOT}/audvid/ftgl/v2.1.2.mak

NTI_ZAZ_TEMP=nti-zaz-${ZAZ_VERSION}

NTI_ZAZ_EXTRACTED=${EXTTEMP}/${NTI_ZAZ_TEMP}/README
NTI_ZAZ_CONFIGURED=${EXTTEMP}/${NTI_ZAZ_TEMP}/Makefile.OLD
NTI_ZAZ_BUILT=${EXTTEMP}/${NTI_ZAZ_TEMP}/src/zaz
NTI_ZAZ_INSTALLED=${NTI_TC_ROOT}/usr/bin/zaz


## ,-----
## |	Extract
## +-----

${NTI_ZAZ_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/zaz-${ZAZ_VERSION} ] || rm -rf ${EXTTEMP}/zaz-${ZAZ_VERSION}
	#[ ! -d ${EXTTEMP}/zaz ] || rm -rf ${EXTTEMP}/zaz
	#zcat ${ZAZ_SRC} | tar xvf - -C ${EXTTEMP}
	bzcat ${ZAZ_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_ZAZ_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_ZAZ_TEMP}
	mv ${EXTTEMP}/zaz-${ZAZ_VERSION} ${EXTTEMP}/${NTI_ZAZ_TEMP}
	#mv ${EXTTEMP}/zaz ${EXTTEMP}/${NTI_ZAZ_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_ZAZ_CONFIGURED}: ${NTI_ZAZ_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZAZ_TEMP} || exit 1 ;\
		CFLAGS='-O2' \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
			 ./configure \
				--prefix=${NTI_TC_ROOT}/usr \
				|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_ZAZ_BUILT}: ${NTI_ZAZ_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZAZ_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_ZAZ_INSTALLED}: ${NTI_ZAZ_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_ZAZ_TEMP} || exit 1 ;\
		echo '...' "(target missing)" '...' ; exit 1 ;\
		make install \
	)

##

.PHONY: nti-zaz
nti-zaz: nti-pkg-config \
	nti-libtheora nti-libvorbis \
	nti-ftgl nti-SDL \
	${NTI_ZAZ_INSTALLED}

ALL_NTI_TARGETS+= nti-zaz

endif	# HAVE_ZAZ_CONFIG
