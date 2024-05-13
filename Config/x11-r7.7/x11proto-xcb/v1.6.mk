# x11proto-xcb v1.6		[ since v1.6, c. 2010-08-02 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_X11PROTO_XCB_CONFIG},y)
HAVE_X11PROTO_XCB_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${X11PROTO_XCB_VERSION},)
X11PROTO_XCB_VERSION=1.7.1
endif

X11PROTO_XCB_SRC=${DIR_DOWNLOADS}/x/xcb-proto-${X11PROTO_XCB_VERSION}.tar.bz2
X11PROTO_XCB_URL+= http://www.x.org/releases/X11R7.6/src/xcb/xcb-proto-${X11PROTO_XCB_VERSION}.tar.bz2
#X11PROTO_XCB_URL+= http://www.x.org/releases/X11R7.7/src/xcb/xcb-proto-${X11PROTO_XCB_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk


NTI_X11PROTO_XCB_TEMP=${DIR_EXTTEMP}/nti-x11proto-xcb-${X11PROTO_XCB_VERSION}

NTI_X11PROTO_XCB_EXTRACTED=${NTI_X11PROTO_XCB_TEMP}/configure
NTI_X11PROTO_XCB_CONFIGURED=${NTI_X11PROTO_XCB_TEMP}/config.status
NTI_X11PROTO_XCB_BUILT=${NTI_X11PROTO_XCB_TEMP}/xcb-proto.pc
NTI_X11PROTO_XCB_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xcb-proto.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-x11proto-xcb-uriurl:
	@echo "${X11PROTO_XCB_SRC} ${X11PROTO_XCB_URL}"

show-all-uriurl:: show-nti-x11proto-xcb-uriurl


${NTI_X11PROTO_XCB_EXTRACTED}: | nti-sanity ${X11PROTO_XCB_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_X11PROTO_XCB_TEMP} ARCHIVES=${X11PROTO_XCB_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_X11PROTO_XCB_CONFIGURED}: ${NTI_X11PROTO_XCB_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_X11PROTO_XCB_TEMP} || exit 1 ;\
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


${NTI_X11PROTO_XCB_BUILT}: ${NTI_X11PROTO_XCB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${NTI_X11PROTO_XCB_TEMP} || exit 1 ;\
		make \
	)

${NTI_X11PROTO_XCB_INSTALLED}: ${NTI_X11PROTO_XCB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${NTI_X11PROTO_XCB_TEMP} || exit 1 ;\
		make install \
	)
 

#

USAGE_TEXT+= "'nti-x11proto-xcb' - build x11proto-xcb for NTI toolchain"

.PHONY: nti-x11proto-xcb
nti-x11proto-xcb: nti-pkg-config \
	${NTI_X11PROTO_XCB_INSTALLED}

all-nti-targets:: nti-x11proto-xcb


endif	# HAVE_X11PROTO_XCB_CONFIG
