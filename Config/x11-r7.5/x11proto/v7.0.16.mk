# x11proto v7.0.16		[ since v7.0.12, c. 2008-06-01 ]
# last mod WmT, 2024-04-09	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_X11PROTO_CONFIG},y)
HAVE_X11PROTO_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${X11PROTO_VERSION},)
X11PROTO_VERSION=7.0.16
#X11PROTO_VERSION=7.0.23
endif

X11PROTO_SRC=${DIR_DOWNLOADS}/x/xproto-${X11PROTO_VERSION}.tar.bz2
X11PROTO_URL+= http://www.x.org/releases/X11R7.5/src/proto/xproto-${X11PROTO_VERSION}.tar.bz2
#X11PROTO_URL+= http://www.x.org/releases/X11R7.7/src/proto/xproto-${X11PROTO_VERSION}.tar.bz2

# Dependencies?
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
#| include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#| include ${CFG_ROOT}/x11-r7.5/x11proto-xext/v7.1.1.mak
#| include ${CFG_ROOT}/x11-r7.5/xtrans/v1.2.5.mak


NTI_X11PROTO_TEMP=${DIR_EXTTEMP}/nti-x11proto-${X11PROTO_VERSION}

NTI_X11PROTO_EXTRACTED=${NTI_X11PROTO_TEMP}/configure
NTI_X11PROTO_CONFIGURED=${NTI_X11PROTO_TEMP}/config.status
NTI_X11PROTO_BUILT=${NTI_X11PROTO_TEMP}/xproto.pc
NTI_X11PROTO_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xproto.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-x11proto-uriurl:
	@echo "${X11PROTO_SRC} ${X11PROTO_URL}"

show-all-uriurl:: show-nti-x11proto-uriurl


${NTI_X11PROTO_EXTRACTED}: | nti-sanity ${X11PROTO_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_X11PROTO_TEMP} ARCHIVES=${X11PROTO_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_X11PROTO_CONFIGURED}: ${NTI_X11PROTO_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_X11PROTO_TEMP} || exit 1 ;\
		[ -r Makefile.in.OLD ] || mv Makefile.in Makefile.in.OLD || exit 1 ;\
		cat Makefile.in.OLD \
			| sed '/^pkgconfigdir/	s%$$.*%$$(prefix)/'${NUI_HOST_SYSTYPE}'/lib/pkgconfig%' \
			> Makefile.in ;\
	  CFLAGS='-O2' \
	  PKG_CONFIG=${DIR_NTI_TOOLCHAIN}/usr/bin/${NUI_HOST_SYSTYPE}-pkg-config \
		PKG_CONFIG_PATH=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr \
			--bindir=${DIR_NTI_TOOLCHAIN}/usr/X11R7/bin \
			|| exit 1 \
	)


${NTI_X11PROTO_BUILT}: ${NTI_X11PROTO_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${NTI_X11PROTO_TEMP} || exit 1 ;\
		make \
	)

${NTI_X11PROTO_INSTALLED}: ${NTI_X11PROTO_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${NTI_X11PROTO_TEMP} || exit 1 ;\
		make install \
	)
 

#

USAGE_TEXT+= "'nti-x11proto' - build x11proto for NTI toolchain"

.PHONY: nti-x11proto
nti-x11proto: nti-pkg-config \
	${NTI_X11PROTO_INSTALLED}

all-nti-targets:: nti-x11proto


endif	# HAVE_X11PROTO_CONFIG
