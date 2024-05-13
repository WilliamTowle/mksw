# libXau v1.0.5			[ since v1.0.4, 2008-06-12 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LIBXAU_CONFIG},y)
HAVE_LIBXAU_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LIBXAU_VERSION},)
#LIBXAU_VERSION=1.0.5
LIBXAU_VERSION=1.0.6
endif

LIBXAU_SRC=${DIR_DOWNLOADS}/l/libXau-${LIBXAU_VERSION}.tar.bz2
#LIBXAU_URL=http://www.x.org/releases/X11R7.5/src/lib/libXau-${LIBXAU_VERSION}.tar.bz2
LIBXAU_URL=http://www.x.org/releases/X11R7.6/src/lib/libXau-${LIBXAU_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
include ${MF_CONFIGDIR}/x11-r7.7/x11proto/v7.0.23.mk


NTI_LIBXAU_TEMP=${DIR_EXTTEMP}/nti-libXau-${LIBXAU_VERSION}

NTI_LIBXAU_EXTRACTED=${NTI_LIBXAU_TEMP}/configure
NTI_LIBXAU_CONFIGURED=${NTI_LIBXAU_TEMP}/config.status
NTI_LIBXAU_BUILT=${NTI_LIBXAU_TEMP}/xau.pc
NTI_LIBXAU_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xau.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-libXau-uriurl:
	@echo "${LIBXAU_SRC} ${LIBXAU_URL}"

show-all-uriurl:: show-nti-libXau-uriurl


${NTI_LIBXAU_EXTRACTED}: | nti-sanity ${LIBXAU_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LIBXAU_TEMP} ARCHIVES=${LIBXAU_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_LIBXAU_CONFIGURED}: ${NTI_LIBXAU_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LIBXAU_TEMP} || exit 1 ;\
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


${NTI_LIBXAU_BUILT}: ${NTI_LIBXAU_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAU_TEMP} || exit 1 ;\
		make \
	)


${NTI_LIBXAU_INSTALLED}: ${NTI_LIBXAU_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${EXTTEMP}/${NTI_LIBXAU_TEMP} || exit 1 ;\
		make install \
	)


#

USAGE_TEXT+= "'nti-libXau' - build libXau for NTI toolchain"

.PHONY: nti-libXau
nti-libXau: nti-pkg-config \
	nti-x11proto \
	${NTI_LIBXAU_INSTALLED}

all-nti-targets:: nti-libXau


endif	# HAVE_LIBXAU_CONFIG
