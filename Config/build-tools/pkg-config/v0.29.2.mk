# pkg-config v0.29.2		[ since v0.23 2009-09-07 ]
# last mod WmT, 2024-04-05	[ (c) and GPLv2 1999-2024 ]

ifneq (${HAVE_PKG_CONFIG_CONFIG},y)
HAVE_PKG_CONFIG_CONFIG:=y

include ${MF_CONFIGDIR}/INCLUDE/build-native-toolchain.mk


ifeq (${PKG_CONFIG_VERSION},)
#PKG_CONFIG_VERSION=0.27.1
#PKG_CONFIG_VERSION=0.28
#PKG_CONFIG_VERSION=0.29
PKG_CONFIG_VERSION=0.29.2
endif

PKG_CONFIG_SRC=${DIR_DOWNLOADS}/p/pkg-config-${PKG_CONFIG_VERSION}.tar.gz
PKG_CONFIG_URL= http://pkgconfig.freedesktop.org/releases/pkg-config-${PKG_CONFIG_VERSION}.tar.gz

# Dependencies
include ${MF_CONFIGDIR}/misc/libiconv/v1.15.mk

NTI_PKG_CONFIG_TEMP=${DIR_EXTTEMP}/nti-pkg-config-${PKG_CONFIG_VERSION}

NTI_PKG_CONFIG_EXTRACTED=${NTI_PKG_CONFIG_TEMP}/README
NTI_PKG_CONFIG_CONFIGURED=${NTI_PKG_CONFIG_TEMP}/config.status
NTI_PKG_CONFIG_BUILT=${NTI_PKG_CONFIG_TEMP}/pkg-config
NTI_PKG_CONFIG_INSTALLED=${DIR_NTI_TOOLCHAIN}/usr/bin/${NUI_HOST_SYSTYPE}-pkg-config


#|CTI_PKG_CONFIG_TEMP=cti-pkg-config-${PKG_CONFIG_VERSION}
#|
#|CTI_PKG_CONFIG_EXTRACTED=${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}/Makefile
#|CTI_PKG_CONFIG_CONFIGURED=${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}/config.log
#|CTI_PKG_CONFIG_BUILT=${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}/pkg-config
#|CTI_PKG_CONFIG_INSTALLED=${CTI_TC_ROOT}/usr/bin/${TARGSPEC}-pkg-config


PKG_CONFIG_CONFIG_HOST_TOOL=${DIR_NTI_TOOLCHAIN}/usr/bin/${NUI_HOST_SYSTYPE}-pkg-config
PKG_CONFIG_CONFIG_HOST_PATH=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig


## ,-----
## |	Rules - download, extract, configure, build, install

show-nti-pkg-config-uriurl:
	@echo "${PKG_CONFIG_SRC} ${PKG_CONFIG_URL}"

show-all-uriurl:: show-nti-pkg-config-uriurl


${NTI_PKG_CONFIG_EXTRACTED}: | nti-sanity ${PKG_CONFIG_SRC}
	echo "*** $@ (EXTRACT) ***"
	${MAKE} extract DESTDIR=${NTI_PKG_CONFIG_TEMP} ARCHIVES=${PKG_CONFIG_SRC} EXTRACT_OPTS='--strip-components=1'


${NTI_PKG_CONFIG_CONFIGURED}: ${NTI_PKG_CONFIG_EXTRACTED}
	echo "*** $@ (CONFIGURE) ***"
	( cd ${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
		CC=${NTI_GCC} \
		  CFLAGS='-O2 -I'${DIR_NTI_TOOLCHAIN}'/usr/include' \
		  LDFLAGS='-L'${DIR_NTI_TOOLCHAIN}'/usr/lib' \
		./configure \
			--prefix=${DIR_NTI_TOOLCHAIN}/usr \
			--with-iconv=gnu \
			--with-libiconv=gnu \
			--with-pc-path=${DIR_NTI_TOOLCHAIN}/usr/${NUI_HOST_SYSTYPE}/lib/pkgconfig \
			--program-prefix=${NUI_HOST_SYSTYPE}- \
			--with-internal-glib \
			|| exit 1 ;\
		case ${PKG_CONFIG_VERSION} in \
		0.28|0.29|0.29.2) \
			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
			cat Makefile.OLD \
				| sed '/^	/	{ /install-exec-hook/ s/^/#/ }' \
				> Makefile \
		;; \
		*) \
			echo "Unexpected version ${PKG_CONFIG_VERSION}" 1>&2 ;\
			exit 1 \
		;; \
		esac \
	)


${NTI_PKG_CONFIG_BUILT}: ${NTI_PKG_CONFIG_CONFIGURED}
	echo "*** $@ (BUILD) ***"
	( cd ${NTI_PKG_CONFIG_TEMP} && make )


${NTI_PKG_CONFIG_INSTALLED}: ${NTI_PKG_CONFIG_BUILT}
	echo "*** $@ (INSTALL) ***"
	( cd ${NTI_PKG_CONFIG_TEMP} && make install )

#

USAGE_TEXT+= "'nti-pkg-config' - build pkg-config for NTI toolchain"

.PHONY: nti-pkg-config
nti-pkg-config: nti-libiconv ${NTI_PKG_CONFIG_INSTALLED}

all-nti-targets:: nti-pkg-config


#|## ,-----
#|## |	Extract
#|## +-----
#|
#|${NTI_PKG_CONFIG_EXTRACTED}:
#|	echo "*** (i) EXTRACT -> $@ ***"
#|	[ ! -d ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ] || rm -rf ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION}
#|	zcat ${PKG_CONFIG_SRC} | tar xvf - -C ${EXTTEMP}
#|	[ ! -d ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}
#|	mv ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP}
#|
#|##
#|
#|${CTI_PKG_CONFIG_EXTRACTED}:
#|	echo "*** (i) EXTRACT -> $@ ***"
#|	[ ! -d ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ] || rm -rf ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION}
#|	zcat ${PKG_CONFIG_SRC} | tar xvf - -C ${EXTTEMP}
#|	[ ! -d ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} ] || rm -rf ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}
#|	mv ${EXTTEMP}/pkg-config-${PKG_CONFIG_VERSION} ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP}
#|
#|
#|## ,-----
#|## |	Configure
#|## +-----
#|
#|## [v0.29.2] --with-iconv=gnu -> passes "GNU libiconv not in use" test
#|## [v0.29.2] hbOS: -march=i486 -> passes "lock-free atomic intrinsics" test
#|
#|${NTI_PKG_CONFIG_CONFIGURED}: ${NTI_PKG_CONFIG_EXTRACTED}
#|	echo "*** (i) CONFIGURE -> $@ ***"
#|	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
#|	  CC=${NTI_GCC} \
#|	  CFLAGS='-O2 -I'${NTI_TC_ROOT}'/usr/include' \
#|	  LDFLAGS='-L'${NTI_TC_ROOT}'/usr/lib' \
#|		./configure \
#|			--prefix=${NTI_TC_ROOT}/usr \
#|			--with-iconv=gnu \
#|			--with-libiconv=gnu \
#|			--with-pc-path=${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig \
#|			--program-prefix=${HOSTSPEC}- \
#|			--with-internal-glib \
#|			|| exit 1 ;\
#|		case ${PKG_CONFIG_VERSION} in \
#|		0.28|0.29|0.29.2) \
#|			[ -r Makefile.OLD ] || mv Makefile Makefile.OLD || exit 1 ;\
#|			cat Makefile.OLD \
#|				| sed '/^	/	{ /install-exec-hook/ s/^/#/ }' \
#|				> Makefile \
#|		;; \
#|		*) \
#|			echo "Unexpected version ${PKG_CONFIG_VERSION}" 1>&2 ;\
#|			exit 1 \
#|		;; \
#|		esac \
#|	)
#|
#|##
#|
#|${CTI_PKG_CONFIG_CONFIGURED}: ${CTI_PKG_CONFIG_EXTRACTED}
#|	echo "*** (i) CONFIGURE -> $@ ***"
#|	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
#|	  CFLAGS='-O2' \
#|		./configure \
#|			--prefix=${CTI_TC_ROOT}/usr/${TARGSPEC}/usr \
#|			--bindir=${CTI_TC_ROOT}/usr/bin \
#|			--datadir=${CTI_TC_ROOT}/usr/${TARGSPEC}/lib \
#|			  --host=${HOSTSPEC} \
#|			  --build=${HOSTSPEC} \
#|			  --target=${TARGSPEC} \
#|			--program-prefix=${TARGSPEC}- \
#|			|| exit 1 \
#|	)
#|
#|
#|## ,-----
#|## |	Build
#|## +-----
#|
#|${CTI_PKG_CONFIG_BUILT}: ${CTI_PKG_CONFIG_CONFIGURED}
#|	echo "*** (i) BUILD -> $@ ***"
#|	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
#|		make PKG_CONFIG=${TARGSPEC}-pkg-config \
#|	)
#|
#|##
#|
#|${NTI_PKG_CONFIG_BUILT}: ${NTI_PKG_CONFIG_CONFIGURED}
#|	echo "*** (i) BUILD -> $@ ***"
#|	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
#|		make \
#|	)
#|#		make PKG_CONFIG=${HOSTSPEC}-pkg-config \
#|
#|
#|## ,-----
#|## |	Install
#|## +-----
#|
#|${CTI_PKG_CONFIG_INSTALLED}: ${CTI_PKG_CONFIG_BUILT}
#|	echo "*** (i) INSTALLED -> $@ ***"
#|	( cd ${EXTTEMP}/${CTI_PKG_CONFIG_TEMP} || exit 1 ;\
#|		mkdir -p ${CTI_TC_ROOT}/usr/${TARGSPEC}/lib/pkgconfig ;\
#|		make install PKG_CONFIG=${TARGSPEC}-pkg-config \
#|	)
#|
#|.PHONY: cti-pkg-config
#|cti-pkg-config: cti-pkg-config ${CTI_PKG_CONFIG_INSTALLED}
#|#cti-pkg-config: nti-pkg-config cti-pkg-config ${CTI_PKG_CONFIG_INSTALLED}
#|
#|ALL_CTI_TARGETS+= cti-pkg-config
#|
#|##
#|
#|${NTI_PKG_CONFIG_INSTALLED}: ${NTI_PKG_CONFIG_BUILT}
#|	echo "*** (i) INSTALLED -> $@ ***"
#|	( cd ${EXTTEMP}/${NTI_PKG_CONFIG_TEMP} || exit 1 ;\
#|		mkdir -p ${NTI_TC_ROOT}/usr/${HOSTSPEC}/lib/pkgconfig ;\
#|		make install \
#|	)
#|#		make install PKG_CONFIG=${HOSTSPEC}-pkg-config \
#|
#|
#|.PHONY: nti-pkg-config
#|nti-pkg-config: nti-libiconv ${NTI_PKG_CONFIG_INSTALLED}
#|
#|ALL_NTI_TARGETS+= nti-pkg-config

endif	# HAVE_PKG_CONFIG_CONFIG
