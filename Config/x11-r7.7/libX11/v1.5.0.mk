# libX11 v1.5.0			[ since v1.1.4	2008-06-21 ]
# last mod WmT, 2024-04-11	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LIBX11_CONFIG},y)
HAVE_LIBX11_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LIBX11_VERSION},)
#LIBX11_VERSION=1.3.2
#LIBX11_VERSION=1.4.0
LIBX11_VERSION=1.5.0
endif

LIBX11_SRC=${DIR_DOWNLOADS}/l/libX11-${LIBX11_VERSION}.tar.bz2
#LIBX11_URL=http://www.x.org/releases/X11R7.5/src/lib/libX11-${LIBX11_VERSION}.tar.bz2
#LIBX11_URL=http://www.x.org/releases/X11R7.6/src/lib/libX11-${LIBX11_VERSION}.tar.bz2
LIBX11_URL=http://www.x.org/releases/X11R7.7/src/lib/libX11-${LIBX11_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
#include ${MF_CONFIGDIR}/x11-r7.6/libxcb/v1.7.mk
include ${MF_CONFIGDIR}/x11-r7.7/libxcb/v1.8.1.mk
#| #include ${CFG_ROOT}/x11-r7.6/libXdmcp/v1.1.0.mak
#| #include ${CFG_ROOT}/x11-r7.6/libXau/v1.0.6.mak
#| include ${CFG_ROOT}/x11-r7.7/libXau/v1.0.7.mak
#| ##include ${CFG_ROOT}/gui/libXt/v1.0.7.mak
#| #include ${CFG_ROOT}/x11-r7.6/libXt/v1.0.9.mak
#include ${MF_CONFIGDIR}/x11-r7.6/x11proto/v7.0.20.mk
include ${MF_CONFIGDIR}/x11-r7.7/x11proto/v7.0.23.mk
#| #include ${CFG_ROOT}/x11-r7.6/x11proto-bigreqs/v1.1.1.mak
#| include ${CFG_ROOT}/x11-r7.7/x11proto-bigreqs/v1.1.2.mak
#include ${MF_CONFIGDIR}/x11-r7.6/x11proto-input/v2.0.1.mk
include ${MF_CONFIGDIR}/x11-r7.7/x11proto-input/v2.2.mk
#include ${MF_CONFIGDIR}/x11-r7.6/x11proto-kb/v1.0.5.mk
include ${MF_CONFIGDIR}/x11-r7.7/x11proto-kb/v1.0.6.mk
#| #include ${CFG_ROOT}/x11-r7.6/x11proto-xcmisc/v1.2.1.mak
#| include ${CFG_ROOT}/x11-r7.7/x11proto-xcmisc/v1.2.2.mak
#include ${MF_CONFIGDIR}/x11-r7.6/x11proto-xext/v7.1.2.mk
include ${MF_CONFIGDIR}/x11-r7.7/x11proto-xext/v7.2.1.mk
#include ${MF_CONFIGDIR}/x11-r7.6/xtrans/v1.2.6.mk
include ${MF_CONFIGDIR}/x11-r7.7/xtrans/v1.2.7.mk


NTI_LIBX11_TEMP=${DIR_EXTTEMP}/nti-libX11-${LIBX11_VERSION}

NTI_LIBX11_EXTRACTED=${NTI_LIBX11_TEMP}/configure
NTI_LIBX11_CONFIGURED=${NTI_LIBX11_TEMP}/config.status
NTI_LIBX11_BUILT=${NTI_LIBX11_TEMP}/x11.pc
NTI_LIBX11_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/x11.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-libX11-uriurl:
	@echo "${LIBX11_SRC} ${LIBX11_URL}"

show-all-uriurl:: show-nti-libX11-uriurl


${NTI_LIBX11_EXTRACTED}: | nti-sanity ${LIBX11_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LIBX11_TEMP} ARCHIVES=${LIBX11_SRC} EXTRACT_OPTS='--strip-components=1'


## [2013-05-26] xcb (--without-xcb) possible until v1.5.0+

${NTI_LIBX11_CONFIGURED}: ${NTI_LIBX11_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LIBX11_TEMP} || exit 1 ;\
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
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${NUI_HOST_SYSTYPE}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
		PKG_CONFIG=${PKG_CONFIG_CONFIG_HOST_TOOL} \
		PKG_CONFIG_PATH=${PKG_CONFIG_CONFIG_HOST_PATH} \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr \
			--bindir=${DIR_NTI_TOOLCHAIN}/usr/X11R7/bin \
			--disable-secure-rpc \
			--disable-xf86bigfont \
			|| exit 1 \
	)


${NTI_LIBX11_BUILT}: ${NTI_LIBX11_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		make \
	)


${NTI_LIBX11_INSTALLED}: ${NTI_LIBX11_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBX11_TEMP} || exit 1 ;\
		make install \
	)


#

USAGE_TEXT+= "'nti-libX11' - build libX11 for NTI toolchain"

.PHONY: nti-libX11
nti-libX11: nti-pkg-config \
	nti-libxcb \
	nti-x11proto \
	nti-x11proto-kb \
	nti-x11proto-input \
	nti-x11proto-xext \
	nti-xtrans \
	${NTI_LIBX11_INSTALLED}

all-nti-targets:: nti-libX11


endif	# HAVE_LIBX11_CONFIG
