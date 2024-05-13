# libiconv v1.15		[ since v?.?, c.2018-??-?? ]
# last mod WmT, 2024-02-20	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_LIBICONV},y)
HAVE_LIBICONV:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk

ifeq (${LIBICONV_VERSION},)
#LIBICONV_VERSION=1.9.2
#LIBICONV_VERSION=1.12
#LIBICONV_VERSION=1.14
LIBICONV_VERSION=1.15
endif

LIBICONV_SRC=${DIR_DOWNLOADS}/l/libiconv-${LIBICONV_VERSION}.tar.gz
#|LIBICONV_SRC=${SOURCES}/l/libiconv-${LIBICONV_VERSION}.tar.gz
#|LIBICONV_PATCHES=
LIBICONV_URL=http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/libiconv/libiconv-${LIBICONV_VERSION}.tar.gz

#|ifeq (${LIBICONV_VERSION},1.14)
#|LIBICONV_PATCHES+= ${SOURCES}/l/libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch
#|URLS+= https://raw.githubusercontent.com/chef/omnibus-software/master/config/patches/libiconv/libiconv-1.14_srclib_stdio.in.h-remove-gets-declarations.patch
#|endif


NTI_LIBICONV_TEMP=${DIR_EXTTEMP}/nti-libiconv-${LIBICONV_VERSION}

NTI_LIBICONV_EXTRACTED=${NTI_LIBICONV_TEMP}/README
NTI_LIBICONV_CONFIGURED=${NTI_LIBICONV_TEMP}/config.status
NTI_LIBICONV_BUILT=${NTI_LIBICONV_TEMP}/src/iconv
NTI_LIBICONV_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/iconv


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-libiconv-uriurl:
	@echo "${LIBICONV_SRC} ${LIBICONV_URL}"

show-all-uriurl:: show-nti-libiconv-uriurl


${NTI_LIBICONV_EXTRACTED}: | nti-sanity ${LIBICONV_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_LIBICONV_TEMP} ARCHIVES=${LIBICONV_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_LIBICONV_CONFIGURED}: ${NTI_LIBICONV_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_LIBICONV_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  ./configure --prefix=${DIR_NTI_TOOLCHAIN}/usr \
		)


${NTI_LIBICONV_BUILT}: ${NTI_LIBICONV_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_LIBICONV_TEMP} && make )


${NTI_LIBICONV_INSTALLED}: ${NTI_LIBICONV_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_LIBICONV_TEMP} && make install )


#

USAGE_TEXT+= "'nti-libiconv' - build libiconv for NTI toolchain"

.PHONY: nti-libiconv
nti-libiconv: ${NTI_LIBICONV_INSTALLED}

all-nti-targets:: nti-libiconv


#|## ,-----
#|## |	Extract
#|## +-----
#|
#|${NTI_LIBICONV_EXTRACTED}:
#|	echo "*** (i) EXTRACT -> $@ ***"
#|	[ ! -d ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ] || rm -rf ${EXTTEMP}/libiconv-${LIBICONV_VERSION}
#|	zcat ${LIBICONV_SRC} | tar xvf - -C ${EXTTEMP}
#|ifneq (${LIBICONV_PATCHES},)
#|	( cd ${EXTTEMP} || exit 1 ;\
#|		for PF in ${LIBICONV_PATCHES} ; do \
#|			echo "*** PATCHING -- PF $${PF} ***" ;\
#|			patch --batch -d libiconv-${LIBICONV_VERSION} -Np1 < $${PF} ;\
#|		done \
#|	)
#|endif
#|	[ ! -d ${EXTTEMP}/${NTI_LIBICONV_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_LIBICONV_TEMP}
#|	mv ${EXTTEMP}/libiconv-${LIBICONV_VERSION} ${EXTTEMP}/${NTI_LIBICONV_TEMP}
#|
#|
#|## ,-----
#|## |	Configure
#|## +-----
#|
#|${NTI_LIBICONV_CONFIGURED}: ${NTI_LIBICONV_EXTRACTED}
#|	echo "*** (i) CONFIGURE -> $@ ***"
#|	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
#|		LIBTOOL=${HOSTSPEC}-libtool \
#|		CFLAGS='-O2' \
#|		  ./configure \
#|			--prefix=${NTI_TC_ROOT}/usr \
#|			--disable-largefile --disable-nls \
#|			|| exit 1 \
#|	)
#|#	PKG_CONFIG=${NTI_TC_ROOT}/usr/bin/${HOSTSPEC}-pkg-config
#|#	PKG_CONFIG_PATH=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
#|
#|
#|## ,-----
#|## |	Build
#|## +-----
#|
#|${NTI_LIBICONV_BUILT}: ${NTI_LIBICONV_CONFIGURED}
#|	echo "*** (i) BUILD -> $@ ***"
#|	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
#|		make all \
#|	)
#|#		make all LIBTOOL=${HOSTSPEC}-libtool \
#|
#|
#|## ,-----
#|## |	Install
#|## +-----
#|
#|${NTI_LIBICONV_INSTALLED}: ${NTI_LIBICONV_BUILT}
#|	echo "*** (i) INSTALLED -> $@ ***"
#|	( cd ${EXTTEMP}/${NTI_LIBICONV_TEMP} || exit 1 ;\
#|		make install \
#|	)
#|#		make install LIBTOOL=${HOSTSPEC}-libtool \
#|
#|
#|.PHONY: nti-libiconv
#|#nti-libiconv: nti-libtool ${NTI_LIBICONV_INSTALLED}
#|nti-libiconv: ${NTI_LIBICONV_INSTALLED}
#|
#|ALL_NTI_TARGETS+= nti-libiconv

endif	# HAVE_LIBICONV_CONFIG
