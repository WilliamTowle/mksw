# libXext v1.2.0		[ since v1.0.99, 2009-09-08 ]
# last mod WmT, 2024-04-11	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LIBXEXT_CONFIG},y)
HAVE_LIBXEXT_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LIBXEXT_VERSION},)
#LIBXEXT_VERSION=1.1.1
LIBXEXT_VERSION=1.2.0
endif

LIBXEXT_SRC=${DIR_DOWNLOADS}/l/libXext-${LIBXEXT_VERSION}.tar.bz2
#LIBXEXT_URL=http://www.x.org/releases/X11R7.5/src/lib/libXext-${LIBXEXT_VERSION}.tar.bz2
LIBXEXT_URL=http://www.x.org/releases/X11R7.6/src/lib/libXext-${LIBXEXT_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
include ${MF_CONFIGDIR}/x11-r7.6/libX11/v1.4.0.mk
include ${MF_CONFIGDIR}/x11-r7.6/x11proto/v7.0.20.mk
include ${MF_CONFIGDIR}/x11-r7.6/x11proto-xext/v7.1.2.mk


NTI_LIBXEXT_TEMP=${DIR_EXTTEMP}/nti-libXext-${LIBXEXT_VERSION}

NTI_LIBXEXT_EXTRACTED=${NTI_LIBXEXT_TEMP}/configure
NTI_LIBXEXT_CONFIGURED=${NTI_LIBXEXT_TEMP}/config.status
NTI_LIBXEXT_BUILT=${NTI_LIBXEXT_TEMP}/xext.pc
NTI_LIBXEXT_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xext.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-libXext-uriurl:
	@echo "${LIBXEXT_SRC} ${LIBXEXT_URL}"

show-all-uriurl:: show-nti-libXext-uriurl


${NTI_LIBXEXT_EXTRACTED}: | nti-sanity ${LIBXEXT_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LIBXEXT_TEMP} ARCHIVES=${LIBXEXT_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_LIBXEXT_CONFIGURED}: ${NTI_LIBXEXT_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LIBXEXT_TEMP} || exit 1 ;\
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


${NTI_LIBXEXT_BUILT}: ${NTI_LIBXEXT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXEXT_TEMP} || exit 1 ;\
		make \
	)


${NTI_LIBXEXT_INSTALLED}: ${NTI_LIBXEXT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXEXT_TEMP} || exit 1 ;\
		make install \
	)


#

USAGE_TEXT+= "'nti-libXext' - build libXext for NTI toolchain"

.PHONY: nti-libXext
nti-libXext: nti-pkg-config \
	nti-libX11 \
	nti-x11proto \
	nti-x11proto-xext \
	${NTI_LIBXEXT_INSTALLED}

all-nti-targets:: nti-libXext


endif	# HAVE_LIBXEXT_CONFIG
