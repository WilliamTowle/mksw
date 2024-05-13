# xdesktopwaves v1.3		[ since v1.3, 2024-04-02 ]
# last mod WmT, 2024-04-10	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_XDESKTOPWAVES_CONFIG},y)
HAVE_XDESKTOPWAVES_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${XDESKTOPWAVES_VERSION},)
XDESKTOPWAVES_VERSION=1.3
endif

XDESKTOPWAVES_SRC=${DIR_DOWNLOADS}/x/xdesktopwaves-${XDESKTOPWAVES_VERSION}.tar.gz
XDESKTOPWAVES_URL= http://ftp.debian.org/debian/pool/main/x/xdesktopwaves/xdesktopwaves_${XDESKTOPWAVES_VERSION}.orig.tar.gz


# Dependencies: pkg-config, X11, libXext
# [2024-04-09] Possible dependency on X11r7.6 based on #includes
include ${MF_CONFIGDIR}/build-tools/pkg-config/v0.29.2.mk
#include ${MF_CONFIGDIR}/x11-r7.5/libXext/v1.1.1.mk
#include ${MF_CONFIGDIR}/x11-r7.6/libXext/v1.2.0.mk
#include ${MF_CONFIGDIR}/x11-r7.7/libXext/v1.3.1.mk
#nclude ${MF_CONFIGDIR}/x11-r7.5/libX11/v1.3.2.mk
#include ${MF_CONFIGDIR}/x11-r7.6/libX11/v1.4.0.mk
#include ${MF_CONFIGDIR}/x11-r7.7/libX11/v1.5.0.mk

NTI_XDESKTOPWAVES_TEMP=${DIR_EXTTEMP}/nti-xdesktopwaves-${XDESKTOPWAVES_VERSION}

NTI_XDESKTOPWAVES_EXTRACTED=${NTI_XDESKTOPWAVES_TEMP}/README
NTI_XDESKTOPWAVES_CONFIGURED=${NTI_XDESKTOPWAVES_TEMP}/Makefile.OLD
NTI_XDESKTOPWAVES_BUILT=${NTI_XDESKTOPWAVES_TEMP}/xdesktopwaves
NTI_XDESKTOPWAVES_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/xdesktopwaves


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-xdesktopwaves-uriurl:
	@echo "${XDESKTOPWAVES_SRC} ${XDESKTOPWAVES_URL}"

show-all-uriurl:: show-nti-xdesktopwaves-uriurl


${NTI_XDESKTOPWAVES_EXTRACTED}: | nti-sanity ${XDESKTOPWAVES_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_XDESKTOPWAVES_TEMP} ARCHIVES=${XDESKTOPWAVES_SRC} EXTRACT_OPTS='--strip-components=1'


# [2024-04-09] /!\ HACK HERE! shape.h normally part of xext

${NTI_XDESKTOPWAVES_CONFIGURED}: ${NTI_XDESKTOPWAVES_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^CFLAGS[ 	]*=/	s%=.*%= '`${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags x11`'%' \
			| sed '/^LFLAGS[ 	]*=/	s%=.*%= '`${PKG_CONFIG_CONFIG_HOST_TOOL} --libs-only-L x11`'%' \
			| sed '/^BINDIR[ 	]*=/	{ s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr% ; s%/X11R6%% }' \
			| sed '/^MAN1DIR[ 	]*=/	{ s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr% ; s%/X11R6%% }' \
			> Makefile \
	)

${NTI_XDESKTOPWAVES_BUILT}: ${NTI_XDESKTOPWAVES_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		make \
	)


${NTI_XDESKTOPWAVES_INSTALLED}: ${NTI_XDESKTOPWAVES_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_XDESKTOPWAVES_TEMP} || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/bin ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/man/man1 ;\
		make install \
	)



#

USAGE_TEXT+= "'nti-xdesktopwaves' - build xdesktopwaves for NTI toolchain"

#.PHONY: nti-xdesktopwaves
#nti-xdesktopwaves: \
#	nti-pkg-config \
#	nti-libX11 \
#	nti-libXext \
#	${NTI_XDESKTOPWAVES_INSTALLED}
nti-xdesktopwaves: \
	nti-pkg-config \
	${DIR_NTI_TOOLCHAIN}/usr/lib/libX11.a \
	${DIR_NTI_TOOLCHAIN}/usr/lib/libXext.a \
	${NTI_XDESKTOPWAVES_INSTALLED}


all-nti-targets:: nti-xdesktopwaves


endif	# HAVE_XDESKTOPWAVES_CONFIG
