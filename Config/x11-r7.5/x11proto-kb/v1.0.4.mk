# x11proto-kb v1.0.4		[ since v1.0.3, c. 2008-06-01 ]
# last mod WmT, 2024-04-09	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_X11PROTO_KB_CONFIG},y)
HAVE_X11PROTO_KB_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${X11PROTO_KB_VERSION},)
X11PROTO_KB_VERSION=1.0.4
endif

X11PROTO_KB_SRC=${DIR_DOWNLOADS}/x/xproto-kb-${X11PROTO_KB_VERSION}.tar.bz2
X11PROTO_KB_URL+=http://www.x.org/releases/X11R7.5/src/proto/kbproto-${X11PROTO_KB_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk


NTI_X11PROTO_KB_TEMP=${DIR_EXTTEMP}/nti-x11proto-kb-${X11PROTO_KB_VERSION}

NTI_X11PROTO_KB_EXTRACTED=${NTI_X11PROTO_KB_TEMP}/configure
NTI_X11PROTO_KB_CONFIGURED=${NTI_X11PROTO_KB_TEMP}/config.status
NTI_X11PROTO_KB_BUILT=${NTI_X11PROTO_KB_TEMP}/kbproto.pc
NTI_X11PROTO_KB_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/kbproto.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-x11proto-kb-uriurl:
	@echo "${X11PROTO_KB_SRC} ${X11PROTO_KB_URL}"

show-all-uriurl:: show-nti-x11proto-kb-uriurl


${NTI_X11PROTO_KB_EXTRACTED}: | nti-sanity ${X11PROTO_KB_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_X11PROTO_KB_TEMP} ARCHIVES=${X11PROTO_KB_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_X11PROTO_KB_CONFIGURED}: ${NTI_X11PROTO_KB_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_X11PROTO_KB_TEMP} || exit 1 ;\
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


${NTI_X11PROTO_KB_BUILT}: ${NTI_X11PROTO_KB_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${NTI_X11PROTO_KB_TEMP} || exit 1 ;\
		make \
	)

${NTI_X11PROTO_KB_INSTALLED}: ${NTI_X11PROTO_KB_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${NTI_X11PROTO_KB_TEMP} || exit 1 ;\
		make install \
	)
 

#

USAGE_TEXT+= "'nti-x11proto-kb' - build x11proto-kb for NTI toolchain"

.PHONY: nti-x11proto-kb
nti-x11proto-kb: nti-pkg-config \
	${NTI_X11PROTO_KB_INSTALLED}

all-nti-targets:: nti-x11proto-kb


endif	# HAVE_X11PROTO_KB_CONFIG
