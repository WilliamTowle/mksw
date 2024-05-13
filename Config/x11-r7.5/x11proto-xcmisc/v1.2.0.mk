# x11proto-xcmisc v1.2.0	[ since v1.1.2, c. 2008-06-08 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_X11PROTO_XCMISC_CONFIG},y)
HAVE_X11PROTO_XCMISC_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${X11PROTO_XCMISC_VERSION},)
X11PROTO_XCMISC_VERSION=1.2.0
endif

X11PROTO_XCMISC_SRC=${DIR_DOWNLOADS}/x/xcmiscproto-${X11PROTO_XCMISC_VERSION}.tar.bz2
X11PROTO_XCMISC_URL+= http://www.x.org/releases/X11R7.5/src/proto/xcmiscproto-${X11PROTO_XCMISC_VERSION}.tar.bz2

# Dependencies
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk


NTI_X11PROTO_XCMISC_TEMP=${DIR_EXTTEMP}/nti-x11proto-xcmisc-${X11PROTO_XCMISC_VERSION}

NTI_X11PROTO_XCMISC_EXTRACTED=${NTI_X11PROTO_XCMISC_TEMP}/configure
NTI_X11PROTO_XCMISC_CONFIGURED=${NTI_X11PROTO_XCMISC_TEMP}/config.status
NTI_X11PROTO_XCMISC_BUILT=${NTI_X11PROTO_XCMISC_TEMP}/xcmiscproto.pc
NTI_X11PROTO_XCMISC_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig/xcmiscproto.pc


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-x11proto-xcmisc-uriurl:
	@echo "${X11PROTO_XCMISC_SRC} ${X11PROTO_XCMISC_URL}"

show-all-uriurl:: show-nti-x11proto-xcmisc-uriurl


${NTI_X11PROTO_XCMISC_EXTRACTED}: | nti-sanity ${X11PROTO_XCMISC_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_X11PROTO_XCMISC_TEMP} ARCHIVES=${X11PROTO_XCMISC_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_X11PROTO_XCMISC_CONFIGURED}: ${NTI_X11PROTO_XCMISC_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_X11PROTO_XCMISC_TEMP} || exit 1 ;\
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


${NTI_X11PROTO_XCMISC_BUILT}: ${NTI_X11PROTO_XCMISC_CONFIGURED}
	echo "*** $@ (BUILT) ***"
	( cd ${NTI_X11PROTO_XCMISC_TEMP} || exit 1 ;\
		make \
	)

${NTI_X11PROTO_XCMISC_INSTALLED}: ${NTI_X11PROTO_XCMISC_BUILT}
	echo "*** $@ (INSTALLED) ***"
	( cd ${NTI_X11PROTO_XCMISC_TEMP} || exit 1 ;\
		make install \
	)
 

#

USAGE_TEXT+= "'nti-x11proto-xcmisc' - build x11proto-xcmisc for NTI toolchain"

.PHONY: nti-x11proto-xcmisc
nti-x11proto-xcmisc: nti-pkg-config \
	${NTI_X11PROTO_XCMISC_INSTALLED}

all-nti-targets:: nti-x11proto-xcmisc


endif	# HAVE_X11PROTO_XCMISC_CONFIG
