# libX11 v1.3.2			[ since v1.1.4	2008-06-21 ]
# last mod WmT, 2014-02-19	[ (c) and GPLv2 1999-2014 ]

ifneq (${HAVE_LIBX11_CONFIG},y)
HAVE_LIBX11_CONFIG:=y

DESCRLIST+= "'nti-libX11' -- libX11"

include ${CFG_ROOT}/ENV/buildtype.mak

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak

include ${CFG_ROOT}/x11-r7.5/libXdmcp/v1.0.3.mak
include ${CFG_ROOT}/x11-r7.5/libXau/v1.0.5.mak
#include ${CFG_ROOT}/gui/libXau/v1.0.6.mak
include ${CFG_ROOT}/x11-r7.5/libXt/v1.0.7.mak
#include ${CFG_ROOT}/gui/libXt/v1.0.9.mak
include ${CFG_ROOT}/x11-r7.5/x11proto/v7.0.16.mak
#include ${CFG_ROOT}/gui/x11proto/v7.0.20.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-bigreqs/v1.1.0.mak
#include ${CFG_ROOT}/gui/x11proto-bigreqs/v1.1.1.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-input/v2.0.mak
#include ${CFG_ROOT}/gui/x11proto-input/v2.0.1.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-kb/v1.0.4.mak
#include ${CFG_ROOT}/gui/x11proto-kb/v1.0.5.mak
include ${CFG_ROOT}/x11-r7.5/x11proto-xcmisc/v1.2.0.mak
#include ${CFG_ROOT}/gui/x11proto-xcmisc/v1.2.1.mak

ifeq (${LIBX11_VERSION},)
LIBX11_VERSION=1.3.2
endif

LIBX11_SRC=${SOURCES}/l/libX11-${LIBX11_VERSION}.tar.bz2

URLS+= http://www.x.org/releases/X11R7.5/src/lib/libX11-1.3.2.tar.bz2

NTI_LIBX11_TEMP=nti-libX11-${LIBX11_VERSION}

NTI_LIBX11_EXTRACTED=${EXTTEMP}/${NTI_LIBX11_TEMP}/configure
NTI_LIBX11_CONFIGURED=${EXTTEMP}/${NTI_LIBX11_TEMP}/config.status
NTI_LIBX11_BUILT=${EXTTEMP}/${NTI_LIBX11_TEMP}/x11.pc
NTI_LIBX11_INSTALLED=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig/x11.pc


## ,-----
## |	Extract
## +-----

${NTI_LIBX11_EXTRACTED}:
	echo "*** $@ (EXTRACTED) ***"
	[ ! -d ${EXTTEMP}/libX11-${LIBX11_VERSION} ] || rm -rf ${EXTTEMP}/libX11-${LIBX11_VERSION}
	bzcat ${LIBX11_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LIBX11_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBX11_TEMP}
	mv ${EXTTEMP}/libX11-${LIBX11_VERSION} ${EXTTEMP}/${NTI_LIBX11_TEMP}


## ,-----
## |	Configure
## +-----

## 2014-02-19: no specs: modern pdf/postscript generation tools barf :(

${NTI_LIBX11_CONFIGURED}: ${NTI_LIBX11_EXTRACTED}
	echo "*** $@ (CONFIGURED) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		case ${LIBX11_VERSION} in \
		1.2.*|1.3.*) \
			mv configure configure.OLD || exit 1 ;\
			cat configure.OLD \
				| sed 's/`pkg-config/`$$PKG_CONFIG/' \
				> configure ;\
			chmod a+x configure \
		;; \
		esac ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${HOSTSPEC}'/lib/pkgconfig%' \
			> Makefile.in ;\
		CC=${NTI_GCC} \
	  CFLAGS='-O2' \
		  PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		  PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--bindir=${NTI_TC_ROOT}/usr/X11R7/bin \
			--without-xcb \
			--disable-secure-rpc \
			--disable-xf86bigfont \
			|| exit 1 ;\
		mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^SUBDIRS/	s/specs//' \
			> Makefile || exit 1 \
	)
#			| sed '/^install-p/	s/ install.*recursive//' \
#			| sed '/\.PHONY/,/^$$/ { s/install-p[sd][^ ]*//g } ' \
#			| sed '/RECURSIVE_TARGETS/,/^$$/ { s/install-p[sd][^ ]*//g } ' \


## ,-----
## |	Build
## +-----

${NTI_LIBX11_BUILT}: ${NTI_LIBX11_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		make \
	)


## ,-----
## |	Install
## +-----

${NTI_LIBX11_INSTALLED}: ${NTI_LIBX11_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		make install \
	)

.PHONY: nti-libX11
nti-libX11: nti-pkg-config nti-x11proto nti-libXdmcp nti-libXau nti-x11proto-xcmisc nti-x11proto-bigreqs nti-x11proto-kb nti-x11proto-input ${NTI_LIBX11_INSTALLED}
# [R7.7] nti-libX11: nti-pkg-config nti-libxcb nti-x11proto nti-libXau nti-x11proto-xcmisc nti-x11proto-bigreqs nti-x11proto-kb nti-x11proto-input ${NTI_LIBX11_INSTALLED}

ALL_NTI_TARGETS+= nti-libX11

endif	# HAVE_LIBX11_CONFIG
