# ncurses v5.9			[ since v5.2, c.2003-05-30 ]
# last mod WmT, 2014-06-20	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_NCURSES_CONFIG},y)
HAVE_NCURSES_CONFIG:=y

#DESCRLIST+= "'cti-ncurses' -- ncurses"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${NCURSES_VERSION},)
#NCURSES_VERSION:=5.6
#NCURSES_VERSION:=5.7
NCURSES_VERSION:=5.9
endif

NCURSES_SRC=${SOURCES}/n/ncurses-${NCURSES_VERSION}.tar.gz
#NCURSES_SRC=${SOURCES}/n/ncurses_${NCURSES_VERSION}.orig.tar.gz
URLS+= http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/ncurses/ncurses-${NCURSES_VERSION}.tar.gz
#URLS+=http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/main/n/ncurses/ncurses_5.9.orig.tar.gz

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak


NTI_NCURSES_TEMP=nti-ncurses-${NCURSES_VERSION}

NTI_NCURSES_EXTRACTED=${EXTTEMP}/${NTI_NCURSES_TEMP}/configure
NTI_NCURSES_CONFIGURED=${EXTTEMP}/${NTI_NCURSES_TEMP}/config.status
NTI_NCURSES_BUILT=${EXTTEMP}/${NTI_NCURSES_TEMP}/include/curses.h
#NTI_NCURSES_INSTALLED=${NTI_TC_ROOT}/usr/lib/libncurses.a
NTI_NCURSES_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/ncurses.pc
#CTI_NCURSES_INSTALLED= ${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr...

# Helpers for external use
NCURSES_CONFIG_TOOL= ${NTI_TC_ROOT}/usr/bin/ncurses5-config


## ,-----
## |	Extract
## +-----

${NTI_NCURSES_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/ncurses-${NCURSES_VERSION} ] || rm -rf ${EXTTEMP}/ncurses-${NCURSES_VERSION}
	zcat ${NCURSES_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_NCURSES_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_NCURSES_TEMP}
	mv ${EXTTEMP}/ncurses-${NCURSES_VERSION} ${EXTTEMP}/${NTI_NCURSES_TEMP}


## ,-----
## |	Configure
## +-----

${NTI_NCURSES_CONFIGURED}: ${NTI_NCURSES_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NCURSES_TEMP} || exit 1 ;\
	  CFLAGS='-O2' \
		  LIBTOOL=${HOSTSPEC}-libtool \
		  PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		  PKG_CONFIG_LIBDIR=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--without-cxx \
			--with-pkg-config=yes \
			--enable-pc-files \
			|| exit 1 \
	)


#.PHONY: cti-ncurses-configured
#
#cti-ncurses-configured: cti-ncurses-extracted ${CTI_NCURSES_CONFIGURED}
#
#${CTI_NCURSES_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CTI_NCURSES_TEMP} || exit 1 ;\
#		CC=${CTI_GCC} \
#		  AR=`echo ${CTI_GCC} | sed 's/gcc$$/ar/'` \
#		BUILD_CC=${NTI_GCC} \
#		  ac_cv_func_setvbuf_reversed=no \
#		  cf_cv_type_of_bool=unsigned \
#		  CFLAGS=-O2 \
#			./configure \
#			  --prefix=/usr \
#			  --build=${NTI_SPEC} \
#			  --host=${CTI_SPEC} \
#			  --with-shared \
#			  --without-ada --without-debug --without-cxx-binding \
#			  --disable-largefile --disable-nls \
#	)
#
###
#
#CUI_NCURSES_CONFIGURED=${EXTTEMP}/${CUI_NCURSES_TEMP}/config.status
#
#.PHONY: cui-ncurses-configured
#
#cui-ncurses-configured: cui-ncurses-extracted ${CUI_NCURSES_CONFIGURED}
#
#${CUI_NCURSES_CONFIGURED}:
#	echo "*** $@ (CONFIGURED) ***"
#	( cd ${EXTTEMP}/${CUI_NCURSES_TEMP} || exit 1 ;\
#		CC=${CTI_GCC} \
#		  AR=`echo ${CTI_GCC} | sed 's/gcc$$/ar/'` \
#		BUILD_CC=${NTI_GCC} \
#		  ac_cv_func_setvbuf_reversed=no \
#		  cf_cv_type_of_bool=unsigned \
#		  CFLAGS=-O2 \
#			./configure \
#			  --prefix=/usr \
#			  --build=${NTI_SPEC} \
#			  --host=${CTI_SPEC} \
#			  --with-shared \
#			  --without-ada --without-debug --without-cxx-binding \
#			  --disable-largefile --disable-nls \
#	)


## ,-----
## |	Build
## +-----

${NTI_NCURSES_BUILT}: ${NTI_NCURSES_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NCURSES_TEMP} || exit 1 ;\
		make LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)


## ,-----
## |	Install
## +-----

${NTI_NCURSES_INSTALLED}: ${NTI_NCURSES_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_NCURSES_TEMP} || exit 1 ;\
		make install.data install.libs \
			LIBTOOL=${HOSTSPEC}-libtool || exit 1 \
	)


#.PHONY: cti-ncurses-installed
#
#cti-ncurses-installed: cti-ncurses-built ${CTI_NCURSES_INSTALLED}
#
#${CTI_NCURSES_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CTI_NCURSES_TEMP} || exit 1 ;\
#		make prefix=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr install.data || exit 1 ;\
#		make prefix=${CTI_TC_ROOT}/usr/${CTI_SPEC}/usr install.libs || exit 1 \
#	)
#
###
#
#CUI_NCURSES_INSTALLED= ${CUI_NCURSES_INSTTEMP}/usr/lib/libncurses.a
#
#.PHONY: cui-ncurses-installed
#
#cui-ncurses-installed: cui-ncurses-built ${CUI_NCURSES_INSTALLED}
#
#${CUI_NCURSES_INSTALLED}:
#	echo "*** $@ (INSTALLED) ***"
#	( cd ${EXTTEMP}/${CTI_NCURSES_TEMP} || exit 1 ;\
#		make DESTDIR=${CUI_NCURSES_INSTTEMP} install.data || exit 1 ;\
#		make DESTDIR=${CUI_NCURSES_INSTTEMP} install.libs || exit 1 \
#	)

##

.PHONY: nti-ncurses
nti-ncurses: nti-libtool nti-pkg-config \
	${NTI_NCURSES_INSTALLED}

ALL_NTI_TARGETS+= nti-ncurses

endif	# HAVE_NCURSES_CONFIG
