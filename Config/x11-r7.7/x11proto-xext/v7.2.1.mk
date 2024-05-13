# x11proto-xext v7.2.1		[ since v7.0.4, c. 2008-06-08 ]
# last mod WmT, 2024-04-11	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_X11PROTO_XEXT_CONFIG},y)
HAVE_X11PROTO_XEXT_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${X11PROTO_XEXT_VERSION},)
#X11PROTO_XEXT_VERSION=7.1.1
#X11PROTO_XEXT_VERSION=7.1.2
X11PROTO_XEXT_VERSION=7.2.1
endif

X11PROTO_XEXT_SRC=${DIR_DOWNLOADS}/x/xproto-xext-${X11PROTO_XEXT_VERSION}.tar.bz2
#X11PROTO_XEXT_URL+= http://www.x.org/releases/X11R7.5/src/proto/xextproto-${X11PROTO_XEXT_VERSION}.tar.bz2
#X11PROTO_XEXT_URL+= http://www.x.org/releases/X11R7.6/src/proto/xextproto-${X11PROTO_XEXT_VERSION}.tar.bz2
X11PROTO_XEXT_URL+= http://www.x.org/releases/X11R7.7/src/proto/xextproto-${X11PROTO_XEXT_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk


NTI_X11PROTO_XEXT_TEMP=${DIR_EXTTEMP}/nti-x11proto-xext-${X11PROTO_XEXT_VERSION}

NTI_X11PROTO_XEXT_EXTRACTED=${NTI_X11PROTO_XEXT_TEMP}/configure
NTI_X11PROTO_XEXT_CONFIGURED=${NTI_X11PROTO_XEXT_TEMP}/config.status
NTI_X11PROTO_XEXT_BUILT=${NTI_X11PROTO_XEXT_TEMP}/xextproto.pc
NTI_X11PROTO_XEXT_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xextproto.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-x11proto-xext-uriurl:
	@echo "${X11PROTO_XEXT_SRC} ${X11PROTO_XEXT_URL}"

show-all-uriurl:: show-nti-x11proto-xext-uriurl


${NTI_X11PROTO_XEXT_EXTRACTED}: | nti-sanity ${X11PROTO_XEXT_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_X11PROTO_XEXT_TEMP} ARCHIVES=${X11PROTO_XEXT_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_X11PROTO_XEXT_CONFIGURED}: ${NTI_X11PROTO_XEXT_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_X11PROTO_XEXT_TEMP} || exit 1 ;\
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


${NTI_X11PROTO_XEXT_BUILT}: ${NTI_X11PROTO_XEXT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${NTI_X11PROTO_XEXT_TEMP} || exit 1 ;\
		make \
	)

${NTI_X11PROTO_XEXT_INSTALLED}: ${NTI_X11PROTO_XEXT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${NTI_X11PROTO_XEXT_TEMP} || exit 1 ;\
		make install \
	)
 

#

USAGE_TEXT+= "'nti-x11proto-xext' - build x11proto-xext for NTI toolchain"

.PHONY: nti-x11proto-xext
nti-x11proto-xext: nti-pkg-config \
	${NTI_X11PROTO_XEXT_INSTALLED}

all-nti-targets:: nti-x11proto-xext


endif	# HAVE_X11PROTO_XEXT_CONFIG
