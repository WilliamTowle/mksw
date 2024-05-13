# libxcb v1.4			[ since v1.9	2013-01-04 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LIBXCB_CONFIG},y)
HAVE_LIBXCB_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LIBXCB_VERSION},)
LIBXCB_VERSION=1.4
endif

# libxcb sources are alongside X11R7.6+
# see also /releases/individual/lib and /releases/individual/xcb
LIBXCB_SRC=${DIR_DOWNLOADS}/l/libxcb-${LIBXCB_VERSION}.tar.bz2
LIBXCB_URL=http://www.x.org/releases/individual/xcb/libxcb-${LIBXCB_VERSION}.tar.bz2
#LIBXCB_URL=http://www.x.org/releases/X11R7.7/src/xcb/libxcb-${LIBXCB_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
include ${MF_CONFIGDIR}/x11-r7.5/libpthread-stubs/v0.1.mk
include ${MF_CONFIGDIR}/x11-r7.5/libXau/v1.0.5.mk
include ${MF_CONFIGDIR}/x11-r7.5/x11proto-xcb/v1.7.1.mk


NTI_LIBXCB_TEMP=${DIR_EXTTEMP}/nti-libxcb-${LIBXCB_VERSION}

NTI_LIBXCB_EXTRACTED=${NTI_LIBXCB_TEMP}/configure
NTI_LIBXCB_CONFIGURED=${NTI_LIBXCB_TEMP}/config.status
NTI_LIBXCB_BUILT=${NTI_LIBXCB_TEMP}/xcb.pc
NTI_LIBXCB_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xcb.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-libxcb-uriurl:
	@echo "${LIBXCB_SRC} ${LIBXCB_URL}"

show-all-uriurl:: show-nti-libxcb-uriurl


${NTI_LIBXCB_EXTRACTED}: | nti-sanity ${LIBXCB_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LIBXCB_TEMP} ARCHIVES=${LIBXCB_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_LIBXCB_CONFIGURED}: ${NTI_LIBXCB_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LIBXCB_TEMP} || exit 1 ;\
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
			|| exit 1 \
	)


${NTI_LIBXCB_BUILT}: ${NTI_LIBXCB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
		make \
	)


${NTI_LIBXCB_INSTALLED}: ${NTI_LIBXCB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXCB_TEMP} || exit 1 ;\
		make install \
	)


#

USAGE_TEXT+= "'nti-libxcb' - build libxcb for NTI toolchain"

.PHONY: nti-libxcb
nti-libxcb: nti-pkg-config \
	nti-libpthread-stubs \
	nti-libXau \
	nti-x11proto-xcb \
	${NTI_LIBXCB_INSTALLED}

all-nti-targets:: nti-libxcb


endif	# HAVE_LIBXCB_CONFIG
