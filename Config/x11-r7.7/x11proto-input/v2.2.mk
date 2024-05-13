# x11proto-input v2.2		[ since v1.4.3, c. 2008-06-01 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_X11PROTO_INPUT_CONFIG},y)
HAVE_X11PROTO_INPUT_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${X11PROTO_INPUT_VERSION},)
#X11PROTO_INPUT_VERSION=2.0
#X11PROTO_INPUT_VERSION=2.0.1
X11PROTO_INPUT_VERSION=2.2
endif

X11PROTO_INPUT_SRC=${DIR_DOWNLOADS}/x/xproto-input-${X11PROTO_INPUT_VERSION}.tar.bz2
#X11PROTO_INPUT_URL+=http://www.x.org/releases/X11R7.5/src/proto/inputproto-${X11PROTO_INPUT_VERSION}.tar.bz2
#X11PROTO_INPUT_URL+=http://www.x.org/releases/X11R7.6/src/proto/inputproto-${X11PROTO_INPUT_VERSION}.tar.bz2
X11PROTO_INPUT_URL+=http://www.x.org/releases/X11R7.7/src/proto/inputproto-${X11PROTO_INPUT_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk


NTI_X11PROTO_INPUT_TEMP=${DIR_EXTTEMP}/nti-x11proto-input-${X11PROTO_INPUT_VERSION}

NTI_X11PROTO_INPUT_EXTRACTED=${NTI_X11PROTO_INPUT_TEMP}/configure
NTI_X11PROTO_INPUT_CONFIGURED=${NTI_X11PROTO_INPUT_TEMP}/config.status
NTI_X11PROTO_INPUT_BUILT=${NTI_X11PROTO_INPUT_TEMP}/inputproto.pc
NTI_X11PROTO_INPUT_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/inputproto.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-x11proto-input-uriurl:
	@echo "${X11PROTO_INPUT_SRC} ${X11PROTO_INPUT_URL}"

show-all-uriurl:: show-nti-x11proto-input-uriurl


${NTI_X11PROTO_INPUT_EXTRACTED}: | nti-sanity ${X11PROTO_INPUT_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_X11PROTO_INPUT_TEMP} ARCHIVES=${X11PROTO_INPUT_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_X11PROTO_INPUT_CONFIGURED}: ${NTI_X11PROTO_INPUT_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_X11PROTO_INPUT_TEMP} || exit 1 ;\
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


${NTI_X11PROTO_INPUT_BUILT}: ${NTI_X11PROTO_INPUT_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${NTI_X11PROTO_INPUT_TEMP} || exit 1 ;\
		make \
	)

${NTI_X11PROTO_INPUT_INSTALLED}: ${NTI_X11PROTO_INPUT_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${NTI_X11PROTO_INPUT_TEMP} || exit 1 ;\
		make install \
	)
 

#

USAGE_TEXT+= "'nti-x11proto-input' - build x11proto-input for NTI toolchain"

.PHONY: nti-x11proto-input
nti-x11proto-input: nti-pkg-config \
	${NTI_X11PROTO_INPUT_INSTALLED}

all-nti-targets:: nti-x11proto-input


endif	# HAVE_X11PROTO_INPUT_CONFIG
