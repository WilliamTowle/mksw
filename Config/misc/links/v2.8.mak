# links v2.8			[ since v2.8, 2014-03-27 ]
# last mod WmT, 2014-07-22	[ (c) and GPLv2 1999-2014* ]

ifneq (${HAVE_LINKS},y)
HAVE_LINKS:=y

#DESCRLIST+= "'nti-links' -- links"

include ${CFG_ROOT}/ENV/buildtype.mak

ifeq (${LINKS_VERSION},)
LINKS_VERSION=2.8
endif

LINKS_SRC=${SOURCES}/l/links-${LINKS_VERSION}.tar.bz2
URLS+= http://links.twibright.com/download/links-2.8.tar.bz2

include ${CFG_ROOT}/buildtools/pkg-config/v0.23.mak
#include ${CFG_ROOT}/buildtools/pkg-config/v0.27.1.mak
#include ${CFG_ROOT}/buildtools/libtool/v1.5.26.mak
##include ${CFG_ROOT}/buildtools/libtool/v2.4.2.mak

#include ${CFG_ROOT}/audvid/libpng/v1.6.10.mak
include ${CFG_ROOT}/audvid/libpng/v1.6.34.mak
include ${CFG_ROOT}/tui/gpm/v1.20.7.mak

NTI_LINKS_TEMP=nti-links-${LINKS_VERSION}

NTI_LINKS_EXTRACTED=${EXTTEMP}/${NTI_LINKS_TEMP}/configure
NTI_LINKS_CONFIGURED=${EXTTEMP}/${NTI_LINKS_TEMP}/config.status
NTI_LINKS_BUILT=${EXTTEMP}/${NTI_LINKS_TEMP}/links
NTI_LINKS_INSTALLED=${NTI_TC_ROOT}/usr/bin/links



## ,-----
## |	Extract
## +-----

${NTI_LINKS_EXTRACTED}:
	echo "*** (i) EXTRACT -> $@ ***"
	[ ! -d ${EXTTEMP}/links-${LINKS_VERSION} ] || rm -rf ${EXTTEMP}/links-${LINKS_VERSION}
	bzcat ${LINKS_SRC} | tar xvf - -C ${EXTTEMP}
	[ ! -d ${EXTTEMP}/${NTI_LINKS_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LINKS_TEMP}
	mv ${EXTTEMP}/links-${LINKS_VERSION} ${EXTTEMP}/${NTI_LINKS_TEMP}


## ,-----
## |	Configure
## +-----

## [2014-07-22] CPPFLAGS lets configure validate "<gpm.h>" via $ac_cpp

${NTI_LINKS_CONFIGURED}: ${NTI_LINKS_EXTRACTED}
	echo "*** (i) CONFIGURE -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LINKS_TEMP} || exit 1 ;\
		CPPFLAGS='-I'${NTI_TC_ROOT}'/usr/include' \
		LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
		PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config \
		PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
		  ./configure \
			--prefix=${NTI_TC_ROOT}/usr \
			--enable-graphics \
				--without-x --without-directfb --without-svgalib \
				--with-fb --enable-gpm \
			--with-zlib \
			--disable-utf8 \
			|| exit 1 \
	)


## ,-----
## |	Build
## +-----

${NTI_LINKS_BUILT}: ${NTI_LINKS_CONFIGURED}
	echo "*** (i) BUILD -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LINKS_TEMP} || exit 1 ;\
		make all \
	)


## ,-----
## |	Install
## +-----

${NTI_LINKS_INSTALLED}: ${NTI_LINKS_BUILT}
	echo "*** (i) INSTALLED -> $@ ***"
	( cd ${EXTTEMP}/${NTI_LINKS_TEMP} || exit 1 ;\
		make install \
	)


##

.PHONY: nti-links
nti-links: nti-pkg-config nti-libpng \
	nti-gpm ${NTI_LINKS_INSTALLED}

ALL_NTI_TARGETS+= nti-links

endif	# HAVE_LINKS_CONFIG
