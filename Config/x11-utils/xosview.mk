# xosview v1.9.4		[ since v1.8.3, 2009-09-04 ]
# last mod WmT, 2024-04-26	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_XOSVIEW_CONFIG},y)
HAVE_XOSVIEW_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

#| # http://www.mirrorservice.org/sites/archive.ubuntu.com/ubuntu/pool/universe/x/xosview/xosview_1.9.3.orig.tar.gz
#| # also via http://www.pogo.org.uk/~mark/xosview/releases/xosview-1.9.3.tar.gz
#| 
ifeq (${XOSVIEW_VERSION},)
XOSVIEW_VERSION=1.9.4
endif

#| XOSVIEW_SUBDIR	= xosview-${XOSVIEW_VERSION}
#| XOSVIEW_ARCHIVE	= ${SOURCE}/x/xosview_${XOSVIEW_VERSION}.orig.tar.gz
XOSVIEW_SRC=${DIR_DOWNLOADS}/x/xosview-${XOSVIEW_VERSION}.tar.gz
XOSVIEW_URL= http://www.pogo.org.uk/~mark/xosview/releases/xosview-${XOSVIEW_VERSION}.tar.gz

# Dependencies
#include ${MF_CONFIGDIR}/x11-r7.5/libX11/v1.3.2.mk
#include ${MF_CONFIGDIR}/x11-r7.6/libX11/v1.4.0.mk
#include ${MF_CONFIGDIR}/x11-r7.7/libX11/v1.5.0.mk


NTI_XOSVIEW_TEMP=${DIR_EXTTEMP}/nti-xosview-${XOSVIEW_VERSION}

NTI_XOSVIEW_EXTRACTED=${NTI_XOSVIEW_TEMP}/README
NTI_XOSVIEW_CONFIGURED=${NTI_XOSVIEW_TEMP}/Makefile.OLD
NTI_XOSVIEW_BUILT=${NTI_XOSVIEW_TEMP}/xosview
NTI_XOSVIEW_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/xosview


#| ## ,-----
#| ## |	Build
#| ## +-----
#| 
#| ${XOSVIEW_BUILT}: ${XOSVIEW_CONFIGURED}
#| 	echo "*** (i) BUILD -> $@ ***"
#| 	( cd ${TMPDIR}/${XOSVIEW_SUBDIR} || exit 1 ;\
#| 		make \
#| 	)
#| 
#| 
#| ## ,-----
#| ## |	Install
#| ## +-----
#| 
#| ${XOSVIEW_INSTALLED}:
#| 	${MAKE} ${XOSVIEW_BUILT}
#| 	echo "*** (i) INSTALL -> $@ ***"
#| 	( cd ${TMPDIR}/${XOSVIEW_SUBDIR} || exit 1 ;\
#| 		make install \
#| 	)
#| 
#| .PHONY: nti-xosview
#| nti-xosview:
#| 	${MAKE} ${XOSVIEW_INSTALLED}
#| 
#| ALL_NTI_TARGETS+= nti-xosview

## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-xosview-uriurl:
	@echo "${XOSVIEW_SRC} ${XOSVIEW_URL}"

show-all-uriurl:: show-nti-xosview-uriurl


${NTI_XOSVIEW_EXTRACTED}: | nti-sanity ${XOSVIEW_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_XOSVIEW_TEMP} ARCHIVES=${XOSVIEW_SRC} EXTRACT_OPTS='--strip-components=1'


# [2024-04-09] /!\ HACK HERE! shape.h normally part of xext

${NTI_XOSVIEW_CONFIGURED}: ${NTI_XOSVIEW_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
#| 	( cd ${NTI_XOSVIEW_TEMP} || exit 1 ;\
#| 		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
#| 		cat Makefile.OLD \
#| 			| sed '/^CFLAGS[ 	]*=/	s%=.*%= '`${PKG_CONFIG_CONFIG_HOST_TOOL} --cflags x11`'%' \
#| 			| sed '/^LFLAGS[ 	]*=/	s%=.*%= '`${PKG_CONFIG_CONFIG_HOST_TOOL} --libs-only-L x11`'%' \
#| 			| sed '/^BINDIR[ 	]*=/	{ s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr% ; s%/X11R6%% }' \
#| 			| sed '/^MAN1DIR[ 	]*=/	{ s%/usr%'${DIR_NTI_TOOLCHAIN}'/usr% ; s%/X11R6%% }' \
#| 			> Makefile \
#| 	)
	( cd ${NTI_XOSVIEW_TEMP} || exit 1 ;\
		[ -r Makefile.OLD ] || mv Makefile Makefile.OLD ;\
		cat Makefile.OLD \
			| sed '/^PREFIX/	s%/usr.*%'${DIR_NTI_TOOLCHAIN}'/usr%' \
			| sed '/^CPPFLAGS/	s%-I\.%-I. -I'${DIR_NTI_TOOLCHAIN}'/usr/include%' \
			| sed '/^LDLIBS/	s%^%LDFLAGS=-L'${DIR_NTI_TOOLCHAIN}'/usr/lib/\n%' \
			> Makefile \
	)


${NTI_XOSVIEW_BUILT}: ${NTI_XOSVIEW_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_XOSVIEW_TEMP} || exit 1 ;\
		make \
	)


${NTI_XOSVIEW_INSTALLED}: ${NTI_XOSVIEW_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_XOSVIEW_TEMP} || exit 1 ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/bin ;\
		mkdir -p ${DIR_NTI_TOOLCHAIN}/usr/man/man1 ;\
		make install \
	)



#

USAGE_TEXT+= "'nti-xosview' - build xosview for NTI toolchain"

#.PHONY: nti-xosview
#nti-xosview: \
#	nti-libX11 \
#	${NTI_XOSVIEW_INSTALLED}
nti-xosview: \
	${DIR_NTI_TOOLCHAIN}/usr/lib/libX11.a \
	${NTI_XOSVIEW_INSTALLED}

all-nti-targets:: nti-xosview



endif	# HAVE_XOSVIEW_CONFIG
